//
//  HomeViewController.swift
//  SignUpLoginDemo
//
//  Created by Panchami Shenoy on 18/10/21.
//

import UIKit
import FirebaseAuth
import GoogleSignIn
import FBSDKLoginKit
import FirebaseFirestore
class HomeViewController: UIViewController {
    var delegate :MenuDelegate?
   
    
    // var arr2 : [String] = []
    //var arr1 : [String] = []
    var notes: [NoteItem] = []
    @IBOutlet weak var NoteCollectionView: UICollectionView!
    @IBOutlet weak var label: UILabel!
    let x = Auth.auth().currentUser?.uid
    override func viewDidLoad() {
        super.viewDidLoad()
       if AccessToken.current?.tokenString == nil{
         
            GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
                if user == nil {
                   let status = NetworkManager.shared.checkSignIn()
                    if(status == false){
                        self.transitionToLogin()
                    }
                }
              }
            }
       
        configureNavigation()
     configureCollectionView()
    }
    override func viewDidAppear(_ animated: Bool) {
        fetchNote()
        configureCollectionView()
    }
    
    func configureCollectionView() {
        //let itemSize = UIScreen.main.bounds.width/2 - 12
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        //layout.itemSize = CGSize(width: itemSize, height: itemSize)
        layout.minimumLineSpacing = 4
        layout.minimumInteritemSpacing = 4
                
        NoteCollectionView.collectionViewLayout = layout
        NoteCollectionView.backgroundColor = .clear

        NoteCollectionView.delegate = self
        NoteCollectionView.dataSource = self
    }
    
    @IBAction func onLogOut(_ sender: Any) {
        
        do {
           NetworkManager.shared.signout()
            NetworkManager.shared.googleSignOut()
            LoginManager.init().logOut()
            transitionToLogin()
            } catch {
                  showAlert(title: "Error", message: "error in signing out")
                return
            }
    }
    
    func transitionToLogin() {
        let loginViewController = storyboard?.instantiateViewController(withIdentifier: "SigninVC")
        
        view.window?.rootViewController = loginViewController
        view.window?.makeKeyAndVisible()
    }
    
    func configureNavigation() {
        self.navigationItem.title = "Main Controller"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image:UIImage(systemName: "list.dash"), style: .plain, target: self, action: #selector(handleMenu))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image :UIImage(systemName: "square.and.pencil") ,style:.plain,target:self,action:#selector(addNote))
    }
    
    @objc func handleMenu() {
      
        delegate?.menuHandler()
       
    }
    
    @objc func addNote() {
       
        let addNoteController = storyboard?.instantiateViewController(withIdentifier: "AddNoteViewController") as! AddNoteViewController
        addNoteController.modalPresentationStyle = .fullScreen
        present(addNoteController,animated: true,completion: nil)
    }
  
    func fetchNote() {
        NetworkManager.shared.fetchNote { notes in
            self.notes = notes
            DispatchQueue.main.async {
                self.NoteCollectionView.reloadData()
            }
        }
    }
    @objc func onDeleteNote(_ sender: UIButton) {
        let deleteNoteId = notes[sender.tag].noteId
           NetworkManager.shared.deleteNote(deleteNoteId)
           notes.remove(at: sender.tag)
           NoteCollectionView.reloadData()
       }
        
}
extension HomeViewController :UICollectionViewDelegate,UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return notes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "noteCell", for: indexPath) as! NoteCell
        //cell.backgroundColor =  UIColor.yellow 
        //cell.textLabel = "note"
        cell.cellTitle.text = notes[indexPath.row].title
        cell.cellContent.text = notes[indexPath.row].note
        cell.cellContent.numberOfLines = 5
        cell.cellContent.lineBreakMode = NSLineBreakMode.byWordWrapping
        cell.deleteButton.tag = indexPath.row
        cell.deleteButton.addTarget(self, action: #selector(onDeleteNote), for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
           let UpdateNoteViewController = storyboard!.instantiateViewController(withIdentifier: "UpdateNoteViewController") as! UpdateNoteViewController
        UpdateNoteViewController.note = notes[indexPath.row]
        UpdateNoteViewController.modalPresentationStyle = .fullScreen
        present(UpdateNoteViewController, animated: true, completion: nil)
       }
}

