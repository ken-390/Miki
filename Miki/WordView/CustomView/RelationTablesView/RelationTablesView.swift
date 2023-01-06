//
//  RelationTablesView.swift
//  Miki
//
//  Created by 柴田健作 on 2022/10/16.
//

import UIKit

class RelationTablesView: UIView {
    var parent: UIViewController?
    var word: Word = Word()
    
    var items: [String] = []
    var relations: [[Relationship]] = []
    var selectedSegment: Int = 0
    
    var segmentControl: UISegmentedControl?
    var tableToolBar: TableToolBar?
    var tableView: UITableView?
    
    init(parent: UIViewController!, word: Word, frame: CGRect){
        let seg_pt: Double = 5
        super.init(frame: frame)
        // Set Variable
        self.parent = parent
        self.word = word
        self.items = self.setItems(typeId: self.word.type_id)
        // Set UI
        segmentControl = UISegmentedControl(items: self.items)
        segmentControl!.frame = CGRect(x: 0, y: seg_pt, width: UIScreen.main.bounds.width, height: 38)
        segmentControl!.addTarget(self, action: #selector(self.segmentChanged(_:)), for: .valueChanged)
        segmentControl!.selectedSegmentIndex = 0;
        self.addSubview(segmentControl!)
        tableToolBar = TableToolBar(parent: self, frame: CGRect(x: 0, y: segmentControl!.frame.maxY, width: UIScreen.main.bounds.width, height: 40))
        self.addSubview(tableToolBar!)
        tableView = UITableView()
        tableView!.frame = CGRect(x: 0, y: tableToolBar!.frame.maxY,
                                  width: UIScreen.main.bounds.width,
                                  height: self.frame.height-tableToolBar!.frame.maxY)
        tableView!.delegate = self
        tableView!.dataSource = self
        tableView!.rowHeight = 30
        self.addSubview(tableView!)
        
        self.bringSubviewToFront(tableView!)
        self.bringSubviewToFront(tableToolBar!)
        self.bringSubviewToFront(segmentControl!)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc func segmentChanged(_ sender: UISegmentedControl) {
        self.selectedSegment = segmentControl!.selectedSegmentIndex
        self.tableView?.reloadData()
        var typeId: Int = -1
        switch(items[self.selectedSegment]){
        case "Person":
            typeId = 1
            break
        case "Event":
            typeId = 3
            break
        default:
            break
        }
        self.tableToolBar?.typeId = typeId
    }
    func reloadView(){
        let idx: Int = segmentControl!.selectedSegmentIndex
        let seg_pt: Double = 5
        self.word = GetWordRecords().getWordRecordById(word: self.word)
        self.items = self.setItems(typeId: self.word.type_id)
        segmentControl!.removeFromSuperview()
        segmentControl = UISegmentedControl(items: self.items)
        segmentControl!.backgroundColor = .red
        segmentControl!.frame = CGRect(x: 0, y: seg_pt, width: UIScreen.main.bounds.width, height: 38)
        segmentControl!.addTarget(self, action: #selector(self.segmentChanged(_:)), for: .valueChanged)
        segmentControl!.selectedSegmentIndex = idx;
        self.addSubview(segmentControl!)
        self.tableView?.reloadData()
    }
    
    func setRelations(){
        self.relations = []
        self.items.forEach{ item in
            switch(item){
            case "Person":
                let relation = GetRelationRecords().getRelationRecordsBySourceId(source_id: word.id, type_id: 1)
                self.relations.append(relation)
                break
            case "Event":
                let relation = GetRelationRecords().getRelationRecordsBySourceId(source_id: word.id, type_id: 3)
                self.tableToolBar!.typeId = 3
                self.relations.append(relation)
                break
            default:
                break
            }
        }
    }
    func setItems(typeId: Int) -> [String]{
        switch(typeId){
        case 1:
            return ["Event"]
        default:
            return []
        }
        
    }
}

extension RelationTablesView: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.setRelations()
        if(self.relations.count <= 0){
            return 0
        }
        let relation = self.relations[self.selectedSegment]
        self.tableToolBar!.delButtonToDisable()
        return relation.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let related: Word = self.relations[self.selectedSegment][indexPath.row].related!
        
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
        cell.textLabel?.text = related.title
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableToolBar!.delButtonToActivate()
    }
}
