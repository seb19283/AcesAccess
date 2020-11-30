//
//  FeedViewController.swift
//  accessAces
//
//  Created by Sebastian on 6/19/17.
//  Copyright © 2017 NewWave. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var TableView: UITableView!
    
    var currentUser: String = ""
    
    var groups: [String] = []
    var messages: [Message] = []
    
    var usedGroups: [String] = []
    
    var groupsToPick: [String] = []
    
    var lastMessage: [String: Message] = [:]
    
    var ref: DatabaseReference!
    var databaseHandle: DatabaseHandle?
    
    var timer: Timer?
    
    let cellID = "cellID"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TableView.delegate = self
        TableView.dataSource = self
        TableView.register(groupCell.self, forCellReuseIdentifier: cellID)
        
        currentUser = (Auth.auth().currentUser?.uid)!
        
        ref = Database.database().reference()
        
        getGroups()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if currentUser != Auth.auth().currentUser!.uid {
            if let user = Auth.auth().currentUser?.uid {
                
                ref.child("Messages").removeAllObservers()
                
                currentUser = user
                getGroups()
            }
        }
    }
    
    func observeUserMessages(group: String){
        
        let currentGroup = group
        
        self.ref.child("Messages").child(currentGroup).observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject]{
                
                let message = Message(dictionary: dictionary)
                
                message.group = currentGroup
                
                self.lastMessage[currentGroup] = message
                
                self.messages = Array(self.lastMessage.values)
                self.messages.sort(by: { (message1, message2) -> Bool in
                    return message1.timestamp!.intValue > message2.timestamp!.intValue
                })
                    
            }
            
            self.timer?.invalidate()
            self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.reloadTableView), userInfo: nil, repeats: false)
                
        }, withCancel: nil)
        
    }
    
    @objc func reloadTableView() {
        DispatchQueue.main.async { 
            self.TableView.reloadData()
        }
    }
    
    func getGroups(){
        
        currentUser = (Auth.auth().currentUser?.uid)!
        
        databaseHandle = ref.child("Users").child(currentUser).child("Groups").observe(.childAdded, with: { (snapshot) in
            self.usedGroups.removeAll()
            self.groups.append(snapshot.value as! String)
            self.TableView.reloadData()
            self.observeUserMessages(group: snapshot.value as! String)
        })
    
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! groupCell
        
        if usedGroups.count >= groups.count {
            usedGroups = []
        }
        
        if groupsToPick.count > (groups.count - messages.count){
            groupsToPick = []
        }
        if indexPath.row < messages.count{
            let group = messages[indexPath.row].group!
            var message = ""
            if let message1 = messages[indexPath.row].text {
                message = message1
            }
            let timestamp = messages[indexPath.row].timestamp!
            
            if !(usedGroups.contains(group)){
                usedGroups.append(group)
            }
            
            cell.textLabel?.text = group
            cell.detailTextLabel?.text = "\(message)"
            
            let formatter = DateFormatter()
            let timestampDate = Date(timeIntervalSince1970: timestamp.doubleValue)
            let calendar = Calendar.current
            let components = calendar.dateComponents([.year, .month, .day], from: timestampDate)
            let today = Date()
            let todaysComponents = calendar.dateComponents([.year, .month, .day], from: today)
            
            if components.year! != todaysComponents.year! || components.month! != todaysComponents.month! || components.day! < (todaysComponents.day! - 6) {
                
                formatter.dateFormat = "M/d/y"
                
                cell.timeLabel.text = formatter.string(from: timestampDate)
                
            }
            else if components.day! != todaysComponents.day! {
                
                formatter.dateFormat = "EEEE"
                
                cell.timeLabel.text = formatter.string(from: timestampDate)
                
            }
            else{
                
                formatter.dateFormat = "h:mm a"
                
                cell.timeLabel.text = formatter.string(from: timestampDate)
                
            }
            
        } else {
            for group in groups{
                if !(usedGroups.contains(group)){
                    
                    if !(groupsToPick.contains(group)){
                        groupsToPick.append(group)
                    }
                    
                    usedGroups.append(group)
                    cell.textLabel?.text = group
                    cell.detailTextLabel?.text = "No messages yet!"
                    cell.timeLabel.text = ""
                    
                    return cell
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row < messages.count {
            UserDefaults.standard.set(messages[indexPath.row].group!, forKey: "Current Group")
        } else {
            UserDefaults.standard.set(groupsToPick[indexPath.row-messages.count], forKey: "Current Group")
        }
        
        performSegue(withIdentifier: "showGroup", sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete{
            if indexPath.row < messages.count{
                if messages[indexPath.row].group == "General" {
                    let alert = UIAlertController(title: "Sorry!", message: "Cannot delete the General group chat", preferredStyle: UIAlertControllerStyle.alert)
                    let OK = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
                
                    alert.addAction(OK)
                
                    self.present(alert, animated: true, completion: nil)
                }
                else{
                    ref.child("Users").child((Auth.auth().currentUser?.uid)!).child("Groups").child(messages[indexPath.row].group!).removeValue()
                    ref.child("Groups").child(messages[indexPath.row].group!).child("Members").child((Auth.auth().currentUser?.uid)!).removeValue()
                    
                    groups.remove(at: groups.index(of: messages[indexPath.row].group!)!)
                    messages.remove(at: indexPath.row)
                    
                }
            }else if groupsToPick[indexPath.row - messages.count] == "General"{
                let alert = UIAlertController(title: "Sorry!", message: "Cannot delete the General group chat", preferredStyle: UIAlertControllerStyle.alert)
                let OK = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
                
                alert.addAction(OK)
                
                self.present(alert, animated: true, completion: nil)
            }else{
                
                ref.child("Users").child((Auth.auth().currentUser?.uid)!).child("Groups").child(groupsToPick[indexPath.row - messages.count]).removeValue()
                ref.child("Groups").child(groupsToPick[indexPath.row - messages.count]).child("Members").child((Auth.auth().currentUser?.uid)!).removeValue()
                
                groups.remove(at: groups.index(of: groupsToPick[indexPath.row - messages.count])!)
                groupsToPick.remove(at: indexPath.row - messages.count)
                
            }
        }
        
        TableView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
}

class groupCell: UITableViewCell{
    
    var timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.lightGray
        label.textAlignment = .center
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(timeLabel)
        
        timeLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        timeLabel.topAnchor.constraint(equalTo: (textLabel?.topAnchor)!).isActive = true
        timeLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        timeLabel.heightAnchor.constraint(equalTo: (textLabel?.heightAnchor)!).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
