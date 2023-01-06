//
//  Cell.swift
//  Miki
//
//  Created by 柴田健作 on 2022/11/21.
//

import Foundation

enum SegmentCell: CaseIterable {
    case chapter
    case review
    
    var text: String {
        switch self {
        case .chapter:
            return "チャプター"
        case .review:
            return "レビュー"
        }
    }
}
