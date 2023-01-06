//
//  Extension.swift
//  Miki
//
//  Created by 柴田健作 on 2022/09/29.
//

import Foundation
import UIKit

extension String {
    public func widthOfString(usingFont font: UIFont) -> CGFloat {
        let attributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: attributes)
        return size.width
    }

    public func heightOfString(usingFont font: UIFont) -> CGFloat {
        let attributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: attributes)
        return size.height
    }
}

extension UIView {
    public func setUnderLine(color: UIColor) {
        let underline = UIView()
        underline.frame = CGRect(x: 0, y: frame.height, width: frame.width, height: 0.5)
        underline.backgroundColor = color
        addSubview(underline)
        bringSubviewToFront(underline)
    }
}

extension UILabel {
    func getFitWidth() -> Double{
        if (self.text != nil) {
            let font: UIFont = self.font
            return self.text!.widthOfString(usingFont: font)
        }
        return self.frame.width
    }
    
    func getFitHeight() -> Double{
        if (self.text != nil) {
            let font: UIFont = self.font
            return self.text!.heightOfString(usingFont: font)
        }
        return self.frame.width
    }
}

extension UITextField {
    func addPaddingAndIcon(_ image: UIImage, padding: CGFloat,isLeftView: Bool) {
        let viewFrame = CGRect(x: 0, y: 0, width: image.size.width + padding, height: self.frame.height)
        let iconFrame = CGRect(x: 0, y: viewFrame.midY-image.size.height*0.5, width: image.size.width + padding, height: image.size.height)

        let outerView = UIView(frame: viewFrame)
        let iconView  = UIButton(frame: iconFrame)
        
        iconView.configuration?.title = ""
        iconView.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        iconView.addTarget(self, action: #selector(tapped(_:)), for: UIControl.Event.touchUpInside)
        
        outerView.addSubview(iconView)

        if isLeftView {
          leftViewMode = .always
          leftView = outerView
        } else {
          rightViewMode = .always
          rightView = outerView
        }
    }

    @objc func tapped(_ sender: UIButton) {
        self.becomeFirstResponder()
    }
}

extension UIImageView {
    public func setImageBySourceID(parent_id: String){
        let images: [Image] = GetImage().getImageBySourceId(parent_id: parent_id)
        if(images.count == 1){
            if FileManager.default.fileExists(atPath: getFileURL(fileName: images[0].id).path) {
                if let imageData = UIImage(contentsOfFile: getFileURL(fileName: images[0].id).path) {
                    self.image = imageData
                }
            }
        }
        let defoImageData = UIImage(named: "NoImage")
        self.image = defoImageData
    }
    
    private func getFileURL(fileName: String) -> URL {
        let docDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0] as NSURL
        return docDir.appendingPathComponent(fileName)!
    }
}
