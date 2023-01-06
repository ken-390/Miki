//
//  UpdateWordRecord.swift
//  Miki
//
//  Created by 柴田健作 on 2022/09/28.
//

import Foundation
import RealmSwift

class UpdateWordRecord{
    func updateWordRecord(before: Word, after: Word) -> Result{
        let dao = Dao_word()
        
        let target: Results<Word> = dao.getWordByPrimaryKey(key: before)
        
        dao.updateWord(target: target, data: after)
        
        return Result(message: "", result_cd: true)
    }
}
