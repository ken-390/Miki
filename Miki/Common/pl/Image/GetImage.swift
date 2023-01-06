//
//  GetImage.swift
//  Miki
//
//  Created by 柴田健作 on 2022/10/23.
//

import Foundation
import RealmSwift

class GetImage{
    func getImageBySourceId(parent_id: String!) -> [Image]{
        var relations:[Image] = []
        
        let dao = Dao_Image()
        let records: Results<Image> = dao.getImageBySourceId(parent_id: parent_id)
        
        records.forEach { record in
            let relation: Image = Image(id: record.id,
                                        parent_id: record.parent_id)
            relations.append(relation)
        }
        return relations
    }
}
