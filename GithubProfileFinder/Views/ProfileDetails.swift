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
    @State var offSet = 0.0

    init(userData: GitHubUserResponse, services: GitHubProfileFinderServicesProtocol) {
        self.userData = userData
        self.services = services
    }

    var body: some View {
            ScrollView {
                GeometryReader { geo in
                    let offset = geo.frame(in: .global).minY
                VStack(alignment: .leading, spacing: 0) {
                    ZStack {
                        Color.green
                        Image("background2")
                            .resizable()
                            .opacity(0.8)
                        AsyncImage(url: URL(string: userData.avatarUrl)) { image in
                            image
                                .resizable()
                                .clipShape( Circle())
                                .overlay(Circle().stroke(Color.white, lineWidth: 4))
                                .scaledToFill()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 120, height: 120)
                        VStack {
                            Spacer()
                            Text(userData.login)
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                                .padding(.vertical, 4)
                                .padding(.horizontal, 24)
                                .background(RoundedRectangle(cornerRadius: 30).fill(.green))
                                .offset(y: 15)
                        }
                    }
                    .offset(y: min(0, -offset))
                    .frame(height: max(240, 240 + offset))

                    HStack(spacing: 30) {
                        VStack(alignment: .center) {
                            Text(String(reposData?.count ?? 0))
                                .fontWeight(.black)
                            Text("repositories")
                                .fontWeight(.light)
                                .foregroundStyle(.gray)
                        }

                        VStack(alignment: .center) {
                            Text("\(self.getStarts())")
                                .fontWeight(.black)
                            Text("Stars")
                                .fontWeight(.light)
                                .foregroundStyle(.gray)
                        }

                        VStack(alignment: .center) {
                            Text(String(userData.followers))
                                .fontWeight(.black)
                            Text("Followers")
                                .fontWeight(.light)
                                .foregroundStyle(.gray)
                        }

                        VStack(alignment: .center) {
                            Text(String(userData.following))
                                .fontWeight(.black)
                            Text("Following")
                                .fontWeight(.light)
                                .foregroundStyle(.gray)
                        }

                    }
                    .offset(y: min(0, -offset))
                    .padding(.horizontal, 12)
                    .padding(.top, 24)
                    if let repos = reposData {
                        VStack(alignment: .leading) {
                            Text("Recent Updated")
                            ForEach(repos.sorted { $0.formatterDate() < $1.formatterDate() }.suffix(4)) { repo in
                                RepositorieCell(reposData: repo)
                                    .foregroundStyle(.black)
                            }
                        }
                        .offset(y: min(0, -offset))
                        .padding()
                    }
                }
                .onAppear {
                    Task {
                        reposData = try await services.fetchRepos(reposUrl: userData.reposUrl)
                    }
                }
            }
            .coordinateSpace(name: "details")
            .onChange(of: offSet, { oldValue, newValue in
                offSet = newValue
                print(newValue)
            })
        }
        .ignoresSafeArea(.container)
    }


    private func getStarts() -> Int {
        reposData?.reduce(0, { partialResult, response in
            partialResult + response.stargazersCount
        }) ?? 0
    }

}

#Preview {
    ProfileDetails(userData: GitHubUserResponse(id: 1, name: "Diego Monteagudo", login: "DiegoM1", avatarUrl: "https://avatars.githubusercontent.com/u/54748910?v=4", url: "https://api.github.com/users/DiegoM1/repos", reposUrl: "https://api.github.com/users/DiegoM1/repos", followers: 2, following: 3, createdAt: "2025-01-14T02:01:56Z", publicRepos: 21), services: GitHubProfileFinderServices())
}
