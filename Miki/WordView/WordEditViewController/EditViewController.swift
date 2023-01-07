//
//  EditViewController.swift
//  Miki
//
//  Created by 柴田健作 on 2022/09/25.
//

import UIKit

enum EditViewMode: CaseIterable {
    case add
    case edit
}

protocol EditViewControllerDelegate: AnyObject {
    func update()
}

class EditViewController: UIViewController {
    /*
     Property
     */
    // Main
    var word: Word = Word()
    var viewMode: EditViewMode = .add
    var parentView: SectionViewController? = nil
    var parentDelegate: EditViewControllerDelegate?
    // Property
    var source_media: Media? = nil
    var source_section: SectionItem? = nil
    
    // ツールバー
    @IBOutlet weak var toolBar: UIView!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    // メイン
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var titleView: TitleEditView? = nil
    var sourceView: WordSourceEditView? = nil
    var textView: TextEditView? = nil
    var eventView: EventEditView? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set Layout
        setToolBar()
        setMainView()
        self.view.bringSubviewToFront(mainView)
        self.view.bringSubviewToFront(toolBar)
    }
    
    @IBAction func saveButton_onTap(_ sender: Any) {
        // Check Input Value
        var errFlg: Bool = false
        if(titleView!.checkInput()){
            errFlg = true
        }
        if(textView!.checkInput()){
            errFlg = true
        }
        
        if(errFlg){
            let dialog = UIAlertController(title: "Error", message: "入力必須項目が未入力です.", preferredStyle: .alert)
            dialog.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(dialog, animated: true, completion: nil)
            return
        }
        
        // Show Alert
        switch self.viewMode {
        case .add:
            let res = CreateWordRecord.createWordRecord(word: setWord())
            if(res.result_cd!){
                let dialog = UIAlertController(title: "Complete", message: res.message, preferredStyle: .alert)
                dialog.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                    (action: UIAlertAction!) in
                    self.updateParent()
                    self.dismiss()
                }))
                self.present(dialog, animated: true, completion: nil)
            }
            else{
                let dialog = UIAlertController(title: "Error", message: res.message, preferredStyle: .alert)
                dialog.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(dialog, animated: true, completion: nil)
            }
            break
            
        case .edit:
            let method :UpdateWordRecord = UpdateWordRecord()
            let newWord: Word = setWord()
            let relations: [Relationship] = GetRelationRecords().getRelationRecordsByRelatedId(related_id: self.word.id, type_id: -1)
            if(newWord.type_id != self.word.type_id && relations.count > 0){
                let alert: UIAlertController = UIAlertController(title: "Caution", message: "Changing the type removes this relationship. do you want to change?", preferredStyle:  UIAlertController.Style.alert)
                let confirmAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
                    (action: UIAlertAction!) -> Void in
                    let _: Result = DeleteRelationRecord().deleteRelationRecord(relations: relations)
                    let res = method.updateWordRecord(before: self.word, after: newWord)
                    if(res.result_cd!){
                        let dialog = UIAlertController(title: "Complete", message: res.message, preferredStyle: .alert)
                        dialog.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                            (action: UIAlertAction!) in
                            self.updateParent()
                            self.dismiss()
                        }))
                        self.present(dialog, animated: true, completion: nil)
                    }
                    else{
                        let dialog = UIAlertController(title: "Error", message: res.message, preferredStyle: .alert)
                        dialog.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(dialog, animated: true, completion: nil)
                    }
                })
                let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler:{
                    (action: UIAlertAction!) -> Void in
                    return
                })
                alert.addAction(cancelAction)
                alert.addAction(confirmAction)
                present(alert, animated: true, completion: nil)
            }
            else{
                let res = method.updateWordRecord(before: word, after: newWord)
                if(res.result_cd!){
                    let dialog = UIAlertController(title: "Complete", message: res.message, preferredStyle: .alert)
                    dialog.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                        (action: UIAlertAction!) in
                        self.updateParent()
                        self.dismiss()
                    }))
                    self.present(dialog, animated: true, completion: nil)
                }
                else{
                    let dialog = UIAlertController(title: "Error", message: res.message, preferredStyle: .alert)
                    dialog.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(dialog, animated: true, completion: nil)
                }
            }
            break
        }
    }
    
    func setWord() -> Word{
        let newWord: Word = Word(id: self.word.id ?? "",
                                 type_id: 0,
                                 title: titleView!.titleTextField.text!,
                                 text: textView!.textArea.text!,
                                 mediaId: sourceView!.source_media == nil ? "" : sourceView!.source_media!.id,
                                 sectionId:  sourceView!.source_section == nil ? "" : sourceView!.source_section!.id)
        return newWord
    }
    
    func updateParent() {
        if (self.parentView != nil) {
            self.parentView!.reloadTable()
        }
    }
    func dismiss() {
        if((parentDelegate) != nil){
            parentDelegate?.update()
        }
        self.dismiss(animated: true, completion: nil)
    }

    func setToolBar(){
        let view_h: Double = 70
        let button_h: Double = 30
        let button_pr: Double = 10
        let saveButton_w: Double = 30
        toolBar.backgroundColor = .systemGray6
        toolBar.frame = CGRect(
            x: 0,
            y: 0,
            width: UIScreen.main.bounds.width,
            height: view_h)
        toolBar.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        toolBar.layer.shadowColor = UIColor.systemGray2.cgColor
        toolBar.layer.shadowOpacity = 0.3
        toolBar.layer.shadowRadius = 6
        
        topLabel.font = .systemFont(ofSize: 24.0)
        topLabel.text = "Word"
        topLabel.frame.size.width = topLabel.getFitWidth()
        topLabel.frame.size.height = topLabel.getFitHeight()
        
        saveButton.configuration?.title = ""
        saveButton.configuration?.image = UIImage(systemName: "checkmark")
        saveButton.frame = CGRect(x: toolBar.frame.maxX-(saveButton_w+button_pr),
                                   y: toolBar.frame.height*0.5-button_h*0.5,
                                   width: saveButton_w,
                                   height: button_h)
    }
    func setMainView(){
        // Remove SubView from MainView
        let subviews = mainView.subviews
        for subview in subviews {
            subview.removeFromSuperview()
        }
        
        let mainView_h: Double = setView_typeDefault()
        
        // Set MainView.frame
        mainView.frame = CGRect(x: 0,
                                  y: toolBar.frame.maxY,
                                  width: UIScreen.main.bounds.width,
                                height: mainView_h)
        scrollView.frame = self.view.frame
        scrollView.contentSize = CGSize(width: mainView.frame.size.width, height: mainView.frame.size.height)
    }
    
    // Type: Default
    func setView_typeDefault() -> Double{
        // Title
        self.titleView = TitleEditView(parent: self, word: self.word, upperView: nil)
        titleView!.setData()
        titleView!.setView()
        self.mainView.addSubview(titleView!)
        // Source
        self.sourceView = WordSourceEditView(parent: self, word: self.word, upperView: titleView)
        sourceView!.setData(media: source_media!, section: source_section!)
        sourceView!.setView()
        self.mainView.addSubview(sourceView!)
        // Text
        self.textView = TextEditView(parent: self, word: self.word, upperView: sourceView)
        textView!.setData()
        textView!.setView()
        self.mainView.addSubview(textView!)

        return textView!.frame.maxY+UIScreen.main.bounds.height*0.5
    }
}

extension EditViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // キーボードを閉じる
        textField.resignFirstResponder()
        return true
    }
}
