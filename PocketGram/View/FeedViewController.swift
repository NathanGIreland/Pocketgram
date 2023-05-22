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

    @IBAction func onNewPostBtn(_ sender: Any) {
        self.performSegue(withIdentifier: "openCameraSegue", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func unwind( _ seg: UIStoryboardSegue) {
    }
    
    
    
    /// Listener added to Auth to ...
    func addListenerToAuth(){
        Auth.auth().addStateDidChangeListener{(auth, user) in
            if user != nil {
                //
                print("loggedin from feed: \(Auth.auth().currentUser?.email)")
            }else{
                //
            }
        }
    }

}
