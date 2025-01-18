//
//  NavigationController+extension.swift
//  GithubProfileFinder
//
//  Created by Diego Monteagudo Diaz on 17/01/25.
//
import SwiftUI

extension UINavigationController {
  open override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    navigationBar.topItem?.backButtonDisplayMode = .minimal
  }

}
