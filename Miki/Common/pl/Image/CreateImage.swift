//
//  CreateImage.swift
//  Miki
//
//  Created by 柴田健作 on 2022/10/23.
//

import Foundation
class CreateImage {
    
    func createImage(parent_id: String) -> Image{
        let target = Image(id: numbering(), parent_id: parent_id)
        let dao = Dao_Image()
        dao.addImage(target: target)
        
        return target
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
