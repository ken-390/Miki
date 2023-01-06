//
//  SectionViewController.swift
//  Miki
//
//  Created by 柴田健作 on 2022/11/18.
//

import UIKit

class SectionViewController: UIViewController {
    var detailView: SectionDetailView!
    var tableView: UITableView!
    var addWordBtn: UIButton!
    
    var thisSection: SectionItem = SectionItem()
    var parentMedia: Media = Media()
    var words: [Word] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        let naviBar: CGRect = self.navigationController!.navigationBar.frame
        let tabBar: CGRect = self.tabBarController!.tabBar.frame
        let detail_frame = CGRect(x: 0, y: naviBar.maxY, width: self.view.frame.width, height: 100)
        let table_frame = CGRect(x: 0, y: detail_frame.maxY+0.5, width: self.view.frame.width, height: self.view.frame.height-tabBar.height)
        let addWordBtn_frame = CGRect(x: self.view.frame.width-60, y: tabBar.origin.y-60, width: 40, height: 40)

        // DetailView
        self.detailView = SectionDetailView(parent: self, frame: detail_frame)
        self.view.addSubview(detailView)
        // TableView
        self.tableView = UITableView(frame: table_frame)
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        // BUTTON(ADD WORD)
        self.addWordBtn = UIButton(frame: addWordBtn_frame)
        addWordBtn.backgroundColor = .systemBlue
        addWordBtn.tintColor = .white
        addWordBtn.setImage(UIImage(systemName: "plus"), for: .normal)
        addWordBtn.layer.cornerRadius = 20
        addWordBtn.addTarget(self, action: #selector(addWordBtn_onTap(_:)), for: UIControl.Event.touchUpInside)
        self.view.addSubview(addWordBtn)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAddWord" {
            let nextVC = segue.destination as! EditViewController
            nextVC.source_media = self.parentMedia
            nextVC.source_section = self.thisSection
            nextVC.viewMode = .add
            nextVC.parentView = self
        }
    }
    public func reloadTable() {
        self.tableView.reloadData()
    }
    
    @objc func addWordBtn_onTap(_ sender: UIButton){
        self.performSegue(withIdentifier: "toAddWord", sender: self)
    }
}
extension SectionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.words = GetWordRecords().getWordsByParent(media_id: self.parentMedia.id, section_id: self.thisSection.id)
        return self.words.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = self.words[indexPath.row].title
        return cell
    }
}
extension SectionViewController: UITableViewDelegate {
    
}
