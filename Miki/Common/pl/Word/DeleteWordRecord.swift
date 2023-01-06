//
//  DeleteWord.swift
//  Miki
//
//  Created by 柴田健作 on 2022/09/28.
//

import Foundation
import RealmSwift

class DeleteWordRecord{
    func deleteWordRecord(word: Word!) -> Result{
        let dao = Dao_word()
        
        let target: Results<Word> = dao.getWordByPrimaryKey(key: word)
        
        dao.deleteWord(target: target)
        
        return Result(message: "", result_cd: true)
    }
}
