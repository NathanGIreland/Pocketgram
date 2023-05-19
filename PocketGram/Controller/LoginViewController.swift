//
//  LoginViewController.swift
//  PocketGram
//
//  Created by Nathan Ireland on 5/18/23.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginAction(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailField.text!, password: passwordField.text! ){authResult, error in
            
            if authResult?.user != nil {
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }else{
                print("Login errors: \(String(describing: error?.localizedDescription))")
            }
        }
    }
    
    @IBAction func signUpAction(_ sender: Any) {
        Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!) {authResult, error in
            
            if authResult?.user != nil {
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }else{
                print("Sign up errors: \(String(describing: error?.localizedDescription))")
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

}



