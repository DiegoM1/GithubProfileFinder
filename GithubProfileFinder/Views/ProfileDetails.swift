//
//  ProfileDetails.swift
//  GithubProfileFinder
//
//  Created by Diego Monteagudo Diaz on 13/01/25.
//

import SwiftUI

struct ProfileDetails: View {

    @EnvironmentObject var model: Model
    @State var offSet = 0.0

    private var recentRepositories: [GitHubReposResponse]? {
        model.repositoriesInfo?.sorted { $0.updatedAt.transformToDate() < $1.updatedAt.transformToDate() }.suffix(4)
    }

    var body: some View {
        if let userInfo = model.userInfo {
            ScrollView {
                GeometryReader { geo in
                    let offset = geo.frame(in: .global).minY
                    VStack(alignment: .leading, spacing: 0) {
                        ZStack {
                            Color.green
                            Image("profileBackground")
                                .resizable()
                                .opacity(0.8)
                                .overlay(Divider().background(.green), alignment: .bottom)
                            AsyncImage(url: URL(string: userInfo.avatarUrl)) { image in
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
                                Text(userInfo.login)
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
                        .offset(y: min(0, -offset))
                        .padding(.horizontal, 12)
                        .padding(.top, 24)
                        if let recentRepositories = recentRepositories {
                            LazyVStack(alignment: .leading) {
                                Text("Recent Updated")
                                ForEach(recentRepositories) { repo in
                                    RepositorieCell(reposData: repo)
                                }
                            }
                            .offset(y: min(0, -offset))
                            .padding()
                        } else {
                            ProgressView()
                        }
                    }
                    .onAppear {
                        Task {
                            await model.fetchRepositories()
                        }
                    }
                }
                .coordinateSpace(name: "details")
                .onChange(of: offSet, { oldValue, newValue in
                    offSet = newValue
                })
                .onDisappear {
                    model.repositoriesInfo = nil
                }
            }
            .ignoresSafeArea(.container)
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
