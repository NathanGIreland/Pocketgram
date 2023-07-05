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
        let comments = post.comments.isEmpty ? [] : post.comments
        print("posts count: \(retrivedPosts.count)")
        print("comments count: \(retrivedPosts[0].comments.count)")
        
        return min(3, comments.count) + 2
        
    
    }
    
    func numberOfSections(in tableView: UITableView) -> Int{
        return retrivedPosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = retrivedPosts[indexPath.section]
        let comments = post.comments.isEmpty ? [] : post.comments
        var count = 0
        
                                                      
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostCell
            
            cell.usernamLabel.text = post.username
            cell.captionLabel.text = post.caption
            let imgUrl = URL(string: post.imgUrl)
            cell.photoView.af_setImage(withURL: imgUrl!)
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: cell.bounds.size.width)
                
            return cell
        }else if indexPath.row <= min(3, comments.count){
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentCell
            
            let comment = comments[indexPath.row - 1]
            cell.commentLabel.text = comment["comment"]
            cell.usernameLabel.text = comment["username"]

            cell.separatorInset = UIEdgeInsets(top: 0, left: tableView.bounds.size.width, bottom: 0, right: 0)
            
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddCommentCell", for: indexPath) as! AddCommentCell
            
            return cell
        }
                                
       
    
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
                    let comments = data["comments"] as? [[String: String]] ?? []
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
