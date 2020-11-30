//
//  InfoViewController.swift
//  accessAces
//
//  Created by Sebastian on 6/25/17.
//  Copyright © 2017 NewWave. All rights reserved.
//

import UIKit
import FirebaseDatabase

class InfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var TableView: UITableView!
    
    var ref: DatabaseReference!
    var databaseHandle: DatabaseHandle?
    var peopleNames: [String] = []
    var peopleUIDs: [String] = []
    
    let cellID = "cellID"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        TableView.delegate = self
        TableView.dataSource = self
        TableView.register(peopleCell.self, forCellReuseIdentifier: cellID)
        
        databaseHandle = ref.child("Groups").child(UserDefaults.standard.string(forKey: "Current Group")!).child("Members").observe(.childAdded, with: { (snapshot) in
            self.peopleNames.append(snapshot.value as! String)
            self.peopleUIDs.append(snapshot.key )
            self.TableView.reloadData()
        }, withCancel: nil)
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peopleNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! peopleCell
        
        cell.textLabel?.text = peopleNames[indexPath.row]
        
        ref.child("Users").child(peopleUIDs[indexPath.row]).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject]{
            
                if let profileImageURL = dictionary["Profile Image"] as? String{
                
                    cell.profileImageView.loadImageWithCache(url: profileImageURL)
                    
                }
                
            }
            
        }, withCancel: nil)
        
        return cell
    }
    
    @IBAction func cancelButtonClicked(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    
}

class peopleCell: UITableViewCell{
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel?.frame = CGRect(x: 56, y: textLabel!.frame.origin.y, width: textLabel!.frame.width, height: textLabel!.frame.height)
    }
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Person Placeholder")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 22
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 6).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 44).isActive = true
        profileImageView .heightAnchor.constraint(equalToConstant: 44).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


