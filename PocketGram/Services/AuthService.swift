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
    let fireSService = FirestoreService()
    
    /*
    // MARK: - Authentication functions
    */
    
    /// Login and Authenticate users
    /// - Parameters:
    ///   - email: user email
    ///   - password: user password
    func login(_ email: String, _ password: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password ){authResult, error in
            if let error = error {
                print("Login errors: \(String(describing: error.localizedDescription))")
                completion(false) // Call the completion handler with false on error
            } else if authResult?.user.email != nil {
                print("User successfully logged in")
                completion(true) // Call the completion handler with true on success
            } else {
                print("Unexpected error occurred")
                completion(false) // Call the completion handler with false on unexpected error
            }

        }
    }
    
    
    /// Signs up,  Authenticate, and create user document in user collection
    /// - Parameters:
    ///   - email: user email
    ///   - password: user password
    ///   - completion: returns success if user is successfully Authenticated. Returns false if unsuccesssful auth or unknown error
    func signUp(_ email: String, _ password: String, completion: @escaping (Bool) -> Void) {
          Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
              if let error = error {
                  print("Sign up errors: \(error.localizedDescription)")
                  completion(false)
              } else if authResult?.user.email != nil {
                  print("successfully signed up")
                  self.fireSService.createNewUser(userModel(firstName: "", lastName: "", email: email, username: "", profilePicture: "", status: "", bio: "", uid: (authResult?.user.uid)!))
                  
                  completion(true)
                  
              } else {
                  print("Unexpected error occurred")
                  completion(false)
              }
          }
      }
            
    

    
    
    
    
}
