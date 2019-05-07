//
//  LoginViewController.swift
//  Parstagram
//
//  Created by Giovanni Rosas-Marin on 3/10/19.
//  Copyright © 2019 Codepath. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {
    
    let alertController = UIAlertController(title: "Email required", message: "Please enter email", preferredStyle: .alert)
    
    
    //login fields
    @IBOutlet weak var usernameField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func onSignIn(_ sender: Any) {
        
        let username = usernameField.text!
        let password = passwordField.text!
        PFUser.logInWithUsername(inBackground: username, password: password) { (user, error) in
            
           
            
            
            if user != nil{
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            
          
              
              
            }else{
                print("Error: \(String(describing: error?.localizedDescription))")
                let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
                    
                }
                
                // add the OK action to the alert controller
                self.alertController.addAction(OKAction)
                self.present(self.alertController, animated: true) {
                    // optional code for what happens after the alert controller has finished presenting
                }
            }
       
        }
      

    }
    
    @IBAction func onSignup(_ sender: Any) {
        let user = PFUser()
        user.username = usernameField.text
        user.password = passwordField.text
        
        user.signUpInBackground{(success, error) in
            
            if success {
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }else{
                print("Error: \(String(describing: error?.localizedDescription))")
            }
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

