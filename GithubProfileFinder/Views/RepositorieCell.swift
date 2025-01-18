//
//  RepositorieCell.swift
//  GithubProfileFinder
//
//  Created by Diego Monteagudo Diaz on 14/01/25.
//

import SwiftUI

struct RepositorieCell: View {
    @Environment(\.openURL) var openURL
    @Environment(\.colorScheme) var colorScheme

    var reposData: GitHubReposResponse

    init(reposData: GitHubReposResponse) {
        self.reposData = reposData
    }

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(reposData.name)
                    .multilineTextAlignment(.leading)
                    .font(.title2)
                    .fontWeight(.bold)
                Image(systemName: reposData.isPrivate ?  "lock" : "network")
                    .resizable()
                    .frame(width: 10, height: 10)
                Spacer()
            }
            HStack {
                ForEach(reposData.topics.prefix(4), id: \.self) { topic in
                    Text(topic)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .padding(.vertical, 4)
                        .padding(.horizontal, 8)
                        .foregroundStyle(.blue)
                        .background(RoundedRectangle(cornerRadius: 5).fill(.blue.opacity(0.1)))
                }
            }
            HStack(spacing: 16) {
                Text(reposData.language ?? "")
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .resizable()
                        .frame(width: 13, height: 13)
                    Text(String(reposData.stargazersCount))
                }
                HStack(spacing: 4) {
                    Image(systemName: "tuningfork")
                        .resizable()
                        .frame(width: 13, height: 13)
                    Text(String(reposData.forks))
                }
            }
            .foregroundStyle(.gray)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 6)
                .fill(Color("AccentColor"))
        )
        .compositingGroup()
        .shadow(color: colorScheme == .light ? .black : .white, radius: 3)
        .onTapGesture {
            guard let url = URL(string: reposData.htmlUrl) else { return }
            openURL(url)
        }
    }
    
}

#Preview {
    RepositorieCell(reposData: GitHubReposResponse(id: 2, name: "Dota2", htmlUrl: "https://github.com/DiegoM1", isPrivate: true, updatedAt: "2025-01-14T02:01:56Z", stargazersCount: 10, topics: ["Xcode", "Swift", "Dota2", "Mobile"], language: "Swift", forks: 10))
}
