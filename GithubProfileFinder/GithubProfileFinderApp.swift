//
//  GithubProfileFinderApp.swift
//  GithubProfileFinder
//
//  Created by Diego Monteagudo Diaz on 13/01/25.
//

import SwiftUI
import SwiftData

@main
struct GithubProfileFinderApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            RecentGithubProfile.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView(services: GitHubProfileFinderServices())
                .modelContainer(sharedModelContainer)
        }
    }
}
