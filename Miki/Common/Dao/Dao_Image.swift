//
//  Dao_Image.swift
//  Miki
//
//  Created by 柴田健作 on 2022/10/23.
//

import Foundation
import RealmSwift
class Dao_Image {
    let realm = try! Realm()
    // Create
    func addImage(target: Image) -> Void{
        try! realm.write{
            realm.add(target)
        }
    }
    
    // Read
    func getImageById(key: Image) -> Results<Image>{
        return realm.objects(Image.self).filter("id == %@", key.id! as String)
    }
    func getImageBySourceId(parent_id: String) -> Results<Image>{
        return realm.objects(Image.self).filter("parent_id == %@", parent_id)
    }
    
    // Update
    func updateImage(target: Results<Image>, data: Image) -> Void{
        try! realm.write{
            target[0].parent_id = data.parent_id
        }
    }
    
    // Delete
    func deleteRelation(target: Results<Relationship>) -> Void{
        try! realm.write{
            realm.delete(target[0])
        }
    }
    
    // Delete
    func deleteImage(target: Results<Image>) -> Void{
        try! realm.write{
            realm.delete(target[0])
        }
    }
}
