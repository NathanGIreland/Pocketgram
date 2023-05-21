//
//  CameraViewController.swift
//  PocketGram
//
//  Created by Nathan Ireland on 5/21/23.
//

import UIKit

class CameraViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onReturnBtn(_ sender: Any) {
        print("return from camera")
        self.performSegue(withIdentifier: "unwindToFeed", sender: nil)
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
