//
//  ChatViewController.swift
//  Parstagram
//
//  Created by Giovanni Rosas-Marin on 5/6/19.
//  Copyright © 2019 Codepath. All rights reserved.
//

import UIKit
import Parse

class ChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
 
    @IBOutlet weak var messageText: UITextField!
    

    @IBOutlet weak var tableView: UITableView!
    
    
    
    var messages: [PFObject]?
    

override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    tableView.dataSource = self
    tableView.delegate = self
    // for the cell to autoresize
    tableView.estimatedRowHeight = 100
    tableView.rowHeight = UITableView.automaticDimension
    
    Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ChatViewController.onTimer), userInfo: nil, repeats: true)
    }
    
    
    
    
    @objc func onTimer() {
        let query = PFQuery(className:"Message")
        query.whereKeyExists("text").includeKey("user")
        query.order(byDescending: "createdAt")
        query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) -> Void in
            if error == nil {
                // The find succeeded.
                self.messages = objects
                self.tableView.reloadData()
                
            } else {
                // Log details of the failure
                print(error as Any)
            }
        }
    }
    
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let message = self.messages {
            return message.count
        }
        return 0
    }
    
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as! ChatCell
        cell.messages = (self.messages?[indexPath.row])!
        return cell
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    // on hitting the send button
    
    @IBAction func onSend(_ sender: Any) {
        
        print ("sending message")
        print (messageText.text ?? "Nothing")
        if messageText.text != "" {
            let message = PFObject(className: "Message")
            message["text"] = messageText.text
            message["user"] = PFUser.current()
            message.saveInBackground(block: {(success: Bool?, error: Error?) in
                if success == true {
                    print ("message sent")
                }
                else {
                    print ("message not sent")
                }
            })
        }
        
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
