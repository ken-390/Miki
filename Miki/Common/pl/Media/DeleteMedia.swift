//
//  DeleteMedia.swift
//  Miki
//
//  Created by 柴田健作 on 2023/01/24.
//

import Foundation

class DeleteMedia {
    static public func deleteMedia(id: String) -> Bool{
        // Mediaに紐づくSectionを削除
        let sections = GetSectionItem.getSectionItems(parentId: id)
        for i in 0..<sections.count {
            _ = DeleteSectionItem.deleteSectionItem(sectionItem: sections[i])
        }
        // Mediaを削除
        let dao = Dao_media()
        dao.delete(id: id)
        
        return true
    }
}
