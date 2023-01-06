//
//  UpdateSectionItem.swift
//  Miki
//
//  Created by 柴田健作 on 2022/11/21.
//

import Foundation
import RealmSwift

class UpdateSectionItem{
    static public func updateWordRecord(after: SectionItem) -> Bool{
        let dao = Dao_sectionItem()
        
        let target: Results<SectionItem> = dao.getRecordById(id: after.id)
        
        dao.update(target: target, data: after)
        
        return true
    }
}
