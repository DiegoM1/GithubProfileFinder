//
//  GithubProfileFinderApp.swift
//  GithubProfileFinder
//
//  Created by Diego Monteagudo Diaz on 13/01/25.
//

import SwiftUI

@main
struct GithubProfileFinderApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView(services: GitHubProfileFinderServices())
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
