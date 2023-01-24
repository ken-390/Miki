//
//  Dao_media.swift
//  Miki
//
//  Created by 柴田健作 on 2022/11/09.
//

import Foundation
import RealmSwift

class Dao_media {
    let realm = try! Realm()
    // Create
    func addMedia(media: Media) -> Void{
        try! realm.write{
            realm.add(media)
        }
    }
    // Read
    func getMedias() -> Results<Media>{
        return realm.objects(Media.self).sorted(byKeyPath: "title")
    }
    func getMediasByTypeIdx(typeIdx: Int, key: String) -> Results<Media>{
        return realm.objects(Media.self).filter("typeIdx == \(typeIdx)").sorted(byKeyPath: key)
    }
    func getMediaById(id: String) -> Results<Media>{
        return realm.objects(Media.self).filter("id == %@", id)
    }
    
    // Update
    func update(target: Results<Media>, data: Media) -> Void{
        try! realm.write{
            target[0].typeIdx = data.typeIdx
            target[0].title = data.title
            target[0].date = data.date
            target[0].summary = data.summary
            target[0].point = data.point
            target[0].comment = data.comment
            target[0].categoryIdx = data.categoryIdx
            target[0].author_id = data.author_id
        }
    }
    
    // Delete
    func delete(id: String) -> Void{
        let target = self.getMediaById(id: id)
        try! realm.write{
            realm.delete(target[0])
        }
    }
}
