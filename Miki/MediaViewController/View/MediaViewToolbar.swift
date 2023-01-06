//
//  MediaDetailViewToolbar.swift
//  Miki
//
//  Created by 柴田健作 on 2022/11/12.
//

import Foundation
import UIKit
import Segmentio

class MediaViewToolbar: UIView{
    var segmentBar: Segmentio!
    var mainView: MediaRelsView!
    
    var parent: MediaViewController!
    
    let segmentCells: [SegmentCell] = [.review, .chapter]
    
    init(parent: MediaViewController, frame: CGRect){
        super.init(frame: frame)
        self.parent = parent
        
        let segmentBar_frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 40)
        let mainView_frame = CGRect(x: 0, y: segmentBar_frame.maxY, width: self.frame.width, height: self.frame.height-40)
        
        // MAINVIEW
        self.mainView = MediaRelsView(parent: self.parent, frame: mainView_frame)
        self.addSubview(mainView)
        // SEGUMENT
        self.segmentBar = Segmentio(frame: segmentBar_frame)
        segmentBar.setup(
            content: self.setSegmentioItems(),
            style: SegmentioStyle(rawValue: "onlyLabel")!,
            options: nil
        )
        segmentBar.valueDidChange = { segmentio, segmentIndex in
            print("Selected item: ", segmentIndex)
        }
        segmentBar.valueDidChange = { segmentio, segmentIndex in
            self.mainView.showContentsBySegmentIdx(type: self.segmentCells[segmentIndex])
        }
        segmentBar.selectedSegmentioIndex = 0
        segmentBar.setUnderLine(color: .systemGray4)
        self.addSubview(segmentBar)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setSegmentioItems() -> [SegmentioItem]{
        var content = [SegmentioItem]()
        for cell in segmentCells {
            let tornadoItem = SegmentioItem(
                title: cell.text,
                image: nil
            )
            content.append(tornadoItem)
        }
        return content
    }
}
