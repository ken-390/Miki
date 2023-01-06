//
//  CreateRelationRecord.swift
//  Miki
//
//  Created by 柴田健作 on 2022/10/16.
//

import Foundation

class CreateRelationRecord {
    func createRelationRecord(source: Word, related: Word, type_id: Int) -> Result{
        let target = Relationship(id: numbering(),
                                  source_id: source.id!,
                                  related_id: related.id!,
                                  rel_type_id: type_id)
        let dao = Dao_relation()
        dao.addRelation(target: target)
        
        return Result(message: "", result_cd: true)
    }
    
    func numbering() -> String!{
        var id: String = ""
        for _ in 0..<8 {
            let num = Int.random(in: 0..<65536)
            var str_16 = String(num, radix: 16)
            for _ in str_16.count..<4 {
                str_16.insert("0", at: str_16.startIndex)
            }
            id = id + str_16
        }
        return id
    }
}
