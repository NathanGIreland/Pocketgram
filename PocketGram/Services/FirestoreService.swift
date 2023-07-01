//
//  FirestoreService.swift
//  PocketGram
//
//  Created by Nathan Ireland on 5/21/23.
//

import Foundation

import FirebaseStorage
import FirebaseFirestore
import AlamofireImage
import FirebaseAuth

final class FirestoreService{
    
    //firestore
    var ref: DocumentReference? = nil
    let db = Firestore.firestore()
    
    
    func createNewPost(_ post: postModel){
        let docID = UUID().uuidString
        let documentRef = self.db.collection("Posts").document(docID)
        documentRef.setData([
            "postId" : docID,
            "userId" : post.userId,
            "imgUrl" : post.imgUrl,
            "timestamp" : post.timestamp,
            "username" : post.username,
            "userPfp" : post.userPfp,
            "commentIds" : post.commentIds,
            "likedBy" : post.likedBy,
            "caption" : post.caption,
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            }else{
                print("Document added with ID: \(documentRef.documentID)")
            }
        }
    }
    
    
    /// Creates a new user in user collection
    /// - Parameter user: userModel
    func createNewUser(_ user: userModel){
        let documentRef = self.db.collection("Users").document(user.uid)
        documentRef.setData([
            "first-name": user.firstName,
            "last-name": user.lastName,
            "email": user.email,
            "username": user.username,
            "profile-picture": user.profilePicture,
            "status": user.status,
            "bio": user.bio,
            "uid": user.uid,
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
                
            }else{
                print("Document added with ID: \(documentRef.documentID)")
            }
        }
        
    }
    
    func getUsername(userID: String, completion: @escaping (String?) -> Void) {
        self.db.collection("Users").document(userID).getDocument { (querySnapshot, error) in
            if let error = error {
                print("Error: \(error)")
                completion(nil)
            } else {
                let data = querySnapshot?.data()
                let username = data?["username"] as? String
                completion(username)
            }
        }
    }
 
   
    
}
