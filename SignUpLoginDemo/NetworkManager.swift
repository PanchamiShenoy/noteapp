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

