//
//  Category.swift
//  Miki
//
//  Created by 柴田健作 on 2022/11/09.
//

import Foundation

class ClassByMedia{
    var mediaType: MediaType = .book
    var categorys: [Any] = []
    var categoryNames: [String] = []
    
    init(mediaType: MediaType){
        self.mediaType = mediaType
        switch mediaType {
        case .book:
            self.categorys = bookType.allCases
            for cate in bookType.allCases {
                categoryNames.append(cate.title)
            }
        case .movie:
            self.categorys = movieType.allCases
            for cate in movieType.allCases {
                categoryNames.append(cate.title)
            }
        }
    }
}

enum bookType: CaseIterable {
    case nobel
    case business
    var title: String {
        switch self {
        case .nobel:
            return "小説"
        case .business:
            return "ビジネス書"
        }
    }
}
enum movieType: CaseIterable {
    case sf
    var title: String {
        switch self {
        case .sf:
            return "SF"
        }
    }
}
