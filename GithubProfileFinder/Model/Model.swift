//
//  Model.swift
//  GithubProfileFinder
//
//  Created by Diego Monteagudo Diaz on 15/01/25.
//

import SwiftUI
import SwiftData

@MainActor
class Model: ObservableObject {
    var services: GitHubProfileFinderServicesProtocol
    var modelContext: ModelContext?
    @Published var viewState: ViewStateController = .loading
    @Published var userInfo: GitHubUserResponse?
    @Published var repositoriesInfo: [GitHubReposResponse]?

    init(services: GitHubProfileFinderServicesProtocol = GitHubProfileFinderServices(), modelContext: ModelContext? = nil, viewState: ViewStateController = .loading, userInfo: GitHubUserResponse? = nil, repositoriesInfo: [GitHubReposResponse]? = nil) {
        self.services = services
        self.modelContext = modelContext
        self.viewState = viewState
        self.userInfo = userInfo
        self.repositoriesInfo = repositoriesInfo
    }

    func fetchResults(_ searchText: String) async {
        do {
            viewState = .loading
            userInfo = try await services.fetchUser(id: searchText)
            viewState = .success
        } catch {
            viewState = .error
        }
    }

    func fetchRepositories() async {
        guard let reposUrl = userInfo?.reposUrl else {
            return
        }
        do {
            repositoriesInfo = try await services.fetchRepos(reposUrl: reposUrl)
            addRecentProfile()
        } catch {
            print(error)
        }
    }

    private func addRecentProfile() {
        guard let userInfo = userInfo, let repositories = repositoriesInfo else {
            return
        }
        let newItem = RecentGithubProfile(id: userInfo.id, user: userInfo, repositories: repositories)
        let fetchDescriptor = FetchDescriptor<RecentGithubProfile>()
        let data = try? modelContext?.fetch(fetchDescriptor)
        if data?.contains(where: { $0.id == userInfo.id }) ?? false {
            return
        }
        if data?.count ?? 0 >= 5 {
            modelContext?.delete(data?.first ?? newItem)
            modelContext?.insert(newItem)
        } else {
            modelContext?.insert(newItem)
        }
        withAnimation {
            try? modelContext?.save()
        }
    }
}
