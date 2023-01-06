//
//  Dao_sectionItem.swift
//  Miki
//
//  Created by 柴田健作 on 2022/11/17.
//

import Foundation
import RealmSwift

class Dao_sectionItem {
    let realm = try! Realm()
    // Create
    func add(sectionItem: SectionItem) -> Void{
        try! realm.write{
            realm.add(sectionItem)
        }
    }
    
    // Read
    func getRecords(parentId: String) -> Results<SectionItem>{
        return realm.objects(SectionItem.self).filter("parentMedia_id == %@", parentId).sorted(byKeyPath: "sortId")
    }
    func getRecordById(id: String) -> Results<SectionItem>{
        return realm.objects(SectionItem.self).filter("id == %@", id)
    }
    
    // Update
    func update(target: Results<SectionItem>, data: SectionItem) -> Void{
        try! realm.write{
            target[0].title = data.title
            target[0].sortId = data.sortId
            target[0].parentMedia_id = data.parentMedia_id
        }
    }
    
    // Delete
    func delete(target: Results<Word>) -> Void{
//        try! realm.write{
//            realm.delete(target[0])
//        }
    }
}
