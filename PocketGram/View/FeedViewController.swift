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
        Auth.auth().addStateDidChangeListener{(auth, user) in
            if let currentUser = user {
                //
                //print("loggedin from feed: \(Auth.auth().currentUser?.email)")
            }else{
                //
            }
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
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
