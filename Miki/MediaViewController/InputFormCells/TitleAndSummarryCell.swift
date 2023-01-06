//
//  TitleAndSummarryCell.swift
//  Miki
//
//  Created by 柴田健作 on 2022/11/26.
//

import UIKit

class TitleAndSummarryCell: UITableViewCell {

    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleField: UITextField!
    
    @IBOutlet weak var summaryView: UIView!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var summaryText: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupLayout()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setupLayout() {
        setupTitleLayout()
        setupSummaryLayout()
    }
    private func setupTitleLayout() {
        self.titleLabel.text = "タイトル"
        self.titleField.setUnderLine(color: .systemBlue)
    }
    private func setupSummaryLayout() {
        self.summaryLabel.text = "概要"
        self.summaryText.layer.borderColor = UIColor.systemGray5.cgColor
        summaryText.layer.borderWidth = 1.0
        summaryText.layer.cornerRadius = 20.0
        summaryText.layer.masksToBounds = true
    }
}
