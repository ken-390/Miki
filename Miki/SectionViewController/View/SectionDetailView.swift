//
//  SectionDetailView.swift
//  Miki
//
//  Created by 柴田健作 on 2022/11/18.
//

import UIKit

class SectionDetailView: UIView {
    var titleLabel: UILabel!
    var menuBtn: UIButton!
    
    var parent: SectionViewController!
    var section: SectionItem!
    
    init(parent: SectionViewController, frame: CGRect){
        self.parent = parent
        self.section = parent.thisSection
        super.init(frame: frame)
        
        let titleLabel_frame = CGRect(x: 40, y: 40, width: 0, height: 0)
        let menuButton_frame = CGRect(x: self.frame.maxX-40, y: 16, width: 30, height: 30)
        
        // VIEW
        self.setUnderLine(color: .systemGray4)
        // TITLE
        self.titleLabel = UILabel(frame: titleLabel_frame)
        titleLabel.font = .systemFont(ofSize: 24)
        titleLabel.text = self.section.title
        titleLabel.frame.size.width = titleLabel.getFitWidth()
        titleLabel.frame.size.height = titleLabel.getFitHeight()
        self.addSubview(titleLabel)
        // BUTTON_MENU
        self.menuBtn = UIButton(frame: menuButton_frame)
        menuBtn.tintColor = .systemGray3
        menuBtn.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        menuBtn.menu = UIMenu(title: "", children: self.getActions())
        menuBtn.showsMenuAsPrimaryAction = true
        self.addSubview(menuBtn)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// メニューボタン定義
    /// - Returns: 各メニューボタンのアクション
    private func getActions() -> [UIAction] {
        // EditEvent
        let edit: UIAction = UIAction(title: "編集", image: UIImage(systemName: "pencil")) { (action) in
            
        }
        
        // DeleteEvent
        let delete: UIAction = UIAction(title: "削除", image: UIImage(systemName: "trash")) { (action) in
            let alert = UIAlertController(title:"Caution", message:"削除されたものは復元できません\nよろしいですか？", preferredStyle:UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK" , style:UIAlertAction.Style.default){
                (action:UIAlertAction)in
                // 削除対象に紐づく単語の出典を「その他」にする
                let words = GetWordRecords().getWordsByParent(media_id: self.section.parentMedia_id, section_id: self.section.id)
                for i in 0..<words.count {
                    let word_af = words[i]
                    word_af.mediaId = ""
                    word_af.sectionId = ""
                    let _ = UpdateWordRecord().updateWordRecord(before: words[i], after: word_af)
                }
                // セクションを削除して親ビューコントローラを閉じる
                let _ = DeleteSectionItem.deleteSectionItem(sectionItem: self.section)
                
                self.parent.navigationController!.popViewController(animated: true)
            })
                    
            alert.addAction(UIAlertAction(title: "Cancel", style:UIAlertAction.Style.cancel){
                (action:UIAlertAction)in
                // NonProcess
            })
            self.parent.present(alert, animated: true, completion:nil)
        }
        return [edit, delete]
    }
}
