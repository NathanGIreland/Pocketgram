//
//  FeedViewController.swift
//  PocketGram
//
//  Created by Nathan Ireland on 5/18/23.
//

import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import AlamofireImage
import UIKit

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var currentUser: User?
    let db = Firestore.firestore()
    var retrivedPosts = [postModel]()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addListenerToAuth()
        
        hideKeyboardWhenTappedAround()
        getPost()
        
    }

   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let refreshControl = UIRefreshControl();
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: .valueChanged)
           
        self.tableView.refreshControl = refreshControl
        
    }
    
    @IBAction func onNewPostBtn(_ sender: Any) {
           self.performSegue(withIdentifier: "openCameraSegue", sender: nil)
       }
       
    
    
    @IBAction func unwind( _ seg: UIStoryboardSegue) {
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("posts count: \(retrivedPosts.count)")
        return retrivedPosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostCell
        
        let post = retrivedPosts[indexPath.row]
        
        cell.usernamLabel.text = "@\(retrivedPosts[indexPath.row].username)"
        
        cell.captionLabel.text = retrivedPosts[indexPath.row].caption
        
        let imgUrl = URL(string: retrivedPosts[indexPath.row].imgUrl)
        
        cell.photoView.af_setImage(withURL: imgUrl!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    /// Listener added to Auth to ...
    func addListenerToAuth(){
        Auth.auth().addStateDidChangeListener{(auth, user) in
            if user != nil {
                print("Updated user authed")
            }else{
                print("Updated user not authed")
            }
        }
    }
    
    func getPost(){
        db.collection("Posts").order(by: "timestamp", descending: true).getDocuments(source: .default) {(querySnapshot, error) in
            if let error = error{
                print("error: \(error)")
                return
            }else if (querySnapshot != nil){
                let posts = querySnapshot?.documents.compactMap { document -> postModel? in

                    let data = document.data() //key for dictonary to retrive values from documents
                    let postId = document.documentID
                    let userId = data["userId"] as? String ?? ""
                    let imgUrl = data["imgUrl"] as? String ?? ""
                    let timestamp = data["timestamp"] as? Double ?? 0.0
                    let username = data["username"] as? String ?? ""
                    let userPfp = data["userPfp"] as? String ?? ""
                    let commentIds = data["commentIds"] as? [Any] ?? []
                    let likedBy = data["likedBy"] as? [Any] ?? []
                    let caption = data["caption"] as? String ?? ""

                    return postModel(userId: userId, imgUrl: imgUrl, timestamp: timestamp, username: username, userPfp: userPfp, caption: caption)
                }

                self.retrivedPosts = posts!
                self.tableView.reloadData()

            }else{
                print("error retriving post: \(error)")
            }
        }
    }
    
    @objc func refreshControlAction(_ refreshControl: UIRefreshControl) {
            getPost()
            
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                // End refreshing on the refresh control
                refreshControl.endRefreshing()
            }
    }

}
