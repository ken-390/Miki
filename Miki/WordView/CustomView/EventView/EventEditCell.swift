//
//  EventEditCell.swift
//  Miki
//
//  Created by 柴田健作 on 2022/10/11.
//

import UIKit

class EventEditCell: UICollectionViewCell {
    var relation: Relationship = Relationship()

    @IBOutlet weak var view: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setView(){
        let label_h: Double = 38
        let label_w: Double = 200
        
        view.frame = CGRect(x: 5,
                            y: 5,
                            width: self.frame.width-10,
                            height: self.frame.height-10)
        view.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        view.layer.shadowColor = UIColor.systemBlue.cgColor
        view.layer.shadowOpacity = 0.4
        view.layer.shadowRadius = 2
        view.layer.cornerRadius = view.frame.height*0.5
        titleLabel.text = ":  " + (relation.related?.title)!
        titleLabel.frame = CGRect(x: 0,
                                  y: view.frame.height*0.5-label_h*0.5,
                                  width: label_w,
                                  height: label_h)
    }
}
