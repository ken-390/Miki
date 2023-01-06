//
//  Dao_relation.swift
//  Miki
//
//  Created by 柴田健作 on 2022/10/16.
//

import Foundation
import RealmSwift
class Dao_relation {
    let realm = try! Realm()
    // Create
    func addRelation(target: Relationship) -> Void{
        try! realm.write{
            realm.add(target)
        }
    }
    
    // Read
    func getRelationByPrimaryKey(id: String) -> Results<Relationship>{
        return realm.objects(Relationship.self).filter("id == %@", id)
    }
    func getRelationRecordsBySourceId(source_id: String, type_id: Int) -> Results<Relationship>{
        return realm.objects(Relationship.self).filter("source_id == %@ AND rel_type_id == %@", source_id, type_id)
    }
    func getRelationRcordsByRelatedId(related_id: String, type_id: Int) -> Results<Relationship>{
        return realm.objects(Relationship.self).filter("related_id == %@", related_id)
    }
    
    // Delete
    func deleteRelation(target: Results<Relationship>) -> Void{
        try! realm.write{
            realm.delete(target[0])
        }
    }
}
