//
//  WordSourceEditView.swift
//  Miki
//
//  Created by 柴田健作 on 2022/11/18.
//

import UIKit

class WordSourceEditView: UIView {
    let OTHER_NON_SELECT: String = "その他（選択なし）"
    
    // Property
    var parent: UIViewController?
    var word: Word = Word()
    var source_media: Media? = nil
    var source_section: SectionItem? = nil
    // GlobalVariable
    var mediaList: [Media] = []
    var sectionList: [SectionItem] = []
    
    var label: UILabel!
    var mediaSelectField: UITextField!
    var setMediaBtn: UIButton!
    var sectionSelectField: UITextField!
    var sectionPickView: UIPickerView!
    var setSectionBtn: UIButton!
    
    init(parent: UIViewController!, word: Word, upperView: UIView?){
        self.parent = parent
        self.word = word
        
        var view_y: Double = 0
        if(upperView != nil){
            view_y = upperView!.frame.maxY + 4
        }
        
        let view_frame = CGRect(x: 0, y: view_y, width: UIScreen.main.bounds.width, height: 100)
        super.init(frame: view_frame)
        self.setUnderLine(color: .systemGray4)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(media: Media, section: SectionItem){
        self.source_media = media
        self.source_section = section
    }
    func setView(){
        let label_frame = CGRect(x: UIScreen.main.bounds.width*0.06, y: 14, width: 30, height: 0)
        let media_frame = CGRect(x: label_frame.maxX+10, y: 14, width: UIScreen.main.bounds.width*0.6, height: 22)
        let setMBtn_frame = CGRect(x: media_frame.maxX, y: media_frame.minY-10, width: 42, height: 42)
        let section_frame = CGRect(x: media_frame.minX, y: media_frame.maxY+20, width: UIScreen.main.bounds.width*0.4, height: 22)
        let setSBtn_frame = CGRect(x: section_frame.maxX, y: section_frame.minY-10, width: 42, height: 42)
        
        // LABEL
        self.label = UILabel(frame: label_frame)
        label.text = "出典"
        label.textColor = .systemGray2
        label.font = UIFont.systemFont(ofSize: 14)
        label.frame.size.height = label.text!.heightOfString(usingFont: label.font)
        self.addSubview(label)
        // MEDIA FIELD
        self.mediaSelectField = UITextField(frame: media_frame)
        mediaSelectField.font = .systemFont(ofSize: 14.0)
        mediaSelectField.text = self.source_media?.title
        mediaSelectField.keyboardType = .default
        mediaSelectField.borderStyle = .none
        mediaSelectField.isEnabled = false
        mediaSelectField.setUnderLine(color: .systemBlue)
        self.addSubview(mediaSelectField)
        // SET MEDIA BUTTON
        self.setMediaBtn = UIButton(frame: setMBtn_frame)
        setMediaBtn.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        setMediaBtn.tintColor = .systemBlue
        setMediaBtn.addTarget(self, action: #selector(setMBtn_onTap(_:)), for: UIControl.Event.touchUpInside)
        self.addSubview(setMediaBtn)
        // SECTION FIEDL
        self.sectionSelectField = UITextField(frame: section_frame)
        sectionSelectField.font = .systemFont(ofSize: 14.0)
        sectionSelectField.text = self.source_section?.title
        sectionSelectField.keyboardType = .default
        sectionSelectField.borderStyle = .none
        sectionSelectField.isEnabled = false
        sectionSelectField.setUnderLine(color: .systemBlue)
        self.addSubview(sectionSelectField)
        // SECTION PICKERVIEW
        self.sectionPickView = UIPickerView()
        sectionPickView.tag = 1
        sectionPickView.delegate = self
        self.sectionSelectField.inputView = sectionPickView
        // PICKERVIEW TOOLBAR
        let toolbar = UIToolbar()
        toolbar.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 44)
        let doneButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.donePicker))
        toolbar.setItems([doneButtonItem], animated: true)
        self.sectionSelectField.inputAccessoryView = toolbar
        // SET SECTION BUTTON
        self.setSectionBtn = UIButton(frame: setSBtn_frame)
        setSectionBtn.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        setSectionBtn.tintColor = .systemBlue
        setSectionBtn.addTarget(self, action: #selector(setSBtn_onTap(_:)), for: UIControl.Event.touchUpInside)
        self.addSubview(setSectionBtn)
    }
    @objc func setMBtn_onTap(_ sender: UIButton) {
        let selectMediaView = SelectMediaView(parent: self.parent, this: self)
        self.parent!.view.addSubview(selectMediaView)
    }
    @objc func setSBtn_onTap(_ sender: UIButton) {
        self.sectionSelectField.isEnabled = true
        self.sectionSelectField.becomeFirstResponder()
    }
    @objc func donePicker() {
        self.sectionSelectField.endEditing(true)
        self.sectionSelectField.isEnabled = false
        self.sectionSelectField.text = self.source_section == nil ? OTHER_NON_SELECT : self.source_section?.title
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.mediaSelectField.endEditing(true)
        self.sectionSelectField.endEditing(true)
    }
}

extension WordSourceEditView: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
       return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (self.source_media != nil) {
            self.sectionList = GetSectionItem.getSectionItems(parentId: self.source_media!.id)
            return self.sectionList.count + 1
        }
        else {
            return 1
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var text: String = ""
        if(row < self.sectionList.count) {
            text = self.sectionList[row].title
            if(self.source_section != nil && text == self.source_section!.title) {
                sectionPickView.selectRow(row, inComponent: 0, animated: false)
            }
        } else {
            text = OTHER_NON_SELECT
            if(self.source_section == nil) {
                sectionPickView.selectRow(row, inComponent: 0, animated: false)
            }
        }
        
        
        return text
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(row < self.sectionList.count) {
            self.source_section = sectionList[row]
        } else {
            self.source_section = nil
        }
    }
}
