//
//  GitHubReposResponse.swift
//  GithubProfileFinder
//
//  Created by Diego Monteagudo Diaz on 13/01/25.
//
import Foundation

struct GitHubReposResponse: Identifiable, Codable, Hashable {
    var id: Int
    var name: String
    var htmlUrl: String
    var isPrivate: Bool
    var updatedAt: String
    var stargazersCount: Int
    var topics: [String]
    var language: String?
    var forks: Int

    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case htmlUrl = "html_url"
        case isPrivate = "private"
        case updatedAt = "updated_at"
        case stargazersCount = "stargazers_count"
        case topics
        case language
        case forks
    }
}
