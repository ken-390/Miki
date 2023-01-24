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
        // 削除対象に紐づく単語の出典を「その他」にする
        let words = GetWordRecords().getWordsByParent(media_id: sectionItem.parentMedia_id
                                                      , section_id: sectionItem.id)
        for i in 0..<words.count {
            let word_af = words[i]
            word_af.mediaId = ""
            word_af.sectionId = ""
            let _ = UpdateWordRecord().updateWordRecord(before: words[i], after: word_af)
        }
        // セクションを削除する
        let dao = Dao_sectionItem()
        dao.delete(section: sectionItem)
        
        return true
    }
}
