//
//  FeedViewController.swift
//  PocketGram
//
//  Created by Nathan Ireland on 5/18/23.
//

import FirebaseCore
import FirebaseFirestore
import UIKit

class FeedViewController: UIViewController {
    
    var ref: DocumentReference? = nil
    let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()

        ref = db.collection("Users").addDocument(data: [
            "First Name": "nathan",
            "Last Name": "i",
            "profile-picture": "https://",
            "status": "💀",
            "bio": "fun",
            "uid": 123,
            
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            }else{
                print("Document added with ID: \(self.ref!.documentID)")
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
