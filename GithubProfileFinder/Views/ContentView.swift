//
//  ContentView.swift
//  GithubProfileFinder
//
//  Created by Diego Monteagudo Diaz on 13/01/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var profiles: [RecentGithubProfile]

    @StateObject var model = Model()
    @State var searchText = ""
    var services: GitHubProfileFinderServicesProtocol

    var filteredProfiles: [RecentGithubProfile] {
        if searchText.isEmpty {
            profiles
        } else {
            profiles.filter { profile in
                if let name = profile.user.name {
                    return name.contains(searchText)
                }
                return profile.user.login.contains(searchText.lowercased())
            }
        }
    }

    init(services: GitHubProfileFinderServicesProtocol) {
        self.services = services
    }

    var body: some View {
        NavigationStack {
            List {
                if !searchText.isEmpty {
                    Section("Result", content: {
                        switch model.viewState {
                        case .loading:
                            ProgressView()
                        case .success:
                            if let userInfo = model.userInfo {
                                NavigationLink(value: userInfo) {
                                    SearchedAccountCell(userData: userInfo)
                                }
                            }
                        case .error:
                            HStack {
                                Spacer()
                                VStack(alignment: .center) {
                                    Text("User not found")
                                        .font(.headline)
                                        .padding()
                                    Image(systemName: "person.crop.circle.badge.exclamationmark")
                                        .resizable()
                                        .frame(width: 45, height: 40)
                                }
                                Spacer()
                            }
                        }
                    })
                }

                if !filteredProfiles.isEmpty {
                    Section("Recents") {
                        ForEach(filteredProfiles) { info in
                            NavigationLink(value: info) {
                                SearchedAccountCell(userData: info.user)
                            }
                        }
                    }
                }
            }
            .navigationTitle("GitHub Finder")
            .navigationBarTitleDisplayMode(.large)
            .navigationDestination(for: GitHubUserResponse.self) { _ in
                ProfileDetails()
                    .environmentObject(model)
            }
            .navigationDestination(for: RecentGithubProfile.self) { profile in
                ProfileDetails()
                    .environmentObject(model)
                    .onAppear {
                        model.userInfo = profile.user
                        model.repositoriesInfo = profile.repositories
                    }
            }
        }
        .onChange(of: searchText, {
            if searchText.isEmpty {
                model.userInfo = nil
            }
        })
        .searchable(text: $searchText, prompt: Text("Search"))
        .onSubmit(of: .search) {
            Task {
                await model.fetchResults(searchText)
            }
        }
        .onAppear {
            model.modelContext = modelContext
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(profiles[index])
            }
        }
    }
}

#Preview {
    ContentView(services: GitHubProfileFinderServices())
        .modelContainer(for: RecentGithubProfile.self, inMemory: true)
}
