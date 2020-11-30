//
//  LoginViewController.swift
//  accessAces
//
//  Created by Sebastian on 6/19/17.
//  Copyright © 2017 NewWave. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var Password: UITextField!
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ref = Database.database().reference()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard(){
        view.endEditing(true)
    }
    
    @IBAction func LoginClicked(_ sender: UIButton) {
        
        // Send name and password to server and figure out whether login successful or not
        
        if let email = Email.text, let password = Password.text, (Email.hasText && Password.hasText){
            Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                if let u = user{
                    if u.isEmailVerified{
                        let defaults = UserDefaults.standard
                        defaults.set(true, forKey: "Set Name")
                        
                        defaults.synchronize()
                        
                        self.dismiss(animated: true, completion: nil)
                    }
                    else{
                        self.alertMessage("Please comfirm email")
                    }
                }
                else{
                    self.alertMessage("Wrong username or password")
                }
            })
        }
        
        else{
            alertMessage("Fill in the blanks")
        }
        
    }
    
    func alertMessage(_ message: String){
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.alert)
        let OK = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        
        alert.addAction(OK)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
}
