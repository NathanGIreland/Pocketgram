//
//  LoginSignupViewModel.swift
//  PocketGram
//
//  Created by Nathan Ireland on 5/20/23.
//

import Foundation
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

final class LoginSignupViewModel{
    
    var ref: DocumentReference? = nil
    let db = Firestore.firestore()
    
    func Login(_ email: String, _ password: String){
        Auth.auth().signIn(withEmail: email, password: password ){authResult, error in
            
            
            if error != nil {
                print("Login errors: \(String(describing: error?.localizedDescription))")
            }else{
                print("User successfully logged in")
            }

        }
       
    }
    
    func signUp(_ email: String, _ password: String){
        Auth.auth().createUser(withEmail: email, password: password) {authResult, error in
            
            if error != nil {
                print("Sign up errors: \(String(describing: error?.localizedDescription))")
            }else{
                print("User successfully Signed up")
                
                self.ref = self.db.collection("Users").addDocument(data: [
                    "First Name": "nathan",
                    "Last Name": "i",
                    "email": Auth.auth().currentUser?.email,
                    "username": "@1232",
                    "profile-picture": "https://",
                    "status": "💀",
                    "bio": "fun",
                    "uid": Auth.auth().currentUser?.uid,
                    
                ]) { err in
                    if let err = err {
                        print("Error adding document: \(err)")
                    }else{
                        print("Document added with ID: \(self.ref!.documentID)")
                    }
                }
            }

            
        }
       
    }

    
}
