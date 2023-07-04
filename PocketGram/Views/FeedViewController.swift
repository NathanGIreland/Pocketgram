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
    let fireSService = FirestoreService()
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
        let post = retrivedPosts[section]
        let comments = post.comments.isEmpty ? [[:]] : post.comments
        print("posts count: \(retrivedPosts.count)")
        return retrivedPosts.count + 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int{
        return retrivedPosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = retrivedPosts[indexPath.section]
        let comments = post.comments.isEmpty ? [[:]] : post.comments
        
                                                      
        //if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostCell
            
            cell.usernamLabel.text = "@\(retrivedPosts[indexPath.row].username)"
            
            cell.captionLabel.text = retrivedPosts[indexPath.row].caption
            
            let imgUrl = URL(string: retrivedPosts[indexPath.row].imgUrl)
            
            cell.photoView.af_setImage(withURL: imgUrl!)
            return cell
//        }else{
//            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentCell
//
//            let comment = comments[indexPath.row - 1]
//
//            cell.commentLabel.text = comment["username"]
//            cell.usernameLabel.text = comment["comment"]
//            return cell
//        }
                                
       
    
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var post = retrivedPosts[indexPath.section]
        
        self.fireSService.getUsername(userID: Auth.auth().currentUser!.uid) { username in
            if let username = username {
                // Use the retrieved username here
                print("Username found. \(username)")
                post.comments.append(["username": username, "userId": Auth.auth().currentUser!.uid, "comment": "This is the first comment"])
                print("hel \(post.comments)")
                
                let docRef = self.db.collection("Posts").document(post.postId)

                docRef.updateData(["comments" : post.comments]){error in
                    if let error = error{
                        print("error updating comment \(error)")
                    }else{
                        print("comments updated")
                        DispatchQueue.main.async {
                            self.retrivedPosts[indexPath.section] = post
                            self.tableView.reloadData()
                        }
                    }
                }
                
            } else {
                // Unable to retrieve the username
                print("Username needed to comment")
            }
        }
        
    }
    
    
    /// Listener added to Auth to ...
    func addListenerToAuth(){
        Auth.auth().addStateDidChangeListener{(auth, user) in
            if user != nil {
                print("Updated user authed")
            }else{
                print("Updated user not authed")
                self.performSegue(withIdentifier: "openCameraSegue", sender: nil)
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
                    let postId = data["postId"] as? String ?? ""
                    let userId = data["userId"] as? String ?? ""
                    let imgUrl = data["imgUrl"] as? String ?? ""
                    let timestamp = data["timestamp"] as? Double ?? 0.0
                    let username = data["username"] as? String ?? ""
                    let userPfp = data["userPfp"] as? String ?? ""
                    let comments = data["comments"] as? [[String: String]] ?? [[:]]
                    let likedBy = data["likedBy"] as? [Any] ?? []
                    let caption = data["caption"] as? String ?? ""

                    return postModel(postId: postId, userId: userId, imgUrl: imgUrl, timestamp: timestamp, username: username, userPfp: userPfp, comments: comments, caption: caption)
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
