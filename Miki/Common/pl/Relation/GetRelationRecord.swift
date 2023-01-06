//
//  GetRelationRecord.swift
//  Miki
//
//  Created by 柴田健作 on 2022/10/16.
//

import Foundation
import RealmSwift

class GetRelationRecords{
    func getRelationRecordById(relation: Relationship) -> Relationship{
        var value: Relationship?
        
        let dao = Dao_relation()
        let record: Results<Relationship> = dao.getRelationByPrimaryKey(id: relation.id!)
        
        value = Relationship(id: record[0].id!,
                     source_id: record[0].source_id!,
                     related_id: record[0].related_id!,
                             rel_type_id: record[0].rel_type_id)
        return value!
    }
    func getRelationRecordsBySourceId(source_id: String!, type_id: Int) -> [Relationship]{
        var relations:[Relationship] = []
        
        let dao = Dao_relation()
        let records: Results<Relationship> = dao.getRelationRecordsBySourceId(source_id: source_id, type_id: type_id)
        
        records.forEach { record in
            let relation: Relationship = Relationship(id: record.id!,
                                                      source_id: record.source_id!,
                                                      related_id: record.related_id!,
                                                      rel_type_id: record.rel_type_id)
            relations.append(relation)
        }
        return relations
    }
    func getRelationRecordsByRelatedId(related_id: String!, type_id: Int) -> [Relationship]{
        var relations:[Relationship] = []
        
        let dao = Dao_relation()
        let records: Results<Relationship> = dao.getRelationRcordsByRelatedId(related_id: related_id, type_id: type_id)
        
        records.forEach { record in
            let relation: Relationship = Relationship(id: record.id!,
                                                      source_id: record.source_id!,
                                                      related_id: record.related_id!,
                                                      rel_type_id: record.rel_type_id)
            relations.append(relation)
        }
        return relations
    }
}
