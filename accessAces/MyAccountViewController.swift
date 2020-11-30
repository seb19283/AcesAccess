//
//  MyAccountViewController.swift
//  accessAces
//
//  Created by Sebastian on 6/19/17.
//  Copyright © 2017 NewWave. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class MyAccountViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    let cellID = "cellID"
    
    let names = ["Rules", "Help", "FAQ", "Logout", "Reset Password"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(SettingsCell.self, forCellReuseIdentifier: cellID)
        
        setNameAndImageView()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if(UserDefaults.standard.bool(forKey: "Set Name")){
            Database.database().reference().child("Users").child((Auth.auth().currentUser?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject]{
                    UserDefaults.standard.set(dictionary["Name"] as! String, forKey: "Username")
                    UserDefaults.standard.set(dictionary["Profile Image"], forKey: "Profile Image")
                    UserDefaults.standard.set(false, forKey: "Set Name")
                    self.setNameAndImageView()
                }
            }, withCancel: nil)
        }
    }
    
    func setNameAndImageView(){
        nameLabel.text = UserDefaults.standard.string(forKey: "Username")
        
        if let url = UserDefaults.standard.string(forKey: "Profile Image"){
            profileImage.loadImageWithCache(url: url)
            profileImage.layer.masksToBounds = true
            profileImage.layer.cornerRadius = 50
        }
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! SettingsCell
        
        cell.textView.isUserInteractionEnabled = false
        
        cell.textView.text = names[indexPath.row]
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if names[indexPath.row] == "Logout" {
            logout()
        } else if names[indexPath.row] == "Reset Password" {
            resetPassword()
        }
        
    }
    
    func logout() {
        do{
            try Auth.auth().signOut()
            UserDefaults.standard.set(false, forKey: "Logged In")
            performSegue(withIdentifier: "Present Login", sender: nil)
        }catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    func resetPassword(){
        if let email = Auth.auth().currentUser?.email {
            Auth.auth().sendPasswordReset(withEmail: email, completion: nil)
            okAction()
        }
    }
    
    func okAction(){
        let alert = UIAlertController(title: "Alert", message: "Email sent to reset your password.", preferredStyle: UIAlertControllerStyle.alert)
        let OK = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        
        alert.addAction(OK)
        
        self.present(alert, animated: true, completion: nil)
    }
}
