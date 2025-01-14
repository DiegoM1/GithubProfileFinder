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
            } placeholder: {
                ProgressView()
            }
            .frame(width: 50, height: 50)

            VStack {
                Text(userData.login)
                Text(userData.updatedAt)
            }
        }
    }
}

#Preview {
    SearchedAccountCell(userData: GitHubUserResponse(id: 1, login: "diego", avatarUrl: "", url: "", reposUrl: "", followers: 2, following: 3, updatedAt: ""))
}
