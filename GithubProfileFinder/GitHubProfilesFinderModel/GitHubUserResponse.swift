//
//  GitHubUserResponse.swift
//  GithubProfileFinder
//
//  Created by Diego Monteagudo Diaz on 13/01/25.
//
import Foundation

struct GitHubUserResponse: Identifiable, Decodable, Hashable {
    var id: Int
    var login: String
    var avatarUrl: String
    var url: String
    var reposUrl: String
    var followers: Int
    var following: Int
    var updatedAt: String
    
    func formatterDate() -> Date {
        let formatter = ISO8601DateFormatter()

        formatter.formatOptions = [
            .withDashSeparatorInDate,
            .withFullDate
        ]

        return formatter.date(from: self.updatedAt) ?? Date()
    }
}
