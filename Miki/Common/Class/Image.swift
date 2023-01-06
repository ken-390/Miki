//
//  Image.swift
//  Miki
//
//  Created by 柴田健作 on 2022/10/22.
//

import Foundation
import RealmSwift

class Image: Object{
    @objc dynamic var id: String! = ""
    @objc dynamic var parent_id: String! = ""
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override init(){
    }
    init(id: String, parent_id: String){
        self.id = id
        self.parent_id = parent_id
    }
}
