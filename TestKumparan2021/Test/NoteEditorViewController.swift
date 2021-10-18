//
//  NoteEditorViewController.swift
//  TestKumparan2021
//
//  Created by nanda eka on 18/10/21.
//

import UIKit
import RealmSwift

protocol NoteEditorDelegate {
    func succesSave()
    func succesDelete(index: Int)
}

class NoteEditorViewController: UIViewController {

    @IBOutlet var titleTF: UITextField!
    @IBOutlet var contentTV: UITextView!
    @IBOutlet var boldBar: UIBarButtonItem!
    @IBOutlet var italicBar: UIBarButtonItem!
    @IBOutlet var underscoreBar: UIBarButtonItem!
    @IBOutlet var orderedBar: UIBarButtonItem!
    @IBOutlet var unorderedBar: UIBarButtonItem!
    @IBOutlet var saveBtn: UIButton!
    @IBOutlet var deleteBtn: UIButton!
    var isNew = false
    var index = 0
    var detailModel : NoteObject?
    var delegate: NoteEditorDelegate?
    var stopCount = 0
    var exisitingCount = 0
    var isBoldActive = false
    var isItalicActive = false
    var isUnderscoreActive = false
    var isOrderedActive = false
    var isUnorderedActive = false
    var isRegular = true
    var attributeString: NSAttributedString = NSAttributedString()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupData()
    }

    func setupView() {
        setupToolBar()
        contentTV.delegate = self
        contentTV.text = "Placeholder"
        contentTV.textColor = UIColor.lightGray.withAlphaComponent(0.7)
        saveBtn.addTarget(self, action: #selector(save), for: .touchUpInside)
        deleteBtn.addTarget(self, action: #selector(deleted), for: .touchUpInside)
    }
    
    func setupToolBar() {
        boldBar.target = self
        boldBar.action = #selector(boldBarCliked(sender:))
        italicBar.target = self
        italicBar.action = #selector(italicBarCliked(sender:))
        underscoreBar.target = self
        underscoreBar.action = #selector(underscoreBarCliked(sender:))
        orderedBar.target = self
        orderedBar.action = #selector(orderedBarCliked(sender:))
        unorderedBar.target = self
        unorderedBar.action = #selector(unorderedBarCliked(sender:))
    }
    
    func setupData() {
        if detailModel != nil {
            titleTF.text = detailModel?.title ?? ""
            contentTV.attributedText = NSAttributedString.init(string: detailModel?.content ?? "")
        }
    }

    func alertDelete() {
        let alert = UIAlertController(title: "Are you sure?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "NO", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { action in
            switch action.style {
                case .default:
                    self.navigationController?.popViewController(animated: true)
                    self.delegate?.succesDelete(index: self.index)
                case .cancel:
                print("cancel")
                case .destructive:
                print("destructive")
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    //MARK: UIButtonAction
    
    @objc func save() {
        let localRealm = try! Realm()
        if isNew && index == 0 {
            let task = NoteObject(title: titleTF.text ?? "", content: contentTV.attributedText.string )
            try! localRealm.write {
                localRealm.add(task)
            }
        } else {
            let tasks = localRealm.objects(NoteObject.self)
            let taskToUpdate = tasks[index]
            try! localRealm.write {
                taskToUpdate.title = titleTF.text ?? ""
                taskToUpdate.content = contentTV.text ?? ""
            }
        }
        navigationController?.popViewController(animated: true)
        delegate?.succesSave()
    }
    
    @objc func deleted() {
        alertDelete()
    }
    
    @objc func regularChecking() {
        if isBoldActive == false && isItalicActive == false && isUnderscoreActive == false {
            isRegular = true
        } else {
            isRegular = false
        }
    }

    
    //MARK: UIBarButtonAction
    
    @objc func boldBarCliked(sender: UIBarButtonItem) {
        if isBoldActive {
            isBoldActive = false
            boldBar.tintColor = .systemBlue
        } else {
            isBoldActive = true
            isItalicActive = false
            isUnderscoreActive = false
            boldBar.tintColor = .lightGray
            italicBar.tintColor = .systemBlue
            underscoreBar.tintColor = .systemBlue
        }
        regularChecking()
        attributeString = contentTV.attributedText
        stopCount = attributeString.string.count
    }
    
    @objc func italicBarCliked(sender: UIBarButtonItem) {
        if isItalicActive {
            isItalicActive = false
            italicBar.tintColor = .systemBlue
        } else {
            isItalicActive = true
            isBoldActive = false
            isUnderscoreActive = false
            boldBar.tintColor = .systemBlue
            italicBar.tintColor = .lightGray
            underscoreBar.tintColor = .systemBlue
        }
        regularChecking()
    }
    
    @objc func underscoreBarCliked(sender: UIBarButtonItem) {
        if isUnderscoreActive {
            isUnderscoreActive = false
            underscoreBar.tintColor = .systemBlue
        } else {
            isUnderscoreActive = true
            isItalicActive = false
            isBoldActive = false
            boldBar.tintColor = .systemBlue
            italicBar.tintColor = .systemBlue
            underscoreBar.tintColor = .lightGray
        }
        regularChecking()
    }
    
    @objc func orderedBarCliked(sender: UIBarButtonItem) {
        if isOrderedActive {
            isOrderedActive = false
            orderedBar.tintColor = .systemBlue
        } else {
            isOrderedActive = true
            isUnorderedActive = false
            orderedBar.tintColor = .lightGray
            unorderedBar.tintColor = .systemBlue
            
        }
    }
    
    @objc func unorderedBarCliked(sender: UIBarButtonItem) {
        if isUnorderedActive {
            isUnorderedActive = false
            unorderedBar.tintColor = .systemBlue
        } else {
            isUnorderedActive = true
            isOrderedActive = false
            orderedBar.tintColor = .systemBlue
            unorderedBar.tintColor = .lightGray
        }
    }
}

extension NoteEditorViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray.withAlphaComponent(0.7) {
            textView.text = nil
            textView.textColor = UIColor.black
        }
        print("textViewDidBeginEditing")
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Placeholder"
            textView.textColor = UIColor.lightGray.withAlphaComponent(0.7)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            
        if isRegular {
            textView.font = UIFont.init(name: "TimesNewRomanPS", size: 14.0)
        } else {
            if isBoldActive {
                textView.font = UIFont.init(name: "TimesNewRomanPS-BoldMT", size: 14.0)!
            } else if isItalicActive {
                textView.font = UIFont.init(name: "TimesNewRomanPS-ItalicMT", size: 14.0)
            } else if isUnderscoreActive {
                textView.font = UIFont.init(name: "TimesNewRomanPS-BoldItalicMT", size: 14.0)
                let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
                let underlineAttributedString = NSAttributedString(string: textView.text, attributes: underlineAttribute)
                textView.attributedText = underlineAttributedString
            }
        }
        
        if text == "\n" && isOrderedActive {
            let string = textView.attributedText.string + "\n \u{2022} "
            textView.attributedText = NSAttributedString.init(string: string)
            return false
        }
        
        if text == "\n" && isUnorderedActive {
            let string = textView.attributedText.string + "\n - "
            textView.attributedText = NSAttributedString.init(string: string)
            return false
        }
        
        return true
    }
}
