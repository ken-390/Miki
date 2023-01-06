//
//  MediaRelsView.swift
//  Miki
//
//  Created by 柴田健作 on 2022/11/13.
//

import Foundation
import UIKit
import Segmentio
import Cosmos

class MediaRelsView: UIView{
    let SHOW_DATA_CELL: Int = 0
    let ADD_RECORD_CELL: Int = 1
    
    var parent: MediaViewController!
    var type: SegmentCell = .review
    var relWords: [[Word]] = []
    var sections: [SectionItem] = []
    
    /*
     Contents
     */
    // COMMENT VIEW
    var commentView: UITextView!
    var cosmosView: CosmosView!
    var editButton: UIButton!
    // CHARACTER VIEW
    var chapterTableView: UITableView!
    
    init(parent: MediaViewController, frame: CGRect){
        self.parent = parent
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showContentsBySegmentIdx(type: SegmentCell){
        self.type = type
        
        // COMMENT VIEW
        let cosmos_frame = CGRect(x: self.frame.width*0.125, y: 15, width: 100, height: 30)
        let commentView_frame = CGRect(x: self.frame.width*0.125, y: cosmos_frame.maxY+10, width: self.frame.width*0.75, height: self.frame.height*0.6)
        // CHARACTER VIEW
        let table_frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        
        let subviews = self.subviews
        for subview in subviews {
           subview.removeFromSuperview()
        }
        
            let media: Media! = self.parent!.thisMedia!
        switch(type){
        case .review:
            // stars
            self.cosmosView = CosmosView(frame: cosmos_frame)
            cosmosView.rating = media.point
            cosmosView.didFinishTouchingCosmos = { rating in
                let media: Media! = self.parent!.thisMedia!
                media.point = rating
                _ = UpdateMedia.updateMedia(after: media)
            }
            self.addSubview(cosmosView)
            // textView
            self.commentView = UITextView(frame: commentView_frame)
            commentView.layer.borderWidth = 1.0
            commentView.layer.borderColor = UIColor.systemGray4.cgColor
            commentView.delegate = self
            commentView.text = media.comment
            self.addSubview(commentView)
            break
        case .chapter:
            // table
            self.chapterTableView = UITableView(frame: table_frame)
            chapterTableView.dataSource = self
            chapterTableView.delegate = self
            self.addSubview(chapterTableView)
            break
        }
    }
}

extension MediaRelsView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let media: Media! = self.parent!.thisMedia!
        media.comment = textView.text
        _ = UpdateMedia.updateMedia(after: media)
    }
}

extension MediaRelsView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.sections = GetSectionItem.getSectionItems(parentId: parent.thisMedia.id)
        return self.sections.count + 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(self.sections.count > indexPath.row ) {
            let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
            cell.textLabel?.text = self.sections[indexPath.row].title
            cell.tag = SHOW_DATA_CELL
            return cell
        }
        else {
            let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
            cell.imageView?.tintColor = .systemGray2
            cell.imageView?.image = UIImage(systemName: "plus.circle")
            cell.textLabel?.textColor = .systemGray2
            cell.textLabel?.text = "セクションを追加"
            cell.tag = ADD_RECORD_CELL
            return cell
        }
    }
}
extension MediaRelsView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedCell: UITableViewCell = tableView.cellForRow(at: indexPath)!
        if(selectedCell.tag == ADD_RECORD_CELL) {
            showCreateSectionDialog(sortId: indexPath.row)
        } else {
            self.parent.selectedSection = self.sections[indexPath.row]
            self.parent.performSegue(withIdentifier: "showSection", sender: self)
        }
    }
    private func showCreateSectionDialog(sortId: Int) {
        var alertTextField: UITextField?
        let popup = UIAlertController(title: "新規作成",
            message: "作成する セクション のタイトルを入力してください",
            preferredStyle: UIAlertController.Style.alert)
        popup.addTextField(
            configurationHandler: {(textField: UITextField!) in
                alertTextField = textField
                textField.placeholder = "タイトル"
        })
        popup.addAction(
            UIAlertAction(
                title: "Cancel",
                style: UIAlertAction.Style.cancel,
                handler: nil))
        popup.addAction(
            UIAlertAction(
                title: "OK",
                style: UIAlertAction.Style.default) { _ in
                if let text = alertTextField?.text {
                    let section = SectionItem()
                    section.title = text
                    section.sortId = sortId
                    section.parentMedia_id = self.parent.thisMedia.id
                    let res: Bool = CreateSectionItem.createSectionItem(sectionItem: section)
                    if(res){
                        let message = UIAlertController(title: "Complete",
                            message: "\"\(text)\" を追加しました",preferredStyle: UIAlertController.Style.alert)
                        message.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                        self.parent.present(message, animated: true, completion: nil)
                        self.chapterTableView.reloadData()
                    }
                }
            }
        )
        self.parent.present(popup, animated: true, completion: nil)
    }
}
