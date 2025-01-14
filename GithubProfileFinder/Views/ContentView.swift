//
//  ContentView.swift
//  GithubProfileFinder
//
//  Created by Diego Monteagudo Diaz on 13/01/25.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State var searchText = ""

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
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
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
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
    ContentView(services: GitHubProfileFinderServices()).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
