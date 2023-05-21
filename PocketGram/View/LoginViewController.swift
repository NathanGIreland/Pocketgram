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
        
        Auth.auth().addStateDidChangeListener{(auth, user) in
            if user != nil{
                self.isUserAuthenticated =  true
            }else{
                self.isUserAuthenticated =  false
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    @IBAction func loginAction(_ sender: Any) {
        try? Auth.auth().signOut()
        
        LSViewModel.Login(emailField.text!, passwordField.text!)
        preformSegue(loggedSignedSegue, isUserAuthenticated)
        
        
        
    }
    
    @IBAction func signUpAction(_ sender: Any) {
        LSViewModel.signUp(emailField.text!, passwordField.text!)
        preformSegue(loggedSignedSegue, isUserAuthenticated)
    }
    
    func preformSegue(_ Segue: String, _ isUserAuthenticated: Bool){
        if(isUserAuthenticated == true){
            self.performSegue(withIdentifier: Segue, sender: nil)
        }else{
            print("Segue cannot preformed | Segue identifier: \(Segue) IsUserAuthenticated: \(isUserAuthenticated)")
        }
    }

}



