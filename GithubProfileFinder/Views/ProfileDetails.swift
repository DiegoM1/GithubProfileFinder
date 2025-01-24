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
        model.repositoriesInfo?.sorted { $0.updatedAt.transformToDate() < $1.updatedAt.transformToDate() }.suffix(10)
    }

    var body: some View {
        if let userInfo = model.userInfo {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .center, spacing: 0) {
                    HeaderView(userInfo: userInfo)
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
                        LazyVStack(alignment: .leading) {
                            Text("Recent Updated")
                            ForEach(recentRepositories) { repo in
                                RepositorieCell(reposData: repo)
                            }
                        }
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
                .overlay(alignment: .top) {
                    CustomToolbar(userInfo: userInfo)
                }
            }
            .toolbar(.hidden)

            .onDisappear {
                model.repositoriesInfo = nil
            }
            .coordinateSpace(name: "details")
        }
    }

    @ViewBuilder
    func CustomToolbar(userInfo: GitHubUserResponse) -> some View {
        GeometryReader { geo in
            let minY = geo.frame(in: .named("details")).minY
            let _ = print("Min Y: \(minY)")
            let height = size * 0.45
            let progress = minY / (height * (minY > 0 ? 0.5 : 0.8))
            let titleProgress = minY / height
            let _ = print(progress, titleProgress)

            HStack(spacing: 15) {
                Button {
                    dismiss()
                } label: {
                    HStack {
                        Image(systemName: "chevron.left")
                            .font(.title3)
                            .foregroundStyle(colorScheme == .light ? .black : .white)
                    }
                    .frame(width: 30, height: 30)
                }
                .padding(.leading, 15)
                .padding(.bottom, 15)
                Spacer()
            }
            .overlay {
                Text(userInfo.login)
                    .fontWeight(.bold)
                    .foregroundStyle(colorScheme == .light ? .black : .white)
                    .padding()
                    .offset(y: -titleProgress > 0.85 ? 0 : 45)
                    .clipped()
                    .animation(.easeOut(duration: 0.25), value: -titleProgress > 0.75)
            }
            .padding(.top, geo.safeAreaInsets.top + 100)
            .background {
                Color.accent.opacity(-progress > 1 ? 1 : 0)
            }
            .frame(height: 36 + geo.safeAreaInsets.top)
            .offset(y: -minY)

        }
        .frame(height: 36)
    }

    @ViewBuilder
    func HeaderView(userInfo: GitHubUserResponse ) -> some View {
        let imageSize = size * 0.45
        GeometryReader { geo in
            let size = geo.size
            let offSet = geo.frame(in: .named("details")).minY
            let progress = offSet / (imageSize * 0.8)
            ZStack {
                Color.green
                Image("profileBackground")
                    .resizable()
                    .scaledToFill()
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
                .frame(width: offSet > 0 ? imageSize / 2 + offSet / 3 : imageSize / 2, height: offSet > 0 ? imageSize / 2 + offSet / 3 : imageSize / 2)
            }
            .frame(width: size.width, height: size.height + (offSet > 0 ? offSet : 0))
            .overlay {
                ZStack(alignment: .bottom) {
                    Rectangle()
                        .fill(.linearGradient(colors: getGradient(colorScheme == .light ? .white : .black, progress: progress),
                                              startPoint: .center,
                                              endPoint: .bottom))
                    VStack {
                        Text(userInfo.login)
                            .font(.title)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                    }
                    .padding(50)
                }
            }
            .offset(y: offSet > 0 ? -offSet : 0)
        }
        .frame(height: imageSize + 100)

    }

    private func getGradient(_ color: Color, progress: CGFloat) -> [Color] {
        return  [color.opacity(0 - progress),
                 color.opacity(0.1 - progress),
                 color.opacity(0.3 - progress),
                 color.opacity(0.5 - progress),
                 color.opacity(0.8 - progress),
                 color.opacity(1 - progress)]
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
