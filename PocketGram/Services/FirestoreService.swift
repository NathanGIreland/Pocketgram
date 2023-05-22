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
        self.ref = self.db.collection("Posts").addDocument(data: [
            "postId" : post.postId,
            "userId" : post.userId,
            "imgUrl" : post.imgUrl,
            "timestamp" : post.timestamp,
            "username" : post.username,
            "userPfp" : post.userPfp,
            "commentId" : post.commentId,
            "likedBy" : post.likedBy,
            "caption" : post.caption,
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            }else{
                print("Document added with ID: \(self.ref!.documentID)")
            }
        }
    }
    
    
    /// Creates a new user in user collection
    /// - Parameter user: userModel
    func createNewUser(_ user: userModel){
        self.ref = self.db.collection("Users").addDocument(data: [
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
                print("Document added with ID: \(self.ref!.documentID)")
            }
        }
        
    }
    
    
}
