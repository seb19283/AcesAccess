//
//  RegisterViewController.swift
//  accessAces
//
//  Created by Sebastian on 6/19/17.
//  Copyright © 2017 NewWave. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class RegisterViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var passwordReentry: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(RegisterViewController.dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        
        profileImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(setProfileImage)))
        profileImage.isUserInteractionEnabled = true
        
    }
    
    @objc func setProfileImage(){
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImage: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage{
            selectedImage = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            selectedImage = originalImage
        }
        
        if let image = selectedImage{
            profileImage.image = image
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func RegisterButtonClicked(_ sender: UIButton) {
        
        sender.isEnabled = false
        
        //Check if everything is filled in
        if(!email.hasText || !username.hasText || !password.hasText || !passwordReentry.hasText){
            
            alertMessage("Fill in the blanks")
            
            sender.isEnabled = true
            
            return
        }
        
        // Check if passwords match
        if(password.text != passwordReentry.text){
            
            alertMessage("Passwords must match")
            
            sender.isEnabled = true
            
            return
        }
        
        //Create the user
        Auth.auth().createUser(withEmail: email.text!, password: password.text!) { (user, error) in
            
            let storageRef = Storage.storage().reference().child("Profile Images").child("\(NSUUID().uuidString).jpg")
            
            if let u = user{
                
                if let profile = self.profileImage.image, let uploadData = UIImageJPEGRepresentation(profile, 0.1){
                    
                    storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                        if error != nil{
                            print(error)
                            return
                        }
                        
                        if let profileImageURL = metadata?.downloadURL()?.absoluteString{
                            self.ref?.child("Users").child(u.uid).child("Profile Image").setValue(profileImageURL)
                        }
                        
                    })
                    
                }
                
                //Write the name for that specific User ID
                self.ref?.child("Users").child(u.uid).child("Name").setValue(self.username.text)                
                u.sendEmailVerification(completion: nil)
                self.ref.child("Users").child(u.uid).child("Groups").child("General").setValue("General")
                self.ref.child("Groups").child("General").child("Members").child(u.uid).setValue(self.username.text!)
                
                //User is logged in
                let alert = UIAlertController(title: "Alert", message: "Registration successful. Please comfirm email.", preferredStyle: UIAlertControllerStyle.alert)
                
                let OK = UIAlertAction(title: "OK", style: UIAlertActionStyle.default){ action in
                    self.dismiss(animated: true, completion: nil)
                }
                
                alert.addAction(OK)
                
                self.present(alert, animated: true, completion: nil)
            }
            else{
                self.alertMessage("Email already exists")
            }
        }
        
        
        sender.isEnabled = true
    }
    
    @IBAction func LoginButtonClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func alertMessage(_ message: String){
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.alert)
        let OK = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        
        alert.addAction(OK)
        
        self.present(alert, animated: true, completion: nil)
    }
    
}
