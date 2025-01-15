//
//  item.swift
//  GithubProfileFinder
//
//  Created by Diego Monteagudo Diaz on 13/01/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date

    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
