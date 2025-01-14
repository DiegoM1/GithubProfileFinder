//
//  GitHubReposResponse.swift
//  GithubProfileFinder
//
//  Created by Diego Monteagudo Diaz on 13/01/25.
//
import Foundation

struct GitHubReposResponse: Identifiable, Decodable, Hashable {
    var id: Int
    var name: String
    var isPrivate: Bool
    var updatedAt: String
    var stargazersCount: Int
    var topics: [String]
    var language: String?
    var forks: Int

    func formatterDate() -> Date {
        let formatter = ISO8601DateFormatter()

        formatter.formatOptions = [
            .withDashSeparatorInDate,
            .withFullDate
        ]

        return formatter.date(from: self.updatedAt) ?? Date()
    }

    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case isPrivate = "private"
        case updatedAt = "updated_at"
        case stargazersCount = "stargazers_count"
        case topics
        case language
        case forks
    }
}
