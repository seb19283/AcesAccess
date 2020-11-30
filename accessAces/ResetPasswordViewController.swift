//
//  ResetPasswordViewController.swift
//  accessAces
//
//  Created by Sebastian Connelly (student LM) on 12/4/17.
//  Copyright © 2017 NewWave. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ResetPasswordViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ResetPasswordViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func resetPassword(_ sender: UIButton) {
        if let email = emailTextField.text, emailTextField.hasText{
            Auth.auth().sendPasswordReset(withEmail: email, completion: nil)
            okAction(withMessage: "Email sent to reset your password.", dismiss: true)
        } else {
            okAction(withMessage: "Please enter your email")
        }
    }
    
    func okAction(withMessage message: String, dismiss: Bool = false){
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.alert)
        let OK = UIAlertAction(title: "OK", style: .default) { (action) in
            if dismiss {
                self.dismiss(animated: true, completion: nil)
            }
        }
        
        alert.addAction(OK)
        
        self.present(alert, animated: true, completion: nil)
    }
    
}
