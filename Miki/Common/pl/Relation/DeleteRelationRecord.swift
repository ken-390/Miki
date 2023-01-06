//
//  DeleteRelationRecord.swift
//  Miki
//
//  Created by 柴田健作 on 2022/10/16.
//

import Foundation
import RealmSwift

class DeleteRelationRecord{
    func deleteRelationRecord(relations: [Relationship]!) -> Result{
        let dao = Dao_relation()
        relations.forEach {relation in
            let target: Results<Relationship> = dao.getRelationByPrimaryKey(id: relation.id!)
            dao.deleteRelation(target: target)
        }
        return Result(message: "", result_cd: true)
    }
}
