//
//  RealmManager.swift
//  SignUpLoginDemo
//
//  Created by Panchami Shenoy on 29/10/21.
//

import Foundation
import RealmSwift
struct RealmManager {
    static var shared = RealmManager()
    let realmInstance = try! Realm()
    var notesRealm : [NotesItem] = []
    func addNote(note:NotesItem){
        /*let note1 = NotesItem()
        note1.note = noteContent
        note1.title = noteTitle
        note1.uid = uid!
        note1.date = Date()*/
      
        try! realmInstance.write({
            realmInstance.add(note)
        })
    }
   mutating func deleteNote(index:Int){
        try! realmInstance.write({
            realmInstance.delete(notesRealm[index])
        })
        notesRealm.remove(at:index)
       
    }
    
    func updateNote(_ title:String,_ noteContent:String){
        let realmInstance = try! Realm()
       /* let predict = NSPredicate.init(format: "%K == %@", title,title)
        let predict2 = NSPredicate.init(format: "%K == %@", note,note)*/
        
    }
  mutating  func fetchNotes(completion :@escaping([NotesItem])->Void) {
      var notesArray :[NotesItem] = []
        let notes = realmInstance.objects(NotesItem.self)
        for note in notes
        {
            notesRealm.append(note)
            notesArray.append(note)
            
        }
      completion(notesArray)
      print(notes)
      
    }
}
