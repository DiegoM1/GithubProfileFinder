//
//  ProfileDetails.swift
//  GithubProfileFinder
//
//  Created by Diego Monteagudo Diaz on 13/01/25.
//

import SwiftUI

struct ProfileDetails: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var model: Model

    private let size = UIScreen.main.bounds.height

    private var recentRepositories: [GitHubReposResponse]? {
        model.repositoriesInfo?.sorted { $0.updatedAt.transformToDate() < $1.updatedAt.transformToDate() }.suffix(10).reversed()
    }

    var body: some View {
        if let userInfo = model.userInfo {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .center, spacing: 0) {
                    ProfileDetailsHeaderView(userInfo: userInfo, height: size)
                    Spacer(minLength: 0)
                    if let name = userInfo.name {
                        Text(name)
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                            .padding(.vertical, 4)
                            .padding(.horizontal, 24)
                            .background(RoundedRectangle(cornerRadius: 30).fill(.green))
                            .padding(.top, -17)
                    }
                    HStack(spacing: 25) {
                        VStack(alignment: .center) {
                            if let repositoriesInfo = model.repositoriesInfo {
                                Text(String(repositoriesInfo.count))
                                    .fontWeight(.black)
                            } else {
                                ProgressView()
                            }
                            Text("Repositories")
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
                            Text(String(userInfo.followers))
                                .fontWeight(.black)
                            Text("Followers")
                                .fontWeight(.light)
                                .foregroundStyle(.gray)
                        }
                        VStack(alignment: .center) {
                            Text(String(userInfo.following))
                                .fontWeight(.black)
                            Text("Following")
                                .fontWeight(.light)
                                .foregroundStyle(.gray)
                        }

                    }
                    .padding(.horizontal, 12)
                    .padding(.top, 24)
                    if let recentRepositories = recentRepositories {
                        if recentRepositories.isEmpty {
                            VStack {
                                Image(systemName: "text.page.slash")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                Text("No Repositories Found")
                                    .font(.title2)
                                    .fontWeight(.medium)
                            }
                            .padding()
                        } else {
                            LazyVStack(alignment: .leading) {
                                Text("Recent Updated")
                                ForEach(recentRepositories) { repo in
                                    RepositorieCell(reposData: repo)
                                        .padding(.bottom, 15)
                                }
                            }
                            .padding()
                        }
                    } else {
                        ProgressView()
                    }
                }
                .onAppear {
                    Task {
                        if model.repositoriesInfo == nil {
                            await model.fetchRepositories()
                        }
                    }
                }
                .overlay(alignment: .top) {
                    ProfileDetailsCustomToolbar(userInfo: userInfo, height: size, ColorScheme: colorScheme, dismiss)
                }
            }
            .toolbar(.hidden)
            .onDisappear {
                model.repositoriesInfo = nil
            }
            .coordinateSpace(name: "details")
        }
    }

    private func getStarts() -> Int {
        model.repositoriesInfo?.reduce(0, { partialResult, response in
            partialResult + response.stargazersCount
        }) ?? 0
    }
}

#Preview {
    ProfileDetails()
}
