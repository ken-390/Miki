//
//  SearchMediaViewController.swift
//  Miki
//
//  Created by 柴田健作 on 2022/11/08.
//

import UIKit

class SearchMediaViewController: UIViewController {
    var mediaView: MediaListView!
    var searchBar: UISearchBar!
    var sortOrderBtn: UIButton!
    var tableView: UITableView!
    var addMediaBtn: UIButton!
    
    var sortMode: SortMode = .byTitle
    
    var records: [Media] = []
    var selectedRecord: Media = Media()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mediaView = MediaListView(parent: self)
        self.view.addSubview(mediaView)
        
        let searchFrame = CGRect(x: 0, y: mediaView.frame.maxY, width: self.view.frame.width-42, height: 42)
        let sortOrderFrame = CGRect(x: searchFrame.maxX+4, y: mediaView.frame.maxY+6, width: 30, height: 30)
        let tableFrame = CGRect(x: 0, y: searchFrame.maxY,width: self.view.frame.width,
                                height: self.view.frame.height-(searchFrame.maxY+self.tabBarController!.tabBar.frame.height))
        let addMediaFrame = CGRect(x: tableFrame.maxX-60, y: tableFrame.maxY-60, width: 40, height: 40)
        // NAVIGATION BAR
        self.navigationController?.navigationBar.layer.shadowRadius = 3.0
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.black.cgColor
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.navigationController?.navigationBar.layer.shadowOpacity = 0.2
        // SEARCHBAR
        self.searchBar = UISearchBar(frame: searchFrame)
        searchBar.delegate = self
        searchBar.placeholder = "Search"
        self.view.addSubview(searchBar)
        // BUTTON (SORT_ORDER)
        self.sortOrderBtn = UIButton(frame: sortOrderFrame)
        sortOrderBtn.setImage(UIImage(systemName: "slider.horizontal.3"), for: .normal)
        sortOrderBtn.tintColor = .white
        sortOrderBtn.backgroundColor = .systemBlue
        sortOrderBtn.layer.cornerRadius = 5
        sortOrderBtn.menu = UIMenu(title: "並べ替え", children: self.getActions())
        sortOrderBtn.showsMenuAsPrimaryAction = true
        self.view.addSubview(sortOrderBtn)
        // TABLE
        self.tableView = UITableView(frame: tableFrame)
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        // BUTTON (ADD_MEDIA)
        self.addMediaBtn = UIButton(frame: addMediaFrame)
        addMediaBtn.setImage(UIImage(systemName: "plus"), for: .normal)
        addMediaBtn.tintColor = .white
        addMediaBtn.backgroundColor = .systemBlue
        addMediaBtn.layer.cornerRadius = 20
        addMediaBtn.addTarget(self, action: #selector(addMediaBtn_onTap(_:)), for: UIControl.Event.touchUpInside)
        self.view.addSubview(addMediaBtn)
        // TAB BAR
        self.tabBarController!.tabBar.layer.shadowRadius = 3.0
        self.tabBarController!.tabBar.layer.shadowColor = UIColor.black.cgColor
        self.tabBarController!.tabBar.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.tabBarController!.tabBar.layer.shadowOpacity = 0.4
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMedia" {
            let nextVC = segue.destination as! MediaViewController
            nextVC.thisMedia = self.selectedRecord
        }
    }
    
    @objc func addMediaBtn_onTap(_ sender: UIButton){
        let type = MediaType.allCases[self.mediaView.pageNum]
        
        var alertTextField: UITextField?
        let popup = UIAlertController(title: "新規作成",
            message: "作成する \"\(type.title)\" のタイトルを入力してください",
            preferredStyle: UIAlertController.Style.alert)
        popup.addTextField(
            configurationHandler: {(textField: UITextField!) in
                alertTextField = textField
                textField.placeholder = "タイトル"
        })
        popup.addAction(
            UIAlertAction(
                title: "Cancel",
                style: UIAlertAction.Style.cancel,
                handler: nil))
        popup.addAction(
            UIAlertAction(
                title: "OK",
                style: UIAlertAction.Style.default) { _ in
                if let text = alertTextField?.text {
                    let media = Media()
                    media.title = text
                    media.typeIdx = self.mediaView.pageNum
                    let res: Bool = CreateMediaRecord().createMediaRecord(media: media)
                    if(res){
                        let message = UIAlertController(title: "Complete",
                            message: "\"\(text)\" を追加しました",preferredStyle: UIAlertController.Style.alert)
                        message.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                        self.present(message, animated: true, completion: nil)
                        
                        self.tableView.reloadData()
                    }
                }
            }
        )
        self.present(popup, animated: true, completion: nil)
    }
    
    func getActions() -> [UIAction] {
        var actions: [UIAction] = []
        for mode in SortMode.allCases {
            switch mode {
            case .byTitle:
                actions.append(UIAction(title: "タイトル", image: UIImage(systemName: "textformat.abc")) { (action) in
                    self.sortMode = .byTitle
                    self.tableView.reloadData()
                })
                break
            case .byAuthorName:
                actions.append(UIAction(title: "作者名", image: UIImage(systemName: "person.3.sequence")) { (action) in
                    self.sortMode = .byAuthorName
                    self.tableView.reloadData()
                })
                break
            }
        }
        return actions
    }
}

// SEARCHBAR
extension SearchMediaViewController: UISearchBarDelegate{
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
    }
}
// TABLE
extension SearchMediaViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.selectedRecord = self.records[indexPath.row]
        self.performSegue(withIdentifier: "showMedia", sender: self)
    }
}
extension SearchMediaViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.records = GetMediaRecord().getMediaRecordByTypeIdx(typeIdx: self.mediaView.pageNum, orderBy: self.sortMode)
        return self.records.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = self.records[indexPath.row].title
        return cell
    }
}

