//
//  Media.swift
//  Miki
//
//  Created by 柴田健作 on 2022/11/09.
//

import Foundation
import RealmSwift

class Media: Object{
    @objc dynamic var id: String! = ""
    var type: MediaType = .book
    @objc dynamic var typeIdx: Int = 0
    var categoryName = "Other"
    @objc dynamic var categoryIdx: Int = -1
    @objc dynamic var title: String! = ""
    @objc dynamic var date: String! = ""
    @objc dynamic var summary: String! = ""
    @objc dynamic var point: Double = 1.0
    @objc dynamic var comment: String! = ""
    var author: Word? = nil
    @objc dynamic var author_id: String! = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override init(){
    }
    init(id: String, typeIdx: Int,  title: String, date: String, summary: String, point: Double
         , comment: String, categoryIdx: Int, author_id: String){
        self.id = id
        self.type = MediaType.allCases[typeIdx]
        self.typeIdx = Int(typeIdx)
        self.title = title
        self.date = date
        self.summary = summary
        self.comment = comment
        self.point = point
        if(categoryIdx == -1){
            self.categoryName = "Other"
        } else {
            self.categoryName = ClassByMedia(mediaType: self.type).categoryNames[categoryIdx]
        }
        self.categoryIdx = categoryIdx
        if(author_id != ""){
            self.author = GetWordRecords().getWordRecordById(word: Word(id: author_id, type_id: 0, title: "", text: "", mediaId: "", sectionId: ""))
            self.author_id = author_id
        }
    }
}
