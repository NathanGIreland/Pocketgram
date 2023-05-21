//
//  AuthService.swift
//  PocketGram
//
//  Created by Nathan Ireland on 5/21/23.
//

import Foundation
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

final class AuthService{
    
    var ref: DocumentReference? = nil
    let db = Firestore.firestore()
    
    /// Login and Authenticate users
    /// - Parameters:
    ///   - email: user email
    ///   - password: user password
    func login(_ email: String, _ password: String){
        Auth.auth().signIn(withEmail: email, password: password ){authResult, error in
            
            if error != nil {
                print("Login errors: \(String(describing: error?.localizedDescription))")
            }else{
                print("User successfully logged in")
            }

        }
    }
    
    /// Signs up,  Authenticate, and create user document in user collection
    /// - Parameters:
    ///   - email: user email
    ///   - password: user password
    func signUp(_ email: String, _ password: String){
        Auth.auth().createUser(withEmail: email, password: password) {authResult, error in
            
            if error != nil {
                print("Sign up errors: \(String(describing: error?.localizedDescription))")
            }else{
                print("User successfully Signed up")
                
                let newUser = userModel(firstName: "", lastName: "", email: email, username: "", profilePicture: "", status: "", bio: "", uid: authResult?.user.uid ?? "0")
                
                self.createNewUser(newUser)
        
            }

            
        }
    }
    
    /*
    // MARK: - Helper functions
    */
    
    /// Creates a new user in user collection
    /// - Parameter user: userModel
    func createNewUser(_ user: userModel){
        self.ref = self.db.collection("Users").addDocument(data: [
            "first-name": user.firstName,
            "last-name": user.lastName,
            "email": user.email,
            "username": user.username,
            "profile-picture": user.profilePicture,
            "status": user.status,
            "bio": user.bio,
            "uid": user.uid,
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            }else{
                print("Document added with ID: \(self.ref!.documentID)")
            }
        }
    }
    
    
}
