//
//  StorageService.swift
//  PocketGram
//
//  Created by Nathan Ireland on 5/21/23.
//

import Foundation

import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseStorage
import FirebaseFirestore

final class StorageService {
    var ref: DocumentReference? = nil
    var postTimestamp = 0.0
    let db = Firestore.firestore()
    let storage = Storage.storage()
    let fireSService = FirestoreService()
    
    func storePhoto(imageData: Data, caption: String, completion: @escaping (Bool) -> Void) {
        postTimestamp = Date().timeIntervalSince1970

        let storageRef = storage.reference().child("post-images/\(Auth.auth().currentUser?.uid ?? "notf")-\(postTimestamp).jpg")

        let uploadTask = storageRef.putData(imageData, metadata: nil) { (metadata, error) in
            if let error = error {
                print("issue uploading img: \(error.localizedDescription)")
                completion(false)
            } else {
                storageRef.downloadURL { (url, error) in
                    if let downloadURL = url {
                        print("image url: \(downloadURL)")

                        self.fireSService.getUsername(userID: Auth.auth().currentUser!.uid) { username in
                            if let username = username {
                                // Use the retrieved username here
                                print("Username found. \(username)")

                                self.fireSService.createNewPost(postModel(userId: Auth.auth().currentUser!.uid, imgUrl: downloadURL.absoluteString, timestamp: self.postTimestamp, username: username, userPfp: "String", caption: caption))
                                
                                completion(true)
                            } else {
                                // Unable to retrieve the username
                                print("Username not found.")
                                completion(false)
                            }
                        }
                    } else if let error = error {
                        print("issue downloading img: \(error.localizedDescription)")
                        completion(false)
                    }
                }
            }
        }

        // Uncomment the lines below to remove the observers
        // uploadTask.removeAllObservers()
    }

    
    func uploadPost(imageData: Data, caption: String, username: String, completion: @escaping (Bool) -> Void) {
            let storageRef = storage.reference().child("post-images/\(Auth.auth().currentUser?.uid ?? "notf")-\(postTimestamp).jpg")
            
            storageRef.downloadURL { url, error in
                if let downloadURL = url {
                    print("image url: \(downloadURL)")

                    self.fireSService.createNewPost(postModel(userId: Auth.auth().currentUser!.uid, imgUrl: url!.absoluteString, timestamp: self.postTimestamp, username: username, userPfp: "String", caption: caption))

                    completion(true)
                } else if let error = error {
                    print("issue downloading img: \(error.localizedDescription)")
                    completion(false)
                }
            }
        }

}
