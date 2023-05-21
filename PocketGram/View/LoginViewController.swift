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
        
        //addListenerToAuth()
    }
    
    /*
    // MARK: - IBActions
    */
    
    /// Login action button
    /// - Parameter sender: Login Btn
    @IBAction func loginAction(_ sender: Any) {
        //try? Auth.auth().signOut()
        
        LSViewModel.login(emailField.text!, passwordField.text!) {Success in
            if Success{
                print("Log in succesful")
                self.performSegue(withIdentifier: self.loggedSignedSegue, sender: nil)
            }else{
                print("Sign up unsuccesful")
            }
        }
        
    }
    
    /// Sign up action button
    /// - Parameter sender: Sign Up Btn
    @IBAction func signUpAction(_ sender: Any) {

        
        LSViewModel.signUp(emailField.text!, passwordField.text!) {Success in
            if Success{
                print("Sign up succesful")
                self.performSegue(withIdentifier: self.loggedSignedSegue, sender: nil)
            }else{
                print("Sign up unsuccesful")
            }
        }
        
        
        
    }
    
    /*
    // MARK: - Helper functions
    */
    
    

}



