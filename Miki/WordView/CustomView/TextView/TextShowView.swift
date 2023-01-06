//
//  TextShowView.swift
//  Miki
//
//  Created by 柴田健作 on 2022/10/23.
//

import UIKit

class TextShowView: UIView {
    var parent: UIViewController?
    var word: Word = Word()
    
    var textArea: UILabel = UILabel()
    
    init(parent: UIViewController!, word: Word, upperView: UIView?){
        self.parent = parent
        self.word = word
        let view_pt: Double = 0
        let view_h: Double = 0
        var view_y: Double = 0
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
            textArea.text = self.word.text
        }
    }
    func setView(){
        let textFont: UIFont = UIFont.systemFont(ofSize: 16)
        let textArea_pt: Double = 10
        let textArea_w: Double = self.frame.width*0.8

        textArea.font = textFont
        textArea.frame = CGRect(x: self.frame.midX-textArea_w*0.5,
                                y: textArea_pt,
                                 width: textArea_w,
                                 height: 0)
        textArea.layer.masksToBounds = true
        textArea.numberOfLines = 0
        textArea.sizeToFit()
        self.addSubview(textArea)
        
        self.frame.size.height = textArea.frame.maxY+textArea_pt
    }
}
