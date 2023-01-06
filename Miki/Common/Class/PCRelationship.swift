//
//  PCRelationship.swift
//  Miki
//
//  Created by 柴田健作 on 2022/11/12.
//


import Foundation
import RealmSwift

class PCRelationship: Object{
    @objc dynamic var id: String? = nil
    @objc dynamic var parent_id: String? = nil
    @objc dynamic var child_id: String? = nil
    var parent: Media? = nil
    var child: Word? = nil
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override init(){
    }
    init(id: String,
        parent_id: String,
         child_id: String,
         rel_type_id: Int){
        self.id = id
        
        self.parent = GetMediaRecord().getMediaRecordById(id: parent_id)
        let key = Word()
        key.id = child_id
        self.child = GetWordRecords().getWordRecordById(word: key)
    }
}
