//
//  ListNoteViewController.swift
//  TestKumparan2021
//
//  Created by nanda eka on 18/10/21.
//

import UIKit
import RealmSwift

class ListNoteViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var addNoteBtn: UIButton!
    var model : Results<NoteObject>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        setupTableView()
        addNoteBtn.addTarget(self, action: #selector(addNote), for: .touchUpInside)
        addNoteBtn.layer.cornerRadius = 25
        addNoteBtn.clipsToBounds = true
    }

    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: "ListNoteTableViewCell", bundle: nil), forCellReuseIdentifier: "ListNoteTableViewCell")
        setupDatabase()
    }
    
    func setupDatabase() {
        let localRealm = try! Realm()
        self.model = localRealm.objects(NoteObject.self)
        tableView.reloadData()
    }
    
    //MARK: UIButtonAction
    
    @objc func addNote() {
        let noteEditorVC = NoteEditorViewController()
        noteEditorVC.isNew = true
        noteEditorVC.delegate = self
        self.navigationController?.pushViewController(noteEditorVC, animated: true)
    }
}

extension ListNoteViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let model =  self.model else { return }
        let noteEditorVC = NoteEditorViewController()
        noteEditorVC.index = indexPath.row
        noteEditorVC.detailModel = model[indexPath.row]
        noteEditorVC.delegate = self
        self.navigationController?.pushViewController(noteEditorVC, animated: true)
    }
}

extension ListNoteViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.model?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListNoteTableViewCell") as! ListNoteTableViewCell
        guard let model =  self.model else { return cell }
        cell.titleLbl.text = model[indexPath.row].title
        cell.contentLbl.text = model[indexPath.row].content
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

extension ListNoteViewController: NoteEditorDelegate {
    func succesSave() {
        self.tableView.reloadData()
    }
    
    func succesDelete(index: Int) {
        let localRealm = try! Realm()
        let tasks = localRealm.objects(NoteObject.self)
        let taskToDelete = tasks[index]
        try! localRealm.write {
            localRealm.delete(taskToDelete)
        }
        self.tableView.reloadData()
    }
}
