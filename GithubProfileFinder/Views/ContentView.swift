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
    @Query private var items: [Item]

    @State var searchText = ""
    @State var userData: GitHubUserResponse?
    @State var stateController: ViewStateController = .error
    var services: GitHubProfileFinderServicesProtocol
    
    init(services: GitHubProfileFinderServicesProtocol) {
        self.services = services
    }

    var body: some View {
        NavigationStack {
            List {
                Section("Result", content: {
                    switch stateController {
                    case .loading:
                        ProgressView()
                    case .success:
                        if let data = userData {
                            NavigationLink(value: data) {
                                SearchedAccountCell(userData: data)
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
            .navigationTitle("GitHub Finder")
            .navigationBarTitleDisplayMode(.large)
            .navigationDestination(for: GitHubUserResponse.self) { user in
                ProfileDetails(userData: user, services: services)
            }
        }
        .onChange(of: searchText, {
            if searchText.isEmpty {
                userData = nil
            }
        })
        .searchable(text: $searchText, prompt: Text("Search"))
        .onSubmit(of: .search) {
            Task {
                await fetchResults()
            }
        }

    }

    private func fetchResults() async {
        do {
            stateController = .loading
            userData = try await services.fetchUser(id: searchText)
            stateController = .success
        } catch {
            stateController = .error
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(timestamp: Date())
            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

#Preview {
    ContentView(services: GitHubProfileFinderServices())
        .modelContainer(for: Item.self, inMemory: true)
}
