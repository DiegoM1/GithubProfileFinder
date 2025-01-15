//
//  GitHubUserResponse.swift
//  GithubProfileFinder
//
//  Created by Diego Monteagudo Diaz on 13/01/25.
//
import Foundation

struct GitHubUserResponse: Identifiable, Decodable, Hashable {
    var id: Int
    var name: String?
    var login: String
    var avatarUrl: String
    var url: String
    var reposUrl: String
    var followers: Int
    var following: Int
    var createdAt: String
    var publicRepos: Int


    func formatterDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let createdAt = dateFormatter.date(from: self.createdAt)

        return createdAt?.formatted(date: .long, time: .omitted) ?? ""
    }
}
