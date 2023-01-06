//
//  Dao.swift
//  Miki
//
//  Created by 柴田健作 on 2022/09/26.
//

import Foundation
import RealmSwift
class Dao_word {
    let realm = try! Realm()
    // Create
    func addWord(word: Word) -> Void{
        try! realm.write{
            realm.add(word)
        }
    }
    
    // Read
    func getWords() -> Results<Word>{
        return realm.objects(Word.self)
    }
    func getWordByPrimaryKey(key: Word) -> Results<Word>{
        return realm.objects(Word.self).filter("id == %@", key.id! as String)
    }
    func getWordsByTitle(cond: String) -> Results<Word>{
        return realm.objects(Word.self).filter("title CONTAINS[c] %@", cond)
    }
    func getWordsByParent(media_id: String, section_id: String) -> Results<Word>{
        return realm.objects(Word.self).filter("mediaId == %@ AND sectionId == %@", media_id, section_id)
    }
    func getWordsByTypeAndTitle(type_id: Int, title: String) -> Results<Word>{
        return realm.objects(Word.self).filter("title BEGINSWITH[c] %@ AND type_id == %@", title, type_id)
    }
    
    // Update
    func updateWord(target: Results<Word>, data: Word) -> Void{
        try! realm.write{
            target[0].title = data.title
            target[0].type_id = data.type_id
            target[0].text = data.text
        }
    }
    
    // Delete
    func deleteWord(target: Results<Word>) -> Void{
        try! realm.write{
            realm.delete(target[0])
        }
    }
}
