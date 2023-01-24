//
//  MediaEditView.swift
//  Miki
//
//  Created by 柴田健作 on 2022/11/22.
//

import UIKit
import UIKit

class MediaEditView: UIView{
    var view: UIView!
    var saveBtn: UIButton!
    var closeBtn: UIButton!
    // View contents
    var imageView: UIImageView!
    var settingTable: UITableView!
    
    var parent: MediaViewController!
    var thisMedia: Media!
    
    init(parent: MediaViewController){
        self.parent = parent
        self.thisMedia = parent.thisMedia
        
        super.init(frame: CGRect(x: 0, y: 0, width: parent.view.frame.width, height: parent.view.frame.height))
        self.backgroundColor = .black.withAlphaComponent(0.4)
        
        let view_frame = CGRect(x: self.frame.width*0.1, y: self.frame.height*0.1
                                , width: self.frame.width*0.8, height: self.frame.height*0.7)
        let save_frame = CGRect(x: view_frame.minX, y: view_frame.maxY+10,
                                width: view_frame.width, height: 40)
        let close_frame = CGRect(x: 20, y: 20, width: 40, height: 40)
        // CLOSE
        self.closeBtn = UIButton(frame: close_frame)
        closeBtn.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeBtn.tintColor = .systemGray3
        closeBtn.addTarget(self, action: #selector(cancelBtn_onTap(_:)), for: UIControl.Event.touchUpInside)
        self.addSubview(closeBtn)
        // SAVE
        self.saveBtn = UIButton(frame: save_frame)
        saveBtn.backgroundColor = .systemBackground
        saveBtn.setTitle("Save", for: .normal)
        saveBtn.setTitleColor(UIColor.systemBlue, for: .normal)
        saveBtn.layer.cornerRadius = saveBtn.frame.height/2
        saveBtn.addTarget(self, action: #selector(saveBtn_onTap(_:)), for: UIControl.Event.touchUpInside)
        self.addSubview(saveBtn)
        // VIEW
        self.view = UIView(frame: view_frame)
        view.layer.cornerRadius = view_frame.width*0.1
        view.backgroundColor = .systemBackground
        view.layer.masksToBounds = true
        self.settingContents()
        self.addSubview(view)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// クローズボタン押下処理
    /// - Parameter sender: closeBtn
    @objc func cancelBtn_onTap(_ sender: UIButton) {
        self.closeEvent()
    }
    /// 保存ボタン押下処理
    /// - Parameter sender: saveBtn
    @objc func saveBtn_onTap(_ sender: UIButton) {
        let media_af = self.setMedia()
        let _ = UpdateMedia.updateMedia(after: media_af)
        self.thisMedia = media_af
        
        self.closeEvent()
    }
    
    /// 自画面クローズ処理
    private func closeEvent() {
        // 親画面のNavigationBarとToolBarを再表示
        self.parent.navigationController?.setNavigationBarHidden(false, animated: false)
        self.parent.tabBarController?.tabBar.isHidden.toggle()
        // ViewControllerを再描画
        self.parent.thisMedia = self.thisMedia
        self.parent.loadView()
        self.parent.viewDidLoad()
        
        self.removeFromSuperview()
    }
    
    private func setMedia() -> Media{
        let media = Media()
        media.id = self.thisMedia.id
        media.type = self.thisMedia.type
        media.date = self.thisMedia.date
        media.summary = self.thisMedia.summary
        media.point = self.thisMedia.point
        media.comment = self.thisMedia.comment
        media.author_id = self.thisMedia.author_id
        
        // Title & Summary
        let cell_1: TitleAndSummarryCell = self.settingTable.cellForRow(at: IndexPath(row: 0, section: 0)) as! TitleAndSummarryCell
        media.title = cell_1.titleField.text
        media.summary = cell_1.summaryText.text
        
        return media
    }
    
    private func settingContents() {
        let image_frame = CGRect(x: self.view.frame.width*0.5-self.view.frame.width*0.2,y: 20,
                                 width: self.view.frame.width*0.4,height: self.view.frame.height*0.2)
        let table_frame = CGRect(x: 0, y: image_frame.maxY+10, width: self.view.frame.width, height: self.view.frame.height-(image_frame.maxY+10))
        
        self.imageView = UIImageView(frame: image_frame)
        imageView.contentMode = .scaleAspectFit
        imageView.setImageBySourceID(parent_id: self.thisMedia.id)
        self.view.addSubview(imageView)
        self.settingTable = UITableView(frame: table_frame)
        settingTable.separatorStyle = .none
        settingTable.allowsSelection = false
        settingTable.delegate = self
        settingTable.dataSource = self
        settingTable.register(UINib(nibName: "TitleAndSummaryCell", bundle: nil), forCellReuseIdentifier: "titleCell")
        settingTable.register(UINib(nibName: "AuthorCell", bundle: nil), forCellReuseIdentifier: "authorCell")
        settingTable.register(UINib(nibName: "TagCell", bundle: nil), forCellReuseIdentifier: "tagCell")
        self.view.addSubview(settingTable)
    }
}
extension MediaEditView: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return String(section)
//    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch(indexPath.section) {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "titleCell", for: indexPath) as! TitleAndSummarryCell
            cell.titleField.text = thisMedia.title
            cell.summaryText.text = thisMedia.summary
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "authorCell", for: indexPath) as! AuthorCell
            cell.authorField.text = thisMedia.author == nil ? "" : thisMedia.author!.title
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "tagCell", for: indexPath) as! TagCell
            return cell
        default:
            let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch(indexPath.section) {
        case 0:
            return 240
        case 1:
            return 45
        case 2:
            return 45
        default:
            return 20
        }
    }
}
