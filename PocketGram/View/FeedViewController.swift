//
//  FeedViewController.swift
//  PocketGram
//
//  Created by Nathan Ireland on 5/18/23.
//

import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import UIKit

class FeedViewController: UIViewController {
    
    var currentUser: User?
    let db = Firestore.firestore()
    
    override func viewDidAppear(_ animated: Bool) {
        addListenerToAuth()
    }

   
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func onNewPostBtn(_ sender: Any) {
           self.performSegue(withIdentifier: "openCameraSegue", sender: nil)
       }
       
    
    
    @IBAction func unwind( _ seg: UIStoryboardSegue) {
    }
    
    
    /// Listener added to Auth to ...
    func addListenerToAuth(){
        Auth.auth().addStateDidChangeListener{(auth, user) in
            if user != nil {
                print("Updated user authed")
            }else{
                //
            }
        }
    }

}
