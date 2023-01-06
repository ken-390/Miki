//
//  AuthorCell.swift
//  Miki
//
//  Created by 柴田健作 on 2022/11/26.
//

import UIKit

class AuthorCell: UITableViewCell {
    let OTHER_NON_SELECT: String = "---（選択なし）"

    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var authorField: UITextField!
    var authorPickerView: UIPickerView!
    var toolbar: UIToolbar!
    
    var persons: [Word] = []
    var selectedPerson: Word? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setupLayout()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setupLayout() {
        setupPickerView()
        setupAuthorLayout()
    }
    private func setupPickerView() {
        self.authorPickerView = UIPickerView()
        authorPickerView.delegate = self
        
        // PICKERVIEW TOOLBAR
        self.toolbar = UIToolbar()
        toolbar.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 44)
        let doneButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.donePicker))
        toolbar.setItems([doneButtonItem], animated: true)
    }
    private func setupAuthorLayout() {
        self.authorLabel.text = "著者"
        self.authorField.setUnderLine(color: .systemBlue)
        authorField.inputView = self.authorPickerView
        authorField.inputAccessoryView = toolbar
    }
    
    @objc func donePicker() {
        self.authorField.endEditing(true)
        self.authorField.text = self.selectedPerson == nil ? OTHER_NON_SELECT : self.selectedPerson?.title
    }
}

extension AuthorCell: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
       return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        self.persons = GetWordRecords().getWordRecordsByTypeAndTitle(type_id: 2, title: "")
        return self.persons.count + 1
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var text: String = ""
        if(row < self.persons.count) {
            text = self.persons[row].title!
            if(self.selectedPerson != nil && self.persons[row].id == self.selectedPerson!.id) {
                authorPickerView.selectRow(row, inComponent: 0, animated: false)
            }
        } else {
            text = OTHER_NON_SELECT
            if(self.selectedPerson == nil) {
                authorPickerView.selectRow(row, inComponent: 0, animated: false)
            }
        }
        
        return text
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(row < self.persons.count) {
            self.selectedPerson = persons[row]
        } else {
            self.selectedPerson = nil
        }
    }
}
