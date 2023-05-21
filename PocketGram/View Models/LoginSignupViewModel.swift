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
    func login(_ email: String, _ password: String){
        AService.login(email, password)
    }
    
    /// Calls AuthService to sign up new users
    /// - Parameters:
    ///   - email: user email
    ///   - password: user password
    func signUp(_ email: String, _ password: String){
        AService.signUp(email, password)
    }
    


    
}
