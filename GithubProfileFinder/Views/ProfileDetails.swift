//
//  ProfileDetails.swift
//  GithubProfileFinder
//
//  Created by Diego Monteagudo Diaz on 13/01/25.
//

import SwiftUI

struct ProfileDetails: View {
    var userData: GitHubUserResponse
    var services: GitHubProfileFinderServicesProtocol
    @State var reposData: [GitHubReposResponse]?

    init(userData: GitHubUserResponse, services: GitHubProfileFinderServicesProtocol) {
        self.userData = userData
        self.services = services
    }

    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            ZStack {
                Image("background")
                    .resizable()
                    .opacity(0.8)
                VStack {
                    AsyncImage(url: URL(string: userData.avatarUrl)) { image in
                        image
                            .resizable()
                            .clipShape( Circle())
                            .overlay(Circle().stroke(Color.white, lineWidth: 4))
                            .scaledToFill()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 100, height: 100)
                    Text(userData.login)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .padding(.vertical, 4)
                        .padding(.horizontal, 24)
                        .background(RoundedRectangle(cornerRadius: 30).fill(.green))
                }
            }
            .frame(height: 240)
            .ignoresSafeArea(.container)

            HStack(spacing: 30) {
                VStack(alignment: .center) {
                    Text(String(reposData?.count ?? 0))
                    Text("Repositories")
                }
                
                VStack(alignment: .center) {
                    Text("\(self.getStarts())")
                    Text("Stars")
                }

                VStack(alignment: .center) {
                    Text(String(userData.followers))
                    Text("Followers")
                }

                VStack(alignment: .center) {
                    Text(String(userData.following))
                    Text("Following")
                }

            }
            .padding(.horizontal, 12)
            if let repos = reposData {
                List(repos.sorted { $0.formatterDate() > $1.formatterDate() }.prefix(4)) { repo in
                    VStack {
                        Text(repo.name)
                    }
                }
            }
        }
        .onAppear {
            Task {
                reposData = try await services.fetchRepos(reposUrl: userData.reposUrl)
            }
        }
    }


    private func getStarts() -> Int {
        reposData?.reduce(0, { partialResult, response in
            partialResult + response.stargazersCount
        }) ?? 0
    }

}

#Preview {
    ProfileDetails(userData: GitHubUserResponse(id: 1, login: "DiegoM1", avatarUrl: "https://avatars.githubusercontent.com/u/54748910?v=4", url: "https://api.github.com/users/DiegoM1/repos", reposUrl: "https://api.github.com/users/DiegoM1/repos", followers: 2, following: 3, updatedAt: "2025-01-14T02:01:56Z"), services: GitHubProfileFinderServices())
}
