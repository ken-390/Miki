//
//  AddEventRelView.swift
//  Miki
//
//  Created by 柴田健作 on 2022/10/17.
//

import UIKit

class AddEventRelView: UIView {
    var parent: TableToolBar?
    var topParent: UIViewController?
    var displayedWords: [Word] = []
    var typeId: Int = -1
    
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

    init(parent: TableToolBar, typeId: Int){
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        // Set Variable
        self.parent = parent
        self.topParent = self.parent?.topParent
        self.typeId = typeId
        // Set FrameData
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
        self.addSubview(subView)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func textFieldDidChange(_ sender: UITextField) {
        table.reloadData()
    }
    @objc func tapDoneButton(_ sender: UIButton) {
        let selected: Int = table.indexPathForSelectedRow!.row
        let _: Result = CreateRelationRecord().createRelationRecord(source: parent!.word,
                                                    related: displayedWords[selected],
                                                                    type_id: self.typeId)
        self.parent?.parent?.tableView!.reloadData()
        self.removeFromSuperview()
    }
    @objc func tapCancelButton(_ sender: UIButton) {
        self.removeFromSuperview()
    }
}
extension AddEventRelView: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        year.text = "----"
        month.text = "--"
        day.text = "--"
        
        let keyword: String = title.text!
        self.displayedWords = GetWordRecords().getWordRecordsByTypeAndTitle(type_id: self.typeId, title: keyword)
        
        doneButton.isEnabled = false
        return displayedWords.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.row == displayedWords.count){
            let cell = tableView.dequeueReusableCell(withIdentifier: "addEventViewCell", for: indexPath) as! AddEventViewCell
            return cell
        }
        else{
            let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
            cell.textLabel?.text = displayedWords[indexPath.row].title
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.addEventView.endEditing(true)
        if(indexPath.row == displayedWords.count){
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
                    style: UIAlertAction.Style.default) { [self] _ in
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
            self.topParent!.present(alert, animated: true, completion: nil)
            return
        }
    }
}
