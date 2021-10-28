//
//  AddNoteViewController.swift
//  SignUpLoginDemo
//
//  Created by Panchami Shenoy on 26/10/21.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class AddNoteViewController: UIViewController {
    let x = Auth.auth().currentUser?.uid
    var array1 : [String] = []
    @IBOutlet weak var noteTitle: UITextField!
    
    @IBOutlet weak var noteContent: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\n\n",x)
        //printNote()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func onCancel(_ sender: Any) {
        dismiss(animated: true, completion: .none)
    }
    
    @IBAction func onAdd(_ sender: Any) {
        let noteTitle :String = noteTitle.text!
        let noteContent :String = noteContent.text!
        let newNote: [String: Any] = ["title": noteTitle,"note":noteContent,"uid": x,"timestamp":getDate()]
        let db = Firestore.firestore()
        db.collection("notes").addDocument(data: newNote)
        self.noteTitle.text = ""
        self.noteContent.text = ""
       
    }
    
    
    func getDate() ->String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        return dateFormatter.string(from:Date())
    }
    
    
            }

