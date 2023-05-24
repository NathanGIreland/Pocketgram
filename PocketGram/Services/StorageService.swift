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
    
    
    func storePhoto(imageData: Data, caption: String, completion: @escaping (Bool) -> Void){
        postTimestamp = Date().timeIntervalSince1970
        
        let storageRef = storage.reference().child("gs://pocketgram-1cd0f.appspot.com/post-images/\(Auth.auth().currentUser?.uid ?? "notf")-\(postTimestamp).jpg")
       
        storageRef.putData(imageData, metadata: nil){ metadata, error in
            if let error = error {
                print("issue uploading img: \(error.localizedDescription)")
                completion(false)
                
            }else{
                print("Image uploaded")
                
                storageRef.downloadURL{url, error in
                    if let downloadURL = url{
                        print("image url: \(downloadURL)")
                        
                        //TODO: update username with profile service
                        self.fireSService.createNewPost(postModel(userId: Auth.auth().currentUser!.uid, imgUrl: url!.absoluteString, timestamp: self.postTimestamp, username: Auth.auth().currentUser!.uid, userPfp: "String", caption: caption))
                        
                        completion(true)
                            
                    
    
                    }else if let error = error{
                        print("issue downloading img: \(error.localizedDescription)")
                        completion(false)
                    }
                }
                
                
                
            }
            
        }
    }
    

}
