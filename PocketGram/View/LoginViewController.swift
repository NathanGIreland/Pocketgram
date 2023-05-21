//
//  LoginViewController.swift
//  PocketGram
//
//  Created by Nathan Ireland on 5/18/23.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    private var LSViewModel = LoginSignupViewModel()

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    
    let loggedSignedSegue = "loginSegue"
    var isUserAuthenticated = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addListenerToAuth()
    }
    
    /*
    // MARK: - IBActions
    */
    
    /// Login action button
    /// - Parameter sender: Login Btn
    @IBAction func loginAction(_ sender: Any) {
        try? Auth.auth().signOut()
        
        LSViewModel.login(emailField.text!, passwordField.text!)
        preformSegue(loggedSignedSegue, isUserAuthenticated)
        
    }
    
    /// Sign up action button
    /// - Parameter sender: Sign Up Btn
    @IBAction func signUpAction(_ sender: Any) {
        LSViewModel.signUp(emailField.text!, passwordField.text!)
        preformSegue(loggedSignedSegue, isUserAuthenticated)
    }
    
    /*
    // MARK: - Helper functions
    */
    
    /// Segue to feed view once user is authenticated
    /// - Parameters:
    ///   - Segue: segue passed from caller
    ///   - isUserAuthenticated: boolean value passed from caller that determines whether a user is authenticated
    func preformSegue(_ Segue: String, _ isUserAuthenticated: Bool){
        if(isUserAuthenticated == true){
            self.performSegue(withIdentifier: Segue, sender: nil)
        }else{
            print("Segue cannot preformed | Segue identifier: \(Segue) IsUserAuthenticated: \(isUserAuthenticated)")
        }
    }
    
    /// Listener added to Auth to update isUserAuthenticated state
    func addListenerToAuth(){
        Auth.auth().addStateDidChangeListener{(auth, user) in
            if user != nil{
                self.isUserAuthenticated =  true
            }else{
                self.isUserAuthenticated =  false
            }
        }
    }

}



