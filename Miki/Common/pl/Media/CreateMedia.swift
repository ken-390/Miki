//
//  CreateMedia.swift
//  Miki
//
//  Created by 柴田健作 on 2022/11/09.
//

import Foundation

class CreateMediaRecord {
    func createMediaRecord(media: Media) -> Bool{
        let dao = Dao_media()
        media.id = numbering()
        dao.addMedia(media: media)
        
        return true
    }
    
    func numbering() -> String!{
        var id: String = ""
        for _ in 0..<8 {
            let num = Int.random(in: 0..<65536)
            var str_16 = String(num, radix: 16)
            for _ in str_16.count..<4 {
                str_16.insert("0", at: str_16.startIndex)
            }
            id = id + str_16
        }
        return id
    }
}
