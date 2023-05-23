//
//  CameraViewModel.swift
//  PocketGram
//
//  Created by Nathan Ireland on 5/21/23.
//

import Foundation

import FirebaseStorage
import FirebaseFirestore
import AlamofireImage
import FirebaseAuth

final class CameraViewModel{
    let sService = StorageService()

    func submitPost(image: UIImage, caption: String, completion: @escaping (Bool) -> Void){
        
        let imageData = image.jpegData(compressionQuality: 0.8)
        let postTimestamp = Date().timeIntervalSince1970
        
        if(imageData == nil){
            completion(false)
            return
        }
        
        sService.storePhoto(imageData: imageData!, caption: caption) { Success in
            if Success{
                completion(true)
            }else{
                completion(false)
            }
        }
        
        
        
        
        
    }
     
        
    
    
    
}
