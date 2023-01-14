//
//  DeleteSectionItem.swift
//  Miki
//
//  Created by 柴田健作 on 2023/01/12.
//

import Foundation

class DeleteSectionItem {
    /// アイテム「セクション」をIDをキーに1件削除
    /// - Parameter sectionItem: 削除対象「セクション」
    /// - Returns: true
    static public func deleteSectionItem(sectionItem: SectionItem) -> Bool{
        let dao = Dao_sectionItem()
        dao.delete(section: sectionItem)
        
        return true
    }
}
