//
//  GitHubProfileFinderServices.swift
//  GithubProfileFinder
//
//  Created by Diego Monteagudo Diaz on 13/01/25.
//

import Foundation

protocol GitHubProfileFinderServicesProtocol {
    func fetchUser(id: String) async throws -> GitHubUserResponse
    func fetchRepos(reposUrl: String) async throws -> [GitHubReposResponse]
}

class GitHubProfileFinderServices: GitHubProfileFinderServicesProtocol, ObservableObject {
    var constantValues: GitHubProfileConstantValues

    init(constantValues: GitHubProfileConstantValues = GitHubProfileConstantValues()) {
        self.constantValues = constantValues
    }

    func fetchUser(id: String) async throws -> GitHubUserResponse {
        guard let url = URL(string: constantValues.basePathUrl + "\(id)") else {
            throw GitHubProfileErrors.invalidUrl
        }

        let request = URLRequest(url: url)
        print(url)
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            print(data)
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let fetchedData = try decoder.decode(GitHubUserResponse.self, from: data)
            return fetchedData
        } catch {
            throw GitHubProfileErrors.userNoValid
        }
    }
    
    func fetchRepos(reposUrl: String) async throws -> [GitHubReposResponse] {
        guard let url = URL(string: reposUrl) else {
            throw GitHubProfileErrors.invalidUrl
        }

        let request = URLRequest(url: url)
        print(url)
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            print(data)
            let decoder = JSONDecoder()
            let fetchedData = try decoder.decode([GitHubReposResponse].self, from: data)
            return fetchedData
        } catch {
            throw GitHubProfileErrors.userNoValid
        }
    }
    

}
