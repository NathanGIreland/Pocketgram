//
//  CameraViewController.swift
//  PocketGram
//
//  Created by Nathan Ireland on 5/21/23.
//

import UIKit
import PhotosUI
import AlamofireImage
import FirebaseAuth

//move mvvm
import FirebaseStorage
import FirebaseFirestore

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var commentField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    let scaledSize = CGSize(width: 400, height: 400)
    var scaledImage = UIImage()
    
    var ref: DocumentReference? = nil
    let db = Firestore.firestore()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onReturnBtn(_ sender: Any) {
        self.performSegue(withIdentifier: "unwindToFeed", sender: nil)
    }
    
    @IBAction func onCameraBtn(_ sender: Any) {
//        var phpickerConfig = PHPickerConfiguration()
//        phpickerConfig.filter = .images
//
//        let picker = PHPickerViewController(configuration: phpickerConfig)
//
//        picker.delegate = self
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
        }else{
            imagePicker.sourceType = .photoLibrary
        }
        
        present(imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as! UIImage
        
        scaledImage = image.af.imageScaled(to: scaledSize)
        
        imageView.image = scaledImage
        
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func onSubmitBtn(_ sender: Any) {
        let storage = Storage.storage()
        let imageData = scaledImage.jpegData(compressionQuality: 0.8)
        let postTimestamp = Date().timeIntervalSince1970
        
        let storageRef = storage.reference().child("gs://pocketgram-1cd0f.appspot.com/post-images/\(Auth.auth().currentUser?.uid ?? "notf")-\(postTimestamp).jpg")
        
        storageRef.putData(imageData!, metadata: nil){ metadata, error in
            if let error = error {
                print("issue uploading img: \(error.localizedDescription)")
            }else{
                print("Image uploaded")
                
                storageRef.downloadURL{url, error in
                    if let downloadURL = url{
                        print("image url: \(downloadURL)")
                        
                        self.createNewPost(postModel(userId: Auth.auth().currentUser!.uid, imgUrl: url!.absoluteString, timestamp: postTimestamp, username: "make a profile service", userPfp: "String", likedBy: [], caption: self.commentField.text ?? ""))
                        
    
                    }else if let error = error{
                        print("issue downloading img: \(error.localizedDescription)")
                    }
                }
                
                
                
            }
            
        }
        
        
    }
    
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
    

}
