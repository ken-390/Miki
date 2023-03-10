//
//  MediaDetailViewController.swift
//  Miki
//
//  Created by 柴田健作 on 2022/11/12.
//

import UIKit

class MediaViewController: UIViewController {
    var mediaView: MediaDetailView!
    var toolbar: MediaViewToolbar!
    
    // Property
    var thisMedia: Media!
    var selectedSection: SectionItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        let mediaView_frame = CGRect(x: 0, y: self.navigationController!.navigationBar.frame.maxY, width: self.view.frame.width, height: 200)
        let toolbar_frame = CGRect(x: 0, y: mediaView_frame.maxY, width: self.view.frame.width, height: self.view.frame.height-(200+self.tabBarController!.tabBar.frame.height+mediaView_frame.origin.y))

        // MEDIAVIEW
        self.mediaView = MediaDetailView(parent: self, frame: mediaView_frame)
        self.view.addSubview(mediaView)
        // TOOLBAR
        self.toolbar = MediaViewToolbar(parent: self, frame: toolbar_frame)
        self.view.addSubview(toolbar)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSection" {
            let nextVC = segue.destination as! SectionViewController
            nextVC.thisSection = self.selectedSection
            nextVC.parentMedia = thisMedia
        }
    }
    /// 画面再表示
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.toolbar.mainView.chapterTableView != nil {
            self.toolbar.mainView.chapterTableView.reloadData()
        }
    }
    
    /// Viewの見た目を更新
    func updateToolbarPosition() {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [], animations: {
            self.toolbar.frame.origin = CGPoint(x: 0, y: self.mediaView.frame.maxY)
        }, completion: nil)
    }
}
