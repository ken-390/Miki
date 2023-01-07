//
//  Word.swift
//  Miki
//
//  Created by 柴田健作 on 2022/09/21.
//

import Foundation
import RealmSwift

class Word: Object{
    @objc dynamic var id: String? = nil
    @objc dynamic var type_id: Int = 0
    @objc dynamic var title: String? = nil
    @objc dynamic var text: String? = nil
    @objc dynamic var mediaId: String = ""
    var media: Media? = nil
    @objc dynamic var sectionId: String = ""
    var section: SectionItem? = nil
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override init(){
        self.title = ""
        self.text = ""
    }
    init(id: String, type_id: Int, title: String, text: String, mediaId: String, sectionId: String){
        self.id = id
        self.type_id = 0
        self.title = title
        self.text = text
        self.mediaId = mediaId
        if(mediaId != "") {
            self.media = GetMediaRecord().getMediaRecordById(id: mediaId)
        }
        self.sectionId = sectionId
        if(sectionId != "") {
            self.section = GetSectionItem.getSectionItemById(id: sectionId)
        }
    }
}
