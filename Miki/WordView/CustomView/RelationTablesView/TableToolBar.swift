//
//  UITableToolBar.swift
//  Miki
//
//  Created by 柴田健作 on 2022/10/17.
//

import UIKit

class TableToolBar: UIView {
    var parent: RelationTablesView?
    var topParent: UIViewController?
    var word: Word = Word()
    var typeId: Int = -1
    
    // ToolBar
    let addButton: UIButton = UIButton()
    let deleteButton: UIButton = UIButton()
    
    init(parent: RelationTablesView!, frame: CGRect){
        super.init(frame: frame)
        // Set Variable
        self.parent = parent
        self.topParent = parent!.parent
        self.word = parent!.word
        // Set UI
        let button_h: Double = 20
        let add_w: Double = 60
        let del_w: Double = 90
        self.backgroundColor = .systemGray6
        addButton.setTitle("Add", for: .normal)
        addButton.backgroundColor = .systemBlue
        addButton.titleLabel?.font =  UIFont.systemFont(ofSize: 17)
        addButton.frame = CGRect(x: 10,
                                 y: self.frame.height*0.5-button_h*0.5,
                                 width: add_w, height: button_h)
        addButton.addTarget(self,action: #selector(addButtonTapped(sender:)),for: .touchUpInside)
        setViewShadow(targetView: addButton)
        setViewCorner(targetView: addButton)
        self.addSubview(addButton)
        deleteButton.setTitle("Delete", for: .normal)
        deleteButton.titleLabel?.font =  UIFont.systemFont(ofSize: 17)
        deleteButton.frame = CGRect(x: addButton.frame.maxX+10.0,
                                    y: self.frame.height*0.5-button_h*0.5,
                                    width: del_w, height: button_h)
        deleteButton.addTarget(self,action: #selector(delButtonTapped(sender:)),for: .touchUpInside)
        setViewShadow(targetView: deleteButton)
        setViewCorner(targetView: deleteButton)
        self.addSubview(deleteButton)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setViewShadow(targetView: UIView){
        targetView.layer.shadowOffset = CGSize(width: 0.0, height: 0.8)
        targetView.layer.shadowColor = UIColor.black.cgColor
        targetView.layer.shadowOpacity = 0.2
        targetView.layer.shadowRadius = 1
    }
    func setViewCorner(targetView: UIView){
        targetView.layer.cornerRadius = 5
    }
    func delButtonToActivate(){
        self.deleteButton.isEnabled = true
        deleteButton.backgroundColor = .systemBlue
    }
    func delButtonToDisable(){
        self.deleteButton.isEnabled = false
        deleteButton.backgroundColor = .systemGray4
    }
    
    @objc func addButtonTapped(sender : Any){
        let subView: UIView = AddEventRelView(parent: self, typeId: self.typeId)
        self.topParent!.view.addSubview(subView)
    }
    @objc func delButtonTapped(sender : Any){
        let selectedIndex: IndexPath? = parent!.tableView?.indexPathForSelectedRow
        let target: Relationship = self.parent!.relations[parent!.selectedSegment][selectedIndex!.row]
        let _: Result = DeleteRelationRecord().deleteRelationRecord(relations: [target])
        self.parent!.tableView?.reloadData()
    }
}

