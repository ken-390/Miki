//
//  EventEditView.swift
//  Miki
//
//  Created by 柴田健作 on 2022/10/11.
//

import UIKit

class EventEditView: UIView {
    var parent: UIViewController?
    var word: Word = Word()
    
    let view_pt: Double = 8
    let view_h: Double = 1000
    var view_y: Double = 0
    
    var label: UILabel = UILabel()
    var addButton: UIButton = UIButton(type: .custom)
    var collectionTable: UICollectionView? = nil
    // AddEventView
    let subView: UIView = UIView()
    let addEventView: UIView = UIView()
    let topView: UIView = UIView()
    let titleLabel: UILabel = UILabel()
    let label_title: UILabel = UILabel()
    let title: UITextField = UITextField()
    let label_date: UILabel = UILabel()
    let year: UITextField = UITextField()
    let label_split1: UILabel = UILabel()
    let month: UITextField = UITextField()
    let label_split2: UILabel = UILabel()
    let day: UITextField = UITextField()
    let table: UITableView = UITableView()
    let buttonsView: UIView = UIView()
    let doneButton: UIButton = UIButton(type: .custom)
    let cancelButton: UIButton = UIButton(type: .custom)
    var events: [Relationship] = []
    var selectedWords: [Word] = []
    
    init(parent: UIViewController!, word: Word, upperView: UIView?){
        self.parent = parent
        self.word = word
        
        if(upperView != nil){
            view_y = upperView!.frame.maxY + view_pt
        }
        super.init(frame: CGRect(x: 0,
                                 y: view_y,
                                 width: UIScreen.main.bounds.width,
                                 height: view_h))
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(){
        if(word.id != nil){
        }
    }
    func setView(){
        let label_pt: Double = 4
        let label_pl: Double = 10
        let label_w: Double = 70
        let add_pl: Double = 5
        let add_hw: Double = 40
        let table_pt: Double = 4
        let table_w: Double = UIScreen.main.bounds.width*0.9
        let table_h: Double = view_h-100
        let cell_h: Double = 44
        
        // Label
        label.text = "イベント"
        label.frame = CGRect(x: label_pl,
                                  y: label_pt,
                                  width: label_w,
                                  height: label.text!.heightOfString(usingFont: UIFont.systemFont(ofSize: 32)))
        self.addSubview(label)
        // AddButton
        addButton.setImage(UIImage(systemName: "plus.circle.fill"), for: UIControl.State())
        addButton.tintColor = .systemBlue
        addButton.frame = CGRect(
            x: label.frame.maxX + add_pl,
            y: label.frame.midY-add_hw*0.5,
            width: add_hw,
            height: add_hw
        )
        addButton.addTarget(self, action: #selector(tapAddButton(_:)), for: UIControl.Event.touchUpInside)
        self.addSubview(addButton)
        // Table
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: table_w, height: cell_h)
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 1
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionTable = UICollectionView(frame: CGRect(x: self.frame.midX-table_w*0.5, y: label.frame.maxY+table_pt, width: table_w, height: table_h), collectionViewLayout:flowLayout)
        collectionTable!.register(UINib(nibName: "EventEditCell", bundle: nil), forCellWithReuseIdentifier: "EventEditCell")
        collectionTable!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        self.addSubview(collectionTable!)
        collectionTable!.delegate = self
        collectionTable!.dataSource = self
    }
    
    @objc func tapAddButton(_ sender:UIButton) {
        if(self.word.id != nil){
            let subView: UIView = SetAddEventView()
            parent?.view.addSubview(subView)
        }
        else{
            let dialog = UIAlertController(title: "Caution", message: "Please Save This", preferredStyle: .alert)
            dialog.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            parent!.present(dialog, animated: true, completion: nil)
        }
    }
    @objc func textFieldDidChange(_ sender: UITextField) {
        table.reloadData()
    }
    @objc func tapDoneButton(_ sender: UIButton) {
        let selected: Int = table.indexPathForSelectedRow!.row
        let _: Result = CreateRelationRecord().createRelationRecord(source: self.word,
                                                    related: selectedWords[selected],
                                                    type_id: 3)
        collectionTable?.reloadData()
        subView.removeFromSuperview()
    }
    @objc func tapCancelButton(_ sender: UIButton) {
        subView.removeFromSuperview()
    }
    
    func SetAddEventView() -> UIView{
        let view_h: Double = 400
        let view_w: Double = 300
        let topView_h: Double = 60
        let buttonsView_h: Double = 38
        
        subView.frame = CGRect(x: 0, y: 0,
                                    width: UIScreen.main.bounds.width,
                                    height: UIScreen.main.bounds.height)
        subView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        subView.isOpaque = true
        addEventView.backgroundColor = .white
        addEventView.frame = CGRect(x: subView.frame.midX-view_w*0.5,
                                    y: subView.frame.midY-view_h*0.5,
                                    width: view_w,
                                    height: view_h)
        subView.addSubview(addEventView)
        topView.frame = CGRect(x: 0,
                               y: 0,
                               width: addEventView.frame.width,
                               height: topView_h)
        titleLabel.text = "New Event"
        titleLabel.textColor = .white
        let titleLabel_w: CGFloat = (titleLabel.text?.widthOfString(usingFont: UIFont.systemFont(ofSize: 32)))!
        let titleLabel_h: CGFloat = (titleLabel.text?.heightOfString(usingFont: UIFont.systemFont(ofSize: 32)))!
        titleLabel.textAlignment = NSTextAlignment.center
        titleLabel.frame = CGRect(x: topView.frame.width*0.5-titleLabel_w*0.5,
                                  y: topView.frame.height*0.5-titleLabel_h*0.5,
                                  width: titleLabel_w,
                                  height: titleLabel_h)
        topView.backgroundColor = .systemGreen
        topView.addSubview(titleLabel)
        addEventView.addSubview(topView)
        label_title.text = "検索"
        label_title.frame = CGRect(x: 10,
                                   y: topView.frame.maxY+30,
                                   width: (label_title.text?.widthOfString(usingFont: UIFont.systemFont(ofSize: 32)))! ,
                                   height: (label_title.text?.heightOfString(usingFont: UIFont.systemFont(ofSize: 32)))!)
        addEventView.addSubview(label_title)
        title.text = ""
        title.borderStyle = .roundedRect
        title.frame = CGRect(x: 80,
                             y: label_title.frame.midY-38*0.5,
                             width: 180,
                             height: 38)
        title.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        addEventView.addSubview(title)
        let table_w: Double = addEventView.frame.width*0.8
        let table_h: Double = addEventView.frame.height*0.3
        table.frame = CGRect(x: addEventView.frame.width*0.5-table_w*0.5,
                             y: label_title.frame.maxY+10.0,
                             width: table_w,
                             height: table_h)
        table.layer.borderColor = UIColor.systemGray4.cgColor
        table.layer.borderWidth = 1.0
        table.rowHeight = 38
        table.reloadData()
        table.dataSource = self
        table.delegate = self
        table.register(UINib(nibName: "AddEventViewCell", bundle: nil), forCellReuseIdentifier: "addEventViewCell")
        addEventView.addSubview(table)
        label_date.text = "日付"
        label_date.frame = CGRect(x: 10,
                                   y: table.frame.maxY+20,
                                   width: (label_date.text?.widthOfString(usingFont: UIFont.systemFont(ofSize: 32)))! ,
                                   height: (label_date.text?.heightOfString(usingFont: UIFont.systemFont(ofSize: 32)))!)
        addEventView.addSubview(label_date)
        year.text = "----"
        year.textColor = .systemGray4
        year.textAlignment = NSTextAlignment.right
        year.isEnabled = false
        year.frame = CGRect(x: title.frame.minX,
                             y: label_date.frame.midY-38*0.5,
                             width:60,
                             height: 38)
        label_split1.text = "/"
        label_split1.textColor = .systemGray4
        label_split1.textAlignment = NSTextAlignment.center
        label_split1.frame = CGRect(x: year.frame.maxX+10,
                                   y: label_date.frame.midY-38*0.5,
                                   width: (label_split1.text?.widthOfString(usingFont: UIFont.systemFont(ofSize: 32)))! ,
                                   height: 38)
        addEventView.addSubview(label_split1)
        addEventView.addSubview(year)
        month.text = "--"
        month.textColor = .systemGray4
        month.textAlignment = NSTextAlignment.center
        month.isEnabled = false
        month.frame = CGRect(x: label_split1.frame.maxX,
                             y: label_date.frame.midY-38*0.5,
                             width: 36, height: 38)
        addEventView.addSubview(month)
        label_split2.text = "/"
        label_split2.textColor = .systemGray4
        label_split2.textAlignment = NSTextAlignment.center
        label_split2.frame = CGRect(x: month.frame.maxX,
                                   y: label_date.frame.midY-38*0.5,
                                   width: (label_split2.text?.widthOfString(usingFont: UIFont.systemFont(ofSize: 32)))! ,
                                   height: (label_split2.text?.heightOfString(usingFont: UIFont.systemFont(ofSize: 32)))!)
        addEventView.addSubview(label_split2)
        day.text = "--"
        day.textColor = .systemGray4
        day.textAlignment = NSTextAlignment.center
        day.isEnabled = false
        day.frame = CGRect(x: label_split2.frame.maxX,
                            y: label_date.frame.midY-38*0.5,
                            width: 36, height: 38)
        addEventView.addSubview(day)
        buttonsView.frame = CGRect(x: 0,
                                   y: addEventView.frame.height-buttonsView_h,
                                   width: addEventView.frame.width,
                                   height: buttonsView_h)
        doneButton.setTitle("OK", for: .normal)
        doneButton.setTitleColor(UIColor.systemGreen, for: .normal)
        doneButton.setTitleColor(UIColor.systemGray4, for: .disabled)
        doneButton.frame = CGRect(
            x: 0,
            y: 0,
            width: buttonsView.frame.width*0.5,
            height: buttonsView_h
        )
        doneButton.addTarget(self, action: #selector(tapDoneButton(_:)), for: UIControl.Event.touchUpInside)
        buttonsView.addSubview(doneButton)
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(UIColor.systemGreen, for: .normal)
        cancelButton.frame = CGRect(
            x: doneButton.frame.width,
            y: 0,
            width: buttonsView.frame.width*0.5,
            height: buttonsView_h
        )
        cancelButton.addTarget(self, action: #selector(tapCancelButton(_:)), for: UIControl.Event.touchUpInside)
        buttonsView.addSubview(cancelButton)
        addEventView.addSubview(buttonsView)
        
        return subView
    }
}

extension EventEditView: UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(self.word.id == nil){
            return 0
        }
        self.events = GetRelationRecords().getRelationRecordsBySourceId(source_id: self.word.id, type_id: 3)
        return events.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: EventEditCell = collectionView.dequeueReusableCell(withReuseIdentifier: "EventEditCell", for: indexPath) as! EventEditCell
        cell.relation = events[indexPath.row]
        cell.setView()
        return cell
    }
}
extension EventEditView: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        year.text = "----"
        month.text = "--"
        day.text = "--"
        
        let keyword: String = title.text!
        self.selectedWords = GetWordRecords().getWordRecordsByTypeAndTitle(type_id: 3, title: keyword)
        
        doneButton.isEnabled = false
        return selectedWords.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.row == selectedWords.count){
            let cell = tableView.dequeueReusableCell(withIdentifier: "addEventViewCell", for: indexPath) as! AddEventViewCell
            return cell
        }
        else{
            let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
            cell.textLabel?.text = selectedWords[indexPath.row].title
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.addEventView.endEditing(true)
        if(indexPath.row == selectedWords.count){
            table.deselectRow(at: indexPath, animated: true)
            year.text = "----"
            month.text = "--"
            day.text = "--"
            // Create New Event
            var alertTextField: UITextField?
            let alert = UIAlertController(
                title: "Create Event",
                message: "Please enter the name of the Event",
                preferredStyle: UIAlertController.Style.alert)
            alert.addTextField(
                configurationHandler: {(textField: UITextField!) in
                    alertTextField = textField
            })
            alert.addAction(
                UIAlertAction(
                    title: "Cancel",
                    style: UIAlertAction.Style.cancel,
                    handler: nil))
            alert.addAction(
                UIAlertAction(
                    title: "OK",
                    style: UIAlertAction.Style.default) { _ in
                    if let text = alertTextField?.text {
//                        let newWord: Word = Word(id: "",
//                                                 type_id: 3,
//                                                 title: text,
//                                                 text: "")
//                        let _: Result = CreateWordRecord.createWordRecord(word: newWord)
//                        self.title.text = text
//                        self.table.reloadData()
                    }
                }
            )
            table.deselectRow(at: indexPath, animated: true)
            parent!.present(alert, animated: true, completion: nil)
            return
        }
        // Event Cell
        doneButton.isEnabled = true
    }
}
