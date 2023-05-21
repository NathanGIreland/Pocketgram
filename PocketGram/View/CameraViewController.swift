//
//  CameraViewController.swift
//  PocketGram
//
//  Created by Nathan Ireland on 5/21/23.
//

import UIKit
import PhotosUI

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var commentField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onReturnBtn(_ sender: Any) {
        print("return from camera")
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
    }
    
    
    @IBAction func onSubmitBtn(_ sender: Any) {
    }
    

}
