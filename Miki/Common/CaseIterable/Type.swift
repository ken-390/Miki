//
//  Type.swift
//  Miki
//
//  Created by 柴田健作 on 2022/10/10.
//

import Foundation
enum Type: CaseIterable {
    case basic
    case person
    case event

    var title: String {
        switch self {
        case .basic:
            return "Word"
        case .person:
            return "Person"
        case .event:
            return "Event"
        }
    }
}
