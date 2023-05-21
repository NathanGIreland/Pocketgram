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
    
    private var AService = AuthService()
    
    /// Calls AuthService to login users
    /// - Parameters:
    ///   - email: user email
    ///   - password: user password
    func login(_ email: String, _ password: String, completion: @escaping (Bool) -> Void) {
        AService.login (email, password) { Success in
            if Success{
                completion(true)
    
            }else{
                completion(false)
            }
        }
    }
    
    /// Calls AuthService to sign up new users
    /// - Parameters:
    ///   - email: user email
    ///   - password: user password
    func signUp(_ email: String, _ password: String, completion: @escaping (Bool) -> Void) {
        
        AService.signUp(email, password) { Success in
            if Success{
                completion(true)
                
            }else{
                completion(false)
            }
        }
        
        
        
       
        
    }
    


    
}
