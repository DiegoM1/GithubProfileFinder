//
//  GitHubProfileFinderMockServices.swift
//  GithubProfileFinder
//
//  Created by Diego Monteagudo Diaz on 28/01/25.
//

import Foundation

class GitHubProfileFinderMockServices: GitHubProfileFinderServicesProtocol {
    var constantValues: GitHubProfileConstantValues

    init(constantValues: GitHubProfileConstantValues = GitHubProfileConstantValues()) {
        self.constantValues = constantValues
    }

    func fetchUser(id: String) async throws -> GitHubUserResponse {
        guard !id.isEmpty else {
            throw GitHubProfileErrors.userNoValid
        }
        if let url: URL = Bundle.main.url(forResource: "UserMockResponse", withExtension: "json") {
            if let data = try? Data(contentsOf: url) {
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    return try decoder.decode(GitHubUserResponse.self, from: data as Data)
                } catch {
                    throw GitHubProfileErrors.userNoValid
                }
            }
        }
        throw GitHubProfileErrors.invalidUrl
    }

    func fetchRepos(reposUrl: String) async throws -> [GitHubReposResponse] {
        guard let url = URL(string: reposUrl) else {
            throw GitHubProfileErrors.invalidUrl
        }

        if let url = Bundle.main.url(forResource: "RepositoriesMockResponse", withExtension: "json") {
            if let data = try? Data(contentsOf: url) {
                do {
                    return try JSONDecoder().decode([GitHubReposResponse].self, from: data as Data)
                } catch {
                    throw GitHubProfileErrors.invalidUrl
                }
            }
        }
        throw GitHubProfileErrors.userNoValid
    }
}
