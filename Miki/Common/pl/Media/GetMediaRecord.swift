//
//  GetMediaRecord.swift
//  Miki
//
//  Created by 柴田健作 on 2022/11/09.
//

import Foundation
import RealmSwift

class GetMediaRecord {
    public func getMediaRecord() -> [Media] {
        let dao = Dao_media()
        let records: Results<Media> = dao.getMedias()
        return self.setRecords(records: records)
    }
    public func getMediaRecordByTypeIdx(typeIdx: Int, orderBy: SortMode) -> [Media]{
        let dao = Dao_media()
        
        var key: String = "id"
        switch(orderBy){
        case .byTitle:
            key = "title"
            break
        case .byAuthorName:
            key = "id"
            break
        }
        let records: Results<Media> = dao.getMediasByTypeIdx(typeIdx: typeIdx, key: key)
        return self.setRecords(records: records)
    }
    public func getMediaRecordById(id: String) -> Media{
        let dao = Dao_media()
        let records: Results<Media> = dao.getMediaById(id: id)
        return setRecords(records: records)[0]
    }
    
    private func setRecords(records: Results<Media>) -> [Media]{
        var medias:[Media] = []
        records.forEach { record in
            let media: Media = Media(id: record.id,
                                     typeIdx: record.typeIdx,
                                     title: record.title,
                                     date: record.date,
                                     summary: record.summary,
                                     point: record.point,
                                     comment: record.comment,
                                     categoryIdx: record.categoryIdx,
                                     author_id: record.author_id)
            medias.append(media)
        }
        return medias
    }
}
