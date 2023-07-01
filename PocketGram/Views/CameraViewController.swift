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

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var commentField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    let scaledSize = CGSize(width: 400, height: 400)
    var scaledImage = UIImage()
    
    let cameraVM = CameraViewModel()
    
    
    
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
        
        cameraVM.submitPost(image: scaledImage, caption: commentField.text ?? ""){ Success in
            
            if Success {
                self.performSegue(withIdentifier: "unwindToFeed", sender: nil)
            }else{
                
            print("Select a photo")
                
            }
        }
        
        
    }
    

}
