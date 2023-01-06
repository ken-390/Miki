//
//  LargetImageView.swift
//  Miki
//
//  Created by 柴田健作 on 2022/11/07.
//

import UIKit

class LargetImageView: UIView {
    let imageView_frame = CGRect(x: UIScreen.main.bounds.width*0.1,
                                 y: UIScreen.main.bounds.height*0.1,
                                 width: UIScreen.main.bounds.width*0.8,
                                 height: UIScreen.main.bounds.height*0.8)
    let closeFrame = CGRect(x: 10, y: 20, width: 40, height: 40)
    let menuFrame = CGRect(x: UIScreen.main.bounds.width-50, y: 20, width: 40, height: 40)
    
    var imageView: UIImageView = UIImageView()
    var closeButton: UIButton = UIButton()
    var menuButton: UIButton = UIButton()
    
    var word: Word!
    var thisImage: Image!
    var parent: ShowImageView!

    init(word: Word, parent: ShowImageView){
        self.word = word
        self.parent = parent
        super.init(frame: CGRect(x: 0, y: 0,
                                 width: UIScreen.main.bounds.width,
                                 height: UIScreen.main.bounds.height))
        self.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        
        // IMAGE
        self.imageView.frame = imageView_frame
        self.imageView.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        imageView.contentMode = .scaleAspectFit
        let images: [Image] = GetImage().getImageBySourceId(parent_id: self.word.id!)
        if(images.count == 1){
            if FileManager.default.fileExists(atPath: getFileURL(fileName: images[0].id).path) {
                if let imageData = UIImage(contentsOfFile: getFileURL(fileName: images[0].id).path) {
                    imageView.image = imageData
                    self.thisImage = images[0]
                }
            }
        }
        self.addSubview(imageView)
        
        // CLOSE
        self.closeButton.frame = closeFrame
        closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeButton.tintColor = .white
        closeButton.addTarget(self, action: #selector(closeTaped(_:)), for: UIControl.Event.touchUpInside)
        self.addSubview(closeButton)
        
        // MENU
        self.menuButton.frame = menuFrame
        menuButton.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        menuButton.tintColor = .white
        let delete = UIAction(title: "delete", image: nil) { (action) in
            let _: Result = DeleteImage().deleteImage(image: self.thisImage,
                                                      url: self.getFileURL(fileName: self.thisImage.id))
            parent.imageView.image = nil
            parent.imageView.backgroundColor = .systemGray5
            self.removeFromSuperview()
        }
        menuButton.menu = UIMenu(title: "", children: [delete])
        menuButton.showsMenuAsPrimaryAction = true
        self.addSubview(menuButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func closeTaped(_ sender: Any){
        self.removeFromSuperview()
    }
    
    func getFileURL(fileName: String) -> URL {
        let docDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0] as NSURL
        return docDir.appendingPathComponent(fileName)!
    }
}
