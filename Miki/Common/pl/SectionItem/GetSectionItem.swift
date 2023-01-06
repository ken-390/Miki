//
//  CreateSectionItem.swift
//  Miki
//
//  Created by 柴田健作 on 2022/11/17.
//

import Foundation
import RealmSwift

class GetSectionItem {
    static public func getSectionItems(parentId: String) -> [SectionItem]{
        var sectionItems:[SectionItem] = []
        
        let dao = Dao_sectionItem()
        let records: Results<SectionItem> = dao.getRecords(parentId: parentId)
        
        records.forEach { record in
            let sectionItem: SectionItem = SectionItem(id: record.id!,
                                                       title: record.title,
                                                       sortId: record.sortId,
                                                       parentMedia_id: record.parentMedia_id)
            sectionItems.append(sectionItem)
        }
        return sectionItems
    }
    static public func getSectionItemById(id: String) -> SectionItem {
        var sectionItems: [SectionItem] = []
        
        let dao = Dao_sectionItem()
        let records: Results<SectionItem> = dao.getRecordById(id: id)
        
        records.forEach { record in
            let sectionItem: SectionItem = SectionItem(id: record.id!,
                                                       title: record.title,
                                                       sortId: record.sortId,
                                                       parentMedia_id: record.parentMedia_id)
            sectionItems.append(sectionItem)
        }
        return sectionItems[0]
    }
}
