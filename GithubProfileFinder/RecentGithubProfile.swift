//
//  RecentGithubProfile.swift
//  GithubProfileFinder
//
//  Created by Diego Monteagudo Diaz on 13/01/25.
//

import Foundation
import SwiftData

protocol ModelDataProtocol {
    var user: GitHubUserResponse { get set }
    var repositories: [GitHubReposResponse] { get set }
}

@Model
final class RecentGithubProfile: ModelDataProtocol {
    @Attribute(.unique) var id: Int
    var user: GitHubUserResponse
    var repositories: [GitHubReposResponse]

    init(id: Int, user: GitHubUserResponse, repositories: [GitHubReposResponse]) {
        self.id = id
        self.user = user
        self.repositories = repositories
    }
}
