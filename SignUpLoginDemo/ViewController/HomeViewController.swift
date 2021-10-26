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
class HomeViewController: UIViewController {
    var delegate :MenuDelegate?
   
    @IBOutlet weak var label: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
       if AccessToken.current?.tokenString == nil{
            print("\n\n@@@@@@@@@@@@@@@@@@@@@@@@@@")
            GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
                if user == nil {
                    print("\n\n$$$$$$$$$$$$$$$$$$$$$$")
                  // Show the app's signed-out state.
                    let status = NetworkManager.shared.checkSignIn()
                    if(status == false){
                        print("\n\n!!!!!!!!!!!!!!!!!!!!!!!!!")
                        self.transitionToLogin()
                    }
                }
              }
            }
        configureNavigation()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image :UIImage(systemName: "square.and.pencil") ,style:.plain,target:self,action:#selector(addNote))
    }
    override func viewDidAppear(_ animated: Bool) {
       
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
    }
    @objc func handleMenu() {
        print("cclick on menu")
        delegate?.menuHandler()
        print(delegate)
    }
    @objc func addNote() {
        print("add button clicked")
    }
}

