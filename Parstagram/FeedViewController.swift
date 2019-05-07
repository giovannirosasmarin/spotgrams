//
//  FeedViewController.swift
//  Parstagram
//
//  Created by Giovanni Rosas-Marin on 3/10/19.
//  Copyright © 2019 Codepath. All rights reserved.
//

import UIKit
import Parse
import AlamofireImage
import MessageInputBar

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MessageInputBarDelegate {
    
    let alertController = UIAlertController(title: "", message: "are you sure you want to log out?", preferredStyle: .actionSheet)
    
    @IBOutlet weak var tableView: UITableView!
    let commentBar = MessageInputBar()
    var showCommentBar = false
    var posts = [PFObject]()
    var selectedPost: PFObject!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        commentBar.inputTextView.placeholder = "Add a comment..."
        commentBar.sendButton.title = "Post"
        commentBar.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.keyboardDismissMode = .interactive
        
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(keyboardWillBeHidden(note:)), name: UIResponder.keyboardDidHideNotification, object: nil)
        
    }
    
    @objc func keyboardWillBeHidden(note: Notification){
        commentBar.inputTextView.text = nil
        showCommentBar = false
        becomeFirstResponder()
        
    }
    
    override var inputAccessoryView: UIView? {
        return commentBar
    }
    
    override var canBecomeFirstResponder: Bool{
        return showCommentBar
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let query = PFQuery(className: "Posts")
        query.includeKeys(["author","comments", "comments.author"])
        query.limit = 20
        
        query.findObjectsInBackground { (posts, error) in
            if posts != nil {
                self.posts = posts!
                self.tableView.reloadData()
            }
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let post = posts[section]
        let comments = (post["comments"] as? [PFObject]) ?? []
     
        
        return comments.count + 2
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let post =  posts[indexPath.section]
        let comments = (post["comments"] as? [PFObject]) ?? []
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
            
            let user = post["author"] as! PFUser
            cell.usernameLabel.text = user.username
            
            cell.captionLabel.text = post["caption"] as? String
            
            let imageFile = post["image"] as! PFFileObject
            let urlString = imageFile.url!
            let url = URL(string: urlString)!
            
            cell.photoView.af_setImage(withURL: url)
            
            return cell
            
        }else if indexPath.row <= comments.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell") as! CommentCell
            
            let comment = comments[indexPath.row - 1]
            cell.commentLabel.text = comment["text"] as? String
            
            let user = comment["author"] as! PFUser
            cell.nameLabel.text = user.username
            
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddCommentCell")!
            
            return cell
        }
        
    }
    
    @IBAction func onLogoutButton(_ sender: Any) {
        
        PFUser.logOut()
        let logoutAction = UIAlertAction(title: "Log Out", style: .destructive) { (action) in
            // handle case of user logging out
            let main = UIStoryboard(name: "Main", bundle: nil)
            let loginViewController = main.instantiateViewController(withIdentifier: "LoginViewController")
            let delegate =  UIApplication.shared.delegate as! AppDelegate
            
            delegate.window?.rootViewController = loginViewController
            
            
            
        }
        
        // add the logout action to the alert controller
        alertController.addAction(logoutAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            
        }
        // add the cancel action to the alert controller
        alertController.addAction(cancelAction)
        
        
        present(alertController, animated: true) {
            // optional code for what happens after the alert controller has finished presenting
        }
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
        // create comment
        
        let comment = PFObject(className: "Comments")
        comment["text"] = text
        comment["post"] = selectedPost
        comment["author"] = PFUser.current()!
        
        selectedPost.add(comment, forKey: "comments")
        selectedPost.saveInBackground{(success, error) in
            if success{
                print("Comment Saved")
            }else{
                print("Error saving comment")
            }
        }
        tableView.reloadData()
        
        //clear input
        commentBar.inputTextView.text = nil
        showCommentBar = false
        becomeFirstResponder()
        commentBar.inputTextView.resignFirstResponder()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = posts[indexPath.section]
        let comments = (post["comments"] as? [PFObject]) ?? []
        
        if indexPath.row == comments.count + 1 {
            showCommentBar = true
            becomeFirstResponder()
            commentBar.inputTextView.becomeFirstResponder()
            
            selectedPost = post
        }
        
    }
}
