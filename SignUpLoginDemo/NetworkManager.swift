//
//  NetworkManager.swift
//  SignUpLoginDemo
//
//  Created by Panchami Shenoy on 20/10/21.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import GoogleSignIn

struct NetworkManager {
    static let shared = NetworkManager()
    
    func login(withEmail email:String,password:String,completion:AuthDataResultCallback?){
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    
    func signup(withEmail email:String,password:String,completion:AuthDataResultCallback?){
        Auth.auth().createUser(withEmail: email, password: password, completion: completion)
    }
    
    func writeDocument(documentName: String, data: [String: Any]) {
        let db = Firestore.firestore()
        db.collection(documentName).addDocument(data: data)
    }
    
    func signout()  {
        
        do {
            try Auth.auth().signOut()
            
            
        }catch{
            
        }
    }
    func deleteNote(_ noteId:String) {
        let db = Firestore.firestore()
           db.collection("notes").document(noteId).delete { error in
               if let error = error {
                   print(error.localizedDescription)
               }
           }
       }
    func fetchNote(completion :@escaping([NoteItem])->Void) {
        let x = Auth.auth().currentUser?.uid
        let db = Firestore.firestore()
        var notes :[NoteItem] = []
        db.collection("notes").whereField("uid", isEqualTo: x).getDocuments { snapshot, error in
            
            for document in (snapshot?.documents)! {
                let data = document.data()
                let noteId = document.documentID
                let title = data["title"] as? String ?? ""
                let note = data["note"] as? String ?? ""
                let uid = data["uid"] as? String ?? ""
                let date = data["timestamp"] as? Date ?? Date()
                let noteItem = NoteItem(noteId:noteId,title: title, note: note,uid: uid,date: date)
                
                notes.append(noteItem)
            }
            completion(notes)
        }
    }
    func updateNote(_ note:NoteItem){
        let db = Firestore.firestore()
       // print(note.noteId)
        db.collection("notes").document(note.noteId).updateData(["title": note.title, "note": note.note,"timestamp":Date()])
    }
    
    func checkSignIn() ->Bool {
        
        if Auth.auth().currentUser?.uid != nil {
            return true
        }
        else{
            return false
        }
    }
    
    func checkGoogleSignIn()-> Bool {
        var status = false
        print("11111111111111111111111111111111111")
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            if error != nil || user == nil {
                // Show the app's signed-out state.
                status = false
            }
            else{
                print("222222222222222222222222222")
                status = true
            }
        }
        return status
    }
    func googleSignOut(){
        
        GIDSignIn.sharedInstance.signOut()
    }
}

