//
//  getWordRecords.swift
//  Miki
//
//  Created by 柴田健作 on 2022/09/26.
//

import Foundation
import RealmSwift

class GetWordRecords {
    func getWordRecords() -> [Word]{
        let dao = Dao_word()
        return setRecords(records: dao.getWords())
    }
    func getWordRecordById(word: Word) -> Word{
        let dao = Dao_word()
        return setRecords(records: dao.getWordByPrimaryKey(key: word))[0]
    }
    func getWordsByParent(media_id: String, section_id: String) -> [Word]{
        let dao = Dao_word()
        return setRecords(records: dao.getWordsByParent(media_id: media_id, section_id: section_id))
    }
    
    func getWordRecordsByTypeAndTitle(type_id: Int, title: String) -> [Word]{
        if(title == ""){
            return []
        }
        let dao = Dao_word()
        return setRecords(records: dao.getWordsByTypeAndTitle(type_id: type_id, title: title))
    }
    
    private func setRecords(records: Results<Word>) -> [Word]{
        var words:[Word] = []
        records.forEach { record in
            let word: Word = Word(id: record.id!,
                                  type_id: record.type_id,
                                  title: record.title!,
                                  text: record.text!,
                                  mediaId: record.mediaId,
                                  sectionId: record.sectionId)
            words.append(word)
        }
        return words
    }
}
