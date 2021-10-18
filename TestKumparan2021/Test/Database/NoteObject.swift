//
//  NoteObject.swift
//  TestKumparan2021
//
//  Created by nanda eka on 18/10/21.
//

import RealmSwift

class NoteObject: Object {
    @Persisted var title: String = ""
    @Persisted var content: String = ""
    
    convenience init(title: String, content: String) {
        self.init()
        self.title = title
        self.content = content
    }
}
