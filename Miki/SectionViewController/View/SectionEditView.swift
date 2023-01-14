//
//  SectionEditView.swift
//  Miki
//
//  Created by 柴田健作 on 2023/01/14.
//

import UIKit

/// セクションの編集用View
class SectionEditView: UIView {
    // 画面項目
    let scrollView = UIScrollView()
    let mainView = UIView()
    let lblTitle = UILabel()
    let titleField = UITextField()
    let closeBtn = UIButton()
    let saveBtn = UIButton()
    
    // Variable
    var parent: SectionViewController!
    var section: SectionItem!
    
    init(parent: SectionViewController, section: SectionItem) {
        super.init(frame: parent.view.frame)
        
        self.parent = parent
        self.section = section
        
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
        let main_h = self.frame.height*0.3
        // self
        self.backgroundColor = .black.withAlphaComponent(0.6)
        self.isOpaque = false
        
        // title
        lblTitle.text = "タイトル"
        lblTitle.font = .systemFont(ofSize: 16)
        lblTitle.frame.size = CGSize(width: lblTitle.getFitWidth(), height: lblTitle.getFitHeight())
        lblTitle.frame.origin = CGPoint(x: 16, y: 20)
        mainView.addSubview(lblTitle)
        titleField.text = self.section.title
        titleField.font = .systemFont(ofSize: 24)
        titleField.frame.size = CGSize(width: main_w-(lblTitle.frame.maxX+30), height: 36)
        titleField.center = CGPoint(x: 0, y: lblTitle.center.y)
        titleField.frame.origin = CGPoint(x: lblTitle.frame.maxX+10, y: titleField.frame.origin.y)
        titleField.setUnderLine(color: .systemBlue)
        mainView.addSubview(titleField)
        // mainView
        mainView.frame = CGRect(x: 0, y: 0, width: main_w,
                                height: titleField.frame.maxY+10 <= main_h ? main_h : titleField.frame.maxY+10)
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
        closeBtn.center = CGPoint(x: scrollView.center.x, y: scrollView.frame.minY-closeBtn.frame.width/2-10)
        closeBtn.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeBtn.tintColor = .systemBlue
        closeBtn.backgroundColor = .systemBlue
        closeBtn.tintColor = .systemBackground
        closeBtn.layer.cornerRadius = closeBtn.frame.width/2
        closeBtn.addTarget(self, action: #selector(cancelBtn_onTap(_:)), for: UIControl.Event.touchUpInside)
        self.addSubview(closeBtn)
        // saveBtn
        saveBtn.frame.size = CGSize(width: main_w, height: 40)
        saveBtn.center = CGPoint(x: scrollView.center.x, y: scrollView.frame.maxY+closeBtn.frame.width/2+10)
        saveBtn.setTitle("Save", for: .normal)
        saveBtn.layer.cornerRadius = saveBtn.frame.height/2
        saveBtn.backgroundColor = .systemBackground
        saveBtn.setTitleColor(UIColor.systemCyan, for: .normal)
        saveBtn.addTarget(self, action: #selector(saveBtn_onTap(_:)), for: UIControl.Event.touchUpInside)
        self.addSubview(saveBtn)
    }
    
    /// 自画面クローズ処理
    func closeSelf() {
        // 親画面のNavigationBarとToolBarを再表示
        self.parent.navigationController!.setNavigationBarHidden(false, animated: false)
        self.parent.tabBarController!.tabBar.isHidden = false
        // ViewControllerを再描画
        self.parent.loadView()
        self.parent.viewDidLoad()
        
        self.parent.tableView.reloadData()
        self.removeFromSuperview()
    }
    
    /// クローズボタン押下処理
    /// - Parameter sender: closeBtn
    @objc func cancelBtn_onTap(_ sender: UIButton) {
        self.closeSelf()
    }
    
    /// セーブボタン押下処理
    /// - Parameter sender: saveBtn
    @objc func saveBtn_onTap(_ sender: UIButton) {
        let section_af = self.setSection()
        let _ = UpdateSectionItem.updateWordRecord(after: section_af)
        
        self.parent.thisSection = GetSectionItem.getSectionItemById(id: self.section.id)
        
        self.closeSelf()
    }
    
    /// 更新用セクション作成
    /// - Returns: 更新用セクション
    private func setSection() -> SectionItem {
        let data = SectionItem()
        
        data.id = self.section.id
        data.title = self.titleField.text
        data.sortId = self.section.sortId
        data.parentMedia_id = self.section.parentMedia_id
        
        return data
    }
}
