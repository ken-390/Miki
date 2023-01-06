//
//  Relationship.swift
//  Miki
//
//  Created by 柴田健作 on 2022/10/14.
//

import Foundation
import RealmSwift

class Relationship: Object{
    @objc dynamic var id: String? = nil
    @objc dynamic var source_id: String? = nil
    @objc dynamic var related_id: String? = nil
    @objc dynamic var rel_type_id: Int = -1
    var source: Word? = nil
    var related: Word? = nil
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override init(){
    }
    init(id: String,
        source_id: String,
         related_id: String,
         rel_type_id: Int){
        self.id = id
        self.source_id = source_id
        self.related_id = related_id
        self.rel_type_id = rel_type_id
        
        let method = GetWordRecords()
        let key = Word()
        key.id = source_id
        self.source = method.getWordRecordById(word: key)
        key.id = related_id
        self.related = method.getWordRecordById(word: key)
    }
}
