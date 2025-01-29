//
//  ProfileDetailsHeaderView.swift
//  GithubProfileFinder
//
//  Created by Diego Monteagudo Diaz on 27/01/25.
//

import SwiftUI

extension ProfileDetails {
    struct ProfileDetailsHeaderView: View {
        let userInfo: GitHubUserResponse
        let height: CGFloat
        let colorScheme: ColorScheme

        init(userInfo: GitHubUserResponse, height: CGFloat, _ colorScheme: ColorScheme) {
            self.userInfo = userInfo
            self.height = height
            self.colorScheme = colorScheme
        }

        var body: some View {
            let imageSize = height * 0.45
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
    }
}
