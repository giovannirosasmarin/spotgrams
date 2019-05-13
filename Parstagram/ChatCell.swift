//
//  ChatCell.swift
//  Parstagram
//
//  Created by Giovanni Rosas-Marin on 5/6/19.
//  Copyright © 2019 Codepath. All rights reserved.
//

import UIKit
import Parse

class ChatCell: UITableViewCell {
    
    @IBOutlet weak var userLabel: UILabel!
    
    @IBOutlet weak var messageLabel: UILabel!
    
    var messages: PFObject! {
        didSet {
            messageLabel.text = messages.object(forKey: "text") as? String
            
            //let username = messages.object(forKey: "user")
            let user = messages.object(forKey: "user") as? PFUser
            if (user != nil) {
                userLabel.text = user?.username
            }
            else {
                userLabel.text = ""
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
