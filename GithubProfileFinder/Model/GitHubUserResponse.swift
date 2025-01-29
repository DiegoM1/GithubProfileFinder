//
//  GitHubUserResponse.swift
//  GithubProfileFinder
//
//  Created by Diego Monteagudo Diaz on 13/01/25.
//
import Foundation
import SwiftData

struct GitHubUserResponse: Identifiable, Codable, Hashable {
    var id: Int
    var name: String?
    var login: String
    var avatarUrl: String
    var url: String
    var location: String?
    var reposUrl: String
    var followers: Int
    var following: Int
    var createdAt: String
    var publicRepos: Int
}
