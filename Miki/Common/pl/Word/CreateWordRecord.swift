//
//  createWordRecord.swift
//  Miki
//
//  Created by 柴田健作 on 2022/09/26.
//

import Foundation

class CreateWordRecord {
    static public func createWordRecord(word: Word) -> Result{
        let dao = Dao_word()
        
        var id: String = ""
        for _ in 0..<8 {
            let num = Int.random(in: 0..<65536)
            var str_16 = String(num, radix: 16)
            for _ in str_16.count..<4 {
                str_16.insert("0", at: str_16.startIndex)
            }
            id = id + str_16
        }
        word.id = id
        
        dao.addWord(word: word)
        
        return Result(message: "", result_cd: true)
    }
}
