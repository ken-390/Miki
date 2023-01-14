//
//  SelectMediaView.swift
//  Miki
//
//  Created by 柴田健作 on 2022/11/19.
//

import UIKit

class SelectMediaView: UIView {
    let OTHER_NON_SELECT: String = "その他（選択なし）"
    
    // Property
    var parent: UIViewController!
    var this: WordSourceEditView!
    // GrobalVariable
    var medias: [Media] = []
    
    var view: UIView!
    var label: UILabel!
    var searchView: UISearchBar!
    var tableView: UITableView!
    var cancelBtn: UIButton!
    var okBtn: UIButton!
    
    init(parent: UIViewController!, this: WordSourceEditView){
        self.parent = parent
        self.this = this
        
        let this_frame = CGRect(x: 0, y: 0, width: parent.view.frame.width, height: parent.view.frame.height)
        // SELF
        super.init(frame: this_frame)
        self.backgroundColor = .black.withAlphaComponent(0.6)
        self.isOpaque = false
        
        let view_frame = CGRect(x: self.frame.width*0.1, y: self.frame.height*0.1, width: self.frame.width*0.8, height: self.frame.height*0.7)
        let label_frame = CGRect(x: view_frame.width*0.5-80, y: 0, width: 160, height: 30)
        // let search_frame = CGRect()
        let cancelBtn_frame = CGRect(x: 0, y: view_frame.height-60, width: view_frame.width*0.5, height: 60)
        let okBtn_frame = CGRect(x: cancelBtn_frame.maxX, y: view_frame.height-60, width: view_frame.width*0.5, height: 60)
        let table_frame = CGRect(x: 0, y: label_frame.maxY+10, width: view_frame.width, height: view_frame.height-(label_frame.height+cancelBtn_frame.height))
        // VIEW
        self.view = UIView(frame: view_frame)
        self.addSubview(view)
        // LABEL
        self.label = UILabel(frame: label_frame)
        label.text = "出典元を選択"
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 22)
        self.view.addSubview(label)
        // CANCEL BUTTON
        self.cancelBtn = UIButton(frame: cancelBtn_frame)
        cancelBtn.setTitle("Cancel", for: .normal)
        cancelBtn.addTarget(self, action: #selector(cancelBtn_onTap(_:)), for: UIControl.Event.touchUpInside)
        self.view.addSubview(cancelBtn)
        // OK BUTTON
        self.okBtn = UIButton(frame: okBtn_frame)
        okBtn.setTitle("OK", for: .normal)
        okBtn.addTarget(self, action: #selector(okBtn_onTap(_:)), for: UIControl.Event.touchUpInside)
        self.view.addSubview(okBtn)
        // TABLE
        self.tableView = UITableView(frame: table_frame)
        tableView.backgroundColor = .white
        tableView.setUnderLine(color: .systemGray4)
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func cancelBtn_onTap(_ sender: UIButton) {
        self.removeFromSuperview()
    }
    @objc func okBtn_onTap(_ sender: UIButton) {
        if(tableView.indexPathForSelectedRow == nil) {
            // 選択行がないとき，画面をそのまま閉じる.
            self.removeFromSuperview()
            return
        }
        if(tableView.indexPathForSelectedRow!.row < self.medias.count) {
            let selected: Media = medias[tableView.indexPathForSelectedRow!.row]
            if(self.this.source_media != selected) {
                self.this.source_media = selected
                self.this.mediaSelectField.text = selected.title
                self.this.source_section = nil
                self.this.sectionSelectField.text = OTHER_NON_SELECT
                self.this.setSectionBtn.isEnabled = true
            }
        } else {
            self.this.source_media = nil
            self.this.mediaSelectField.text = OTHER_NON_SELECT
            self.this.source_section = nil
            self.this.sectionSelectField.text = "---"
            self.this.setSectionBtn.isEnabled = false
        }
        self.removeFromSuperview()
    }
}
extension SelectMediaView: UITableViewDelegate {
    
}
extension SelectMediaView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.this.source_media != nil) {
            self.medias = GetMediaRecord().getMediaRecordByTypeIdx(typeIdx: self.this.source_media!.typeIdx, orderBy: .byTitle)
        } else {
            self.medias = GetMediaRecord().getMediaRecord()
        }
        return self.medias.count+1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        if(indexPath.row < self.medias.count) {
            let media = self.medias[indexPath.row]
            if(media.author_id != "") {
                cell.detailTextLabel?.textColor = .systemGray2
                cell.detailTextLabel?.text = media.author!.title
            } else {
                cell.detailTextLabel?.textColor = .systemGray2
                cell.detailTextLabel?.text = "---"
            }
            cell.textLabel?.textColor = .systemGray
            cell.textLabel?.text = media.title
        } else {
            cell.textLabel?.textColor = .systemGray
            cell.textLabel?.text = OTHER_NON_SELECT
        }
        return cell
    }
}
