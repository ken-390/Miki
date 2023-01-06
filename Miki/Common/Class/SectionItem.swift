//
//  SectionItem.swift
//  Miki
//
//  Created by 柴田健作 on 2022/09/21.
//

import Foundation
import RealmSwift

class SectionItem: Object{
    @objc dynamic var id: String! = ""
    @objc dynamic var title: String! = ""
    @objc dynamic var sortId: Int = -1
    @objc dynamic var parentMedia_id: String! = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override init(){
    }
    init(id: String, title: String, sortId: Int, parentMedia_id: String) {
        self.id = id
        self.title = title
        self.sortId = sortId
        self.parentMedia_id = parentMedia_id
    }
}
