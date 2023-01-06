//
//  TitleView.swift
//  Miki
//
//  Created by 柴田健作 on 2022/10/10.
//

import UIKit

class TitleEditView: UIView {
    var parent: UIViewController?
    var word: Word = Word()
    
    var titleTextField: UITextField = UITextField()
    
    init(parent: UIViewController!, word: Word, upperView: UIView?){
        self.parent = parent
        self.word = word
        let view_pt: Double = 8
        let view_h: Double = 95
        var view_y: Double = 0
        
        if(upperView != nil){
            view_y = upperView!.frame.maxY + view_pt
        }
        super.init(frame: CGRect(x: 0,
                                 y: view_y,
                                 width: UIScreen.main.bounds.width,
                                 height: view_h))
        self.setUnderLine(color: .systemGray4)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(){
        if(word.id != nil){
            titleTextField.text = self.word.title
        }
    }
    func setView(){
        let textField_pl: Double = UIScreen.main.bounds.width*0.12
        let textField_pt: Double = 20
        let textField_w: Double = UIScreen.main.bounds.width*0.76
        
        // TextField
        titleTextField.font = .systemFont(ofSize: 24.0)
        titleTextField.placeholder = "名称"
        // titleTextField.keyboardType = .default
        titleTextField.frame = CGRect(x: textField_pl,
                                      y: textField_pt,
                                      width: textField_w,
                                      height: 45)
        titleTextField.borderStyle = .none
        titleTextField.setUnderLine(color: .systemBlue)
        self.addSubview(titleTextField)
        titleTextField.delegate = parent as? UITextFieldDelegate
    }
    func checkInput() -> Bool{
        if(titleTextField.text == ""){
            titleTextField.backgroundColor = .systemOrange
            return true
        }
        return false
    }
}
