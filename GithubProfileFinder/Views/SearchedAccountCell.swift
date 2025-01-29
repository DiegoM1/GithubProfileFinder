//
//  SearchedAccountCell.swift
//  GithubProfileFinder
//
//  Created by Diego Monteagudo Diaz on 13/01/25.
//

import SwiftUI

struct SearchedAccountCell: View {
    var userData: GitHubUserResponse

    init(userData: GitHubUserResponse) {
        self.userData = userData
    }

    var body: some View {
        HStack {
            AsyncImage(url: URL(string: userData.avatarUrl)) { image in
                image
                    .resizable()
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            } placeholder: {
                ProgressView()
            }
            .frame(width: 60, height: 60)
            VStack(alignment: .leading) {
                Text(userData.login)
                    .font(.title)
                    .fontWeight(.bold)
                if let name = userData.name {
                    Text(name)
                        .font(.title3)
                        .fontWeight(.semibold)
                    if let location = userData.location {
                        Text(location)
                            .font(.subheadline)
                            .fontWeight(.light)
                    }
                }
                HStack(alignment: .bottom) {
                    Text("\(userData.createdAt.formatterDate())")
                        .font(.footnote)
                        .fontWeight(.light)
                    Spacer()
                    VStack {
                        Text("\(userData.publicRepos)")
                            .fontWeight(.black)
                        Text("Repositories")
                            .fontWeight(.light)
                    }
                }
            }
        }
    }
}

#Preview {
    SearchedAccountCell(userData: GitHubUserResponse(id: 1, name: "Diego Monteagudo", login: "Diego", avatarUrl: "https://avatars.githubusercontent.com/u/54748910?v=4", url: "", location: "Peru", reposUrl: "", followers: 2, following: 3, createdAt: "2019-08-31T17:00:49Z", publicRepos: 21))
}
