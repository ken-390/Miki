//
//  MediaView.swift
//  Miki
//
//  Created by 柴田健作 on 2022/11/12.
//

import Foundation
import UIKit

class MediaDetailView: UIView{
    var imageView: UIImageView!
    var titleLabel: UILabel!
    var authorLabel: UILabel!
    var summaryLabel: UITextView!
    var menuButton: UIButton!
    var arrowBtn: UIButton!
    
    var parent: MediaViewController!
    
    init(parent: MediaViewController, frame: CGRect){
        self.parent = parent
        
        super.init(frame: frame)
        
        let imageView_frame = CGRect(x: 10, y: self.frame.height*0.1, width: self.frame.width*0.4, height: self.frame.height*0.8)
        let titleLabel_frame = CGRect(x: imageView_frame.maxX+20, y: imageView_frame.minY+40, width: 0, height: 0)
        let authorLabel_frame = CGRect(x: titleLabel_frame.minX, y: 0, width: 0, height: 0)
        let menuButton_frame = CGRect(x: self.frame.maxX-40, y: 16, width: 30, height: 30)

        // VIEW
        // IMAGE
        self.imageView = UIImageView(frame: imageView_frame)
        imageView.contentMode = .scaleAspectFit
        imageView.setImageBySourceID(parent_id: parent.thisMedia.id)
        self.addSubview(imageView)
        // TITLE
        self.titleLabel = UILabel(frame: titleLabel_frame)
        titleLabel.font = .systemFont(ofSize: 24)
        titleLabel.text = parent.thisMedia.title
        titleLabel.frame.size.width = titleLabel.getFitWidth()
        titleLabel.frame.size.height = titleLabel.getFitHeight()
        self.addSubview(titleLabel)
        // AUTHOR
        self.authorLabel = UILabel(frame: authorLabel_frame)
        authorLabel.textColor = .systemGray
        authorLabel.font = .systemFont(ofSize: 14)
        authorLabel.text = parent.thisMedia.author != nil ? "著者: \(parent.thisMedia.author!.title!)"  : ""
        authorLabel.frame.size.width = authorLabel.getFitWidth()
        authorLabel.frame.size.height = authorLabel.getFitHeight()
        authorLabel.frame.origin.y = self.titleLabel.frame.maxY+5
        self.addSubview(authorLabel)
        // SUMMARY
        self.summaryLabel = UITextView()
        summaryLabel.isEditable = false
        summaryLabel.text = parent.thisMedia.summary
        summaryLabel.textColor = .systemGray2
        let maxH: CGFloat = 200
        let size = summaryLabel.sizeThatFits(CGSize(width: self.frame.width*0.7
                                                    , height: CGFloat.greatestFiniteMagnitude))
        summaryLabel.frame.size.width = size.width
        summaryLabel.frame.size.height = size.height > maxH ? maxH : size.height
        summaryLabel.center.x = self.center.x
        summaryLabel.frame.origin.y = self.frame.size.height+5
        self.addSubview(summaryLabel)
        // BUTTON_MENU
        self.menuButton = UIButton(frame: menuButton_frame)
        menuButton.tintColor = .systemGray3
        menuButton.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        menuButton.menu = UIMenu(title: "", children: self.getActions())
        menuButton.showsMenuAsPrimaryAction = true
        self.addSubview(menuButton)
        // ARROW_BTN
        self.arrowBtn = UIButton()
        arrowBtn.frame.size = CGSize(width: 40, height: 30)
        arrowBtn.frame.origin = CGPoint(x: self.frame.width-45, y: self.frame.height-35)
        arrowBtn.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        arrowBtn.setImage(UIImage(systemName: "chevron.up"), for: .selected)
        arrowBtn.tintColor = .systemGray3
        arrowBtn.addTarget(self, action: #selector(arrowBtn_onTap(_:)), for: UIControl.Event.touchUpInside)
        self.addSubview(arrowBtn)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 矢印ボタン押下時処理
    /// - Parameter sender: arrowBtn
    @objc func arrowBtn_onTap(_ sender: UIButton) {
        let extendRange = self.summaryLabel.frame.height+10
        if(!sender.isSelected) {
            sender.isSelected = true
            self.frame.size.height = self.frame.size.height + extendRange
        } else {
            sender.isSelected = false
            self.frame.size.height = self.frame.size.height - extendRange
        }
        // 親ViewControllerの見た目を更新
        self.parent.updateToolbarPosition()
    }
    
    func getActions() -> [UIAction] {
        let edit: UIAction = UIAction(title: "編集", image: UIImage(systemName: "pencil")) { (action) in
            self.parent.navigationController?.setNavigationBarHidden(true, animated: false)
            self.parent.tabBarController?.tabBar.isHidden.toggle()
            self.parent.view.addSubview(MediaEditView(parent: self.parent))
        }
        let delete: UIAction = UIAction(title: "削除", image: UIImage(systemName: "trash")) { (action) in
            _ = DeleteMedia.deleteMedia(id: self.parent.thisMedia.id)
            self.parent.navigationController!.popViewController(animated: true)
        }
        return [edit, delete]
    }
}
