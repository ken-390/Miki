//
//  TextEditView.swift
//  Miki
//
//  Created by 柴田健作 on 2022/10/10.
//

import UIKit

class TextEditView: UIView {
    var parent: UIViewController?
    var word: Word = Word()
    
    var textLabel: UILabel = UILabel()
    var textArea: UITextView = UITextView()
    
    init(parent: UIViewController!, word: Word, upperView: UIView?){
        self.parent = parent
        self.word = word
        let view_pt: Double = 8
        let view_h: Double = 320
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
            textArea.text = self.word.text
        }
    }
    func setView(){
        let label_pl: Double = UIScreen.main.bounds.width*0.06
        let label_pt: Double = 10
        let label_w: Double = 80
        let textFont: UIFont = UIFont.systemFont(ofSize: 16)
        let textArea_pt: Double = 10
        let textArea_w: Double = self.frame.width*0.8
        let textArea_h: Double = self.frame.height*0.8

        textLabel.text = "テキスト"
        textLabel.textColor = .systemGray2
        textLabel.font = UIFont.systemFont(ofSize: 14)
        textLabel.frame = CGRect(x: label_pl,
                                 y: label_pt,
                                 width: label_w,
                                 height: textLabel.text!.heightOfString(usingFont: textLabel.font))
        self.addSubview(textLabel)
        
        textArea.font = textFont
        textArea.frame = CGRect(x: self.frame.midX-textArea_w*0.5,
                                y: textLabel.frame.maxY + textArea_pt,
                                 width: textArea_w,
                                 height: textArea_h)
        textArea.layer.borderColor = UIColor.systemGray5.cgColor
        textArea.layer.borderWidth = 1.0
        textArea.layer.cornerRadius = 20.0
        textArea.layer.masksToBounds = true
        self.addSubview(textArea)
        textArea.delegate = parent as? UITextViewDelegate
    }
    func checkInput() -> Bool{
        return false
    }
}
