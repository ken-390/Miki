//
//  MediaType.swift
//  Miki
//
//  Created by 柴田健作 on 2022/11/08.
//

import Foundation
enum MediaType: CaseIterable {
    case book
    case movie
    static var all: [MediaType] = [.book, .movie]

    var title: String {
        switch self {
        case .book:
            return "Book"
        case .movie:
            return "Movie"
        }
    }
}
