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
    let menuBtn = UIButton()
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
        // menuBtn
        menuBtn.frame.size = CGSize(width: 30, height: 20)
        menuBtn.frame.origin = CGPoint(x: main_w-(menuBtn.frame.width+20), y: 20)
        menuBtn.tintColor = .systemGray3
        menuBtn.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        menuBtn.menu = UIMenu(title: "", children: self.getActions())
        menuBtn.showsMenuAsPrimaryAction = true
        mainView.addSubview(menuBtn)
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
        textArea.frame.size = CGSize(width: main_w*0.8, height: 0)
        textArea.sizeToFit()
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
        // closeBtn
        closeBtn.frame.size = CGSize(width: 40, height: 40)
        closeBtn.center = CGPoint(x: scrollView.center.x, y: scrollView.frame.maxY+closeBtn.frame.width/2+10)
        closeBtn.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeBtn.tintColor = .systemBlue
        closeBtn.backgroundColor = .systemBackground
        closeBtn.layer.cornerRadius = closeBtn.frame.width/2
        closeBtn.addTarget(self, action: #selector(cancelBtn_onTap(_:)), for: UIControl.Event.touchUpInside)
        self.addSubview(closeBtn)
    }
    
    /// 自画面クローズ処理
    func closeSelf() {
        // 親画面のNavigationBarとToolBarを再表示
        self.parent.navigationController!.setNavigationBarHidden(false, animated: false)
        self.parent.tabBarController!.tabBar.isHidden = false
        
        self.parent.tableView.reloadData()
        self.removeFromSuperview()
    }
    
    /// クローズボタン押下処理
    /// - Parameter sender: closeBtn
    @objc func cancelBtn_onTap(_ sender: UIButton) {
        self.closeSelf()
    }
    
    /// メニューボタン定義
    /// - Returns: 各メニューボタンのアクション
    private func getActions() -> [UIAction] {
        // EditEvent
        let edit: UIAction = UIAction(title: "編集", image: UIImage(systemName: "pencil")) { (action) in
            self.parent.performSegue(withIdentifier: "toEditWord", sender: self)
            self.closeSelf()
        }
        
        // DeleteEvent
        let delete: UIAction = UIAction(title: "削除", image: UIImage(systemName: "trash")) { (action) in
            let alert = UIAlertController(title:"Caution", message:"削除されたものは復元できません。\nよろしいですか？", preferredStyle:UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK" , style:UIAlertAction.Style.default){
                (action:UIAlertAction)in
                let _ = DeleteWordRecord().deleteWordRecord(word: self.word)
                self.closeSelf()
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
