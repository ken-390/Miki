//
//  SectionDetailView.swift
//  Miki
//
//  Created by 柴田健作 on 2022/11/18.
//

import UIKit

class SectionDetailView: UIView {
    var titleLabel: UILabel!
    var menuButton: UIButton!
    
    var parent: SectionViewController!
    var thisSection: SectionItem!
    
    init(parent: SectionViewController, frame: CGRect){
        self.parent = parent
        super.init(frame: frame)
        
        let titleLabel_frame = CGRect(x: 40, y: 40, width: 0, height: 0)
        let menuButton_frame = CGRect(x: self.frame.maxX-40, y: 16, width: 30, height: 30)
        
        // VIEW
        self.setUnderLine(color: .systemGray4)
        // TITLE
        self.titleLabel = UILabel(frame: titleLabel_frame)
        titleLabel.font = .systemFont(ofSize: 24)
        titleLabel.text = parent.thisSection.title
        titleLabel.frame.size.width = titleLabel.getFitWidth()
        titleLabel.frame.size.height = titleLabel.getFitHeight()
        self.addSubview(titleLabel)
        // BUTTON_MENU
        self.menuButton = UIButton(frame: menuButton_frame)
        menuButton.tintColor = .systemGray3
        menuButton.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        self.addSubview(menuButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
