//
//  String+extension.swift
//  GithubProfileFinder
//
//  Created by Diego Monteagudo Diaz on 17/01/25.
//
import Foundation

extension String {

    func transformToDate() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return dateFormatter.date(from: self) ?? Date()
    }

    func formatterDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let createdAt = dateFormatter.date(from: self)

        return createdAt?.formatted(date: .long, time: .omitted) ?? ""
    }
}
