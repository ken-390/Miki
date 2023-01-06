//
//  UpdateMedia.swift
//  Miki
//
//  Created by 柴田健作 on 2022/11/21.
//

import Foundation

import RealmSwift

class UpdateMedia{
    static public func updateMedia(after: Media) -> Bool{
        let dao = Dao_media()
        
        let target: Results<Media> = dao.getMediaById(id: after.id)
        
        dao.update(target: target, data: after)
        
        return true
    }
}
