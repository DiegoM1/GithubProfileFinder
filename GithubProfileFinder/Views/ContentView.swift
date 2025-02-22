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
    @Environment(\.colorScheme) var colorScheme
    @AppStorage("scheme") var scheme: Bool = true
    @StateObject var model = Model()
    @State var searchText = ""

    @Query private var profiles: [RecentGithubProfile]

    var services: GitHubProfileFinderServicesProtocol

    var filteredProfiles: [RecentGithubProfile] {
        if searchText.isEmpty {
            profiles.reversed()
        } else {
            profiles.filter { profile in
                if let name = profile.user.name {
                    return name.contains(searchText) || profile.user.login.contains(searchText)
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
                        case .searching:
                            HStack {
                                    Text("Press search")
                                        .font(.headline)
                                    Image(systemName: "magnifyingglass.circle.fill")
                                        .resizable()
                                        .frame(width: 16, height: 16)
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
                        .onDelete { index in
                            deleteItems(offsets: index)
                        }
                    }
                }
            }
            .navigationTitle("GitHub Finder")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: GitHubUserResponse.self) { _ in
                ProfileDetails()
                    .ignoresSafeArea(.container, edges: .top)
                    .environmentObject(model)
            }
            .navigationDestination(for: RecentGithubProfile.self) { profile in
                ProfileDetails()
                    .ignoresSafeArea(.container, edges: .top)
                    .environmentObject(model)
                    .onAppear {
                        model.userInfo = profile.user
                        model.repositoriesInfo = profile.repositories
                    }
            }
            .toolbar {
                Button("", systemImage: scheme == true ? "moon.fill" : "sun.max.fill") {
                    scheme.toggle()
                }
                .tint(scheme ? .black : .white)
            }
        }
        .onChange(of: searchText, {
            if searchText.isEmpty {
                model.userInfo = nil
            } else {
                model.viewState = .searching
            }
        })
        .searchable(text: $searchText, prompt: Text("Search"))
        .tint(scheme ? .black : .white)
        .preferredColorScheme(scheme ? .light : .dark)
        .onSubmit(of: .search) {
            model.viewState = .loading
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
                modelContext.delete(filteredProfiles[index])
            }
        }
    }
}

#Preview {
    ContentView(services: GitHubProfileFinderServices())
        .modelContainer(for: RecentGithubProfile.self, inMemory: true)
}
