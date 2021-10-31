//
//  UpdateNoteViewController.swift
//  SignUpLoginDemo
//
//  Created by Panchami Shenoy on 28/10/21.
//

import UIKit

class UpdateNoteViewController: UIViewController {

    @IBOutlet weak var noteTextField: UITextView!
    @IBOutlet weak var titleTextField: UITextField!
    var note: NoteItem?
    var noteRealm :NotesItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noteTextField.text = note?.note
        titleTextField.text = note?.title
    }
    
    @IBAction func onUpdate(_ sender: Any) {
        note?.title = titleTextField.text!
        note?.note = noteTextField.text!
        NetworkManager.shared.updateNote(note!)
        //RealmManager.shared.updateNote(note?.title,note?.note)
        noteTextField.text = ""
        titleTextField.text = ""
    }
    
    @IBAction func onCanecl(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
