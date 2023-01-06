//
//  DeleteImage.swift
//  Miki
//
//  Created by 柴田健作 on 2022/10/23.
//

import Foundation
import RealmSwift

class DeleteImage{
    func deleteImage(image: Image!, url: URL) -> Result{
        let dao = Dao_Image()
        let target: Results<Image> = dao.getImageById(key: image)
        dao.deleteImage(target: target)
        
        do {
            let fileManager = FileManager.default
            try fileManager.removeItem(at: url)
       } catch let error {
           print("失敗した\(error)")
       }
        
        return Result(message: "", result_cd: true)
    }
}
