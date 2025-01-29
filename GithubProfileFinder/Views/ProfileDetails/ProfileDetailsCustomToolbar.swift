//
//  ProfileDetailsCustomToolbar.swift
//  GithubProfileFinder
//
//  Created by Diego Monteagudo Diaz on 27/01/25.
//
import SwiftUI

extension ProfileDetails {
    struct ProfileDetailsCustomToolbar: View {
        let userInfo: GitHubUserResponse
        let height: CGFloat
        let colorScheme: ColorScheme
        let dismiss: DismissAction

        init(userInfo: GitHubUserResponse, height: CGFloat, ColorScheme: ColorScheme, _ dismiss: DismissAction) {
            self.userInfo = userInfo
            self.height = height
            self.colorScheme = ColorScheme
            self.dismiss = dismiss
        }

        var body: some View {
            GeometryReader { geo in
                let minY = geo.frame(in: .named("details")).minY
                let height = height * 0.45
                let progress = minY / (height * (minY > 0 ? 0.5 : 0.8))
                let titleProgress = minY / height

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
                        .animation(.easeOut(duration: 0.25), value: -titleProgress > 0.85)
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
    }
}
