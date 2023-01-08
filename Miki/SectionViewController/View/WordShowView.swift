//
//  WordShowView.swift
//  Miki
//
//  Created by 柴田健作 on 2023/01/08.
//

import UIKit

/// 単語の参照用View
class WordShowView: UIView {
    // 画面項目
    let scrollView = UIScrollView()
    let mainView = UIView()
    let titleLabel = UILabel()
    let sourceLabel = UILabel()
    let textArea = UITextView()
    let closeBtn = UIButton()
    
    // Variable
    var parent: SectionViewController!
    var word: Word!
    
    init(parent: SectionViewController, word: Word) {
        super.init(frame: parent.view.frame)
        
        self.parent = parent
        self.word = word
        
        settingView()
        
        // 親画面のNavigationBarとToolBarを非表示
        self.parent.navigationController!.setNavigationBarHidden(true, animated: false)
        self.parent.tabBarController!.tabBar.isHidden = true
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 画面の初期化処理
    private func settingView() {
        let main_w = self.frame.width*0.7
        let main_h = self.frame.height*0.7
        // self
        self.backgroundColor = .black.withAlphaComponent(0.6)
        self.isOpaque = false
        // title
        titleLabel.text = self.word.title
        titleLabel.font = .systemFont(ofSize: 24)
        titleLabel.frame.origin = CGPoint(x: 20, y: 30)
        titleLabel.frame.size = CGSize(width: titleLabel.getFitWidth(), height: titleLabel.getFitHeight())
        titleLabel.backgroundColor = .red
        mainView.addSubview(titleLabel)
        // text
        textArea.text = self.word.text
        textArea.frame.origin = CGPoint(x: main_w*0.1, y: titleLabel.frame.maxY+10)
        textArea.frame.size = CGSize(width: main_w*0.8, height: textArea.contentSize.height)
        textArea.backgroundColor = .blue
        mainView.addSubview(textArea)
        // source
        sourceLabel.text = "出典："
        if(self.word.media != nil) {
            let mediaTitle = self.word.media!.title!
            if(self.word.section != nil) {
                let sectionTitle = self.word.section!.title!
                sourceLabel.text! += mediaTitle + " - " + sectionTitle
            } else {
                sourceLabel.text! += mediaTitle
            }
        } else {
            sourceLabel.text! += "---"
        }
        sourceLabel.frame.origin = CGPoint(x: 20, y: textArea.frame.maxY+20)
        sourceLabel.frame.size = CGSize(width: sourceLabel.getFitWidth(), height: sourceLabel.getFitHeight())
        sourceLabel.backgroundColor = .yellow
        mainView.addSubview(sourceLabel)
        // closeBtn
        closeBtn.frame = CGRect(x: main_w-40, y: 10, width: 30, height: 30)
        closeBtn.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeBtn.tintColor = .systemGray3
        closeBtn.addTarget(self, action: #selector(cancelBtn_onTap(_:)), for: UIControl.Event.touchUpInside)
        mainView.addSubview(closeBtn)
        //mainView
        mainView.frame = CGRect(x: 0, y: 0, width: main_w,
                                height: sourceLabel.frame.maxY+10 <= main_h ? main_h : sourceLabel.frame.maxY+10)
        mainView.backgroundColor = .white
        scrollView.addSubview(mainView)
        // scrollView
        scrollView.frame = CGRect(x: self.center.x-main_w/2, y: self.center.y-main_h/2
                                  , width: main_w, height: main_h)
        scrollView.contentSize = mainView.frame.size
        scrollView.flashScrollIndicators()
        scrollView.layer.cornerRadius = scrollView.frame.width*0.1
        scrollView.clipsToBounds = true
        scrollView.backgroundColor = .green
        self.addSubview(scrollView)
    }
    
    /// クローズボタン押下処理
    /// - Parameter sender: closeBtn
    @objc func cancelBtn_onTap(_ sender: UIButton) {
        // 親画面のNavigationBarとToolBarを再表示
        self.parent.navigationController!.setNavigationBarHidden(false, animated: false)
        self.parent.tabBarController!.tabBar.isHidden = false
        
        self.removeFromSuperview()
    }
}
