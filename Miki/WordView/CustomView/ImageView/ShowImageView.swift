//
//  ShowImageView.swift
//  Miki
//
//  Created by 柴田健作 on 2022/10/23.
//

import UIKit

class ShowImageView: UIView, UINavigationControllerDelegate {
    var parent: UIViewController?
    var word: Word = Word()
    var thisImage: Image?
    
    var imageView: UIImageView = UIImageView()
    
    init(parent: UIViewController!, word: Word, upperView: UIView?, leftView: UIView?, width: Double, height: Double){
        self.parent = parent
        self.word = word
        let view_pt: Double = 8
        var view_x: Double = 0
        var view_y: Double = 0
        if(upperView != nil){
            view_y = upperView!.frame.maxY + view_pt
        }
        if(leftView != nil){
            view_x = leftView!.frame.maxX
        }
        super.init(frame: CGRect(x: view_x,
                                 y: view_y,
                                 width: width,
                                 height: height))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getFileURL(fileName: String) -> URL {
        let docDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0] as NSURL
        return docDir.appendingPathComponent(fileName)!
    }
    @objc func imageView_touchDown(){
        if(self.imageView.image == nil){
            let imagePickerController = UIImagePickerController()
            imagePickerController.sourceType = .photoLibrary
            imagePickerController.delegate = self
            imagePickerController.mediaTypes = ["public.image"]
            parent!.present(imagePickerController,animated: true,completion: nil)
        }
        else{
            parent!.view.addSubview(LargetImageView(word: self.word, parent: self))
        }
    }
    
    func setData(){
        let images: [Image] = GetImage().getImageBySourceId(parent_id: self.word.id!)
        if(images.count == 1){
            if FileManager.default.fileExists(atPath: getFileURL(fileName: images[0].id).path) {
                if let imageData = UIImage(contentsOfFile: getFileURL(fileName: images[0].id).path) {
                    imageView.image = imageData
                    self.thisImage = images[0]
                    self.imageView.backgroundColor = .white
                    return
                }
            }
        }
        self.imageView.backgroundColor = .systemGray5
    }
    func setView(){
        let image_pt: Double = self.frame.height*0.05
        let image_pl: Double = self.frame.width*0.05
        let image_w: Double = self.frame.width*0.9
        let image_h: Double = self.frame.height*0.9
        imageView.frame = CGRect(x: image_pl,
        y: image_pt, width: image_w, height: image_h)
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                    action: #selector(imageView_touchDown)))
        imageView.contentMode = .scaleAspectFit
        self.addSubview(imageView)
    }
}

extension ShowImageView: UIImagePickerControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selected: UIImage = (info[.originalImage] as! UIImage)
        // Create Image Record
        self.thisImage = CreateImage().createImage(parent_id: self.word.id!)
        // Save Image
        let jpgImageData = selected.jpegData(compressionQuality:0.5)
        do {
            try jpgImageData!.write(to: getFileURL(fileName: self.thisImage!.id), options: .atomic)
        } catch {
            print(error)
        }
        
        // Show Image
        self.imageView.image = selected
        self.imageView.backgroundColor = .white
        picker.dismiss(animated: true)
    }
}
