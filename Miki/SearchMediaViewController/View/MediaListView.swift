//
//  MediaListView.swift
//  Miki
//
//  Created by 柴田健作 on 2022/11/08.
//

import UIKit

class MediaListView: UIView {
    var parent: SearchMediaViewController
    
    let imgView: UIImageView = UIImageView()
    let pageCont: UIPageControl = UIPageControl()
    let mediaLabel: UILabel = UILabel()
    
    var imgList: [UIImage] = []
    var pageNum: Int = 0
    var mediaList: [MediaType] = []
    
    init(parent: SearchMediaViewController){
        self.parent = parent
        self.mediaList = MediaType.all
        for media in self.mediaList {
            let name = media.title
            let img = UIImage(named: name)
            if(img != nil){
                self.imgList.append(img!)
            }
        }
        super.init(frame: CGRect(x: 0,
                                 y: parent.navigationController!.navigationBar.frame.maxY,
                                 width: UIScreen.main.bounds.width,
                                 height: 160))
        
        // Setting View
        self.clipsToBounds = true
        self.backgroundColor = .red
        // frames
        let imageFlame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height-40.7)
        let pageFlame = CGRect(x: imageFlame.midX-imageFlame.width*0.5,
                               y: self.frame.height-20, width: self.frame.width, height: 20)
        let labelFlame = CGRect(x: 0, y: imageFlame.maxY, width: self.frame.width, height: 40)
        // IMAGE
        self.imgView.frame = imageFlame
        imgView.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        imgView.contentMode = .scaleAspectFill
        imgView.image = imgList[self.pageNum]
        self.addSubview(imgView)
        // PAGE COUNT
        self.pageCont.frame = pageFlame
        pageCont.numberOfPages = imgList.count
        pageCont.hidesForSinglePage = true
        pageCont.currentPage = self.pageNum
        pageCont.addTarget(self, action: #selector(pageCont_onTap), for: .valueChanged)
        self.addSubview(pageCont)
        // LABEL
        self.mediaLabel.frame = labelFlame
        mediaLabel.textAlignment = .center
        mediaLabel.font = .systemFont(ofSize: 24)
        mediaLabel.text = self.mediaList[self.pageNum].title
        mediaLabel.backgroundColor = .systemBackground.withAlphaComponent(0.7)
        mediaLabel.setUnderLine(color: .systemGray4)
        self.addSubview(mediaLabel)
    }
    
    @objc func pageCont_onTap(){
        updCurrentPage(num: pageCont.currentPage)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updCurrentPage(num: Int){
        self.pageNum = num
        imgView.image = self.imgList[self.pageNum]
        mediaLabel.text = self.mediaList[self.pageNum].title
    }
}
