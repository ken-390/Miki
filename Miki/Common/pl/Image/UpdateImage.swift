//
//  UpdateImage.swift
//  Miki
//
//  Created by 柴田健作 on 2022/10/23.
//

import Foundation
import RealmSwift

class UpdateImage{
    func updateImage(image: Image) -> Result{
        let dao = Dao_Image()
        
        let target: Results<Image> = dao.getImageById(key: image)
        
        dao.updateImage(target: target, data: image)
        
        return Result(message: "", result_cd: true)
    }
}
