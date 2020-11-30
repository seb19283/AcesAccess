//
//  AddGroupsViewController.swift
//  accessAces
//
//  Created by Sebastian on 6/22/17.
//  Copyright © 2017 NewWave. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class AddGroupsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    var ref: DatabaseReference!
    
    @IBOutlet weak var TableView: UITableView!
    
    var selectedGroups: [String] = []
    
    var filteredGroups: [String] = []
    var groups: [String] = ["A Cappella",
    "ATR Records",
    "AV Club",
    "All Genders and Sexualities Allied",
    "Amnesty International",
    "Art Forum",
    "Asian Culture Club",
    "Baseball",
    "Becton Scholars",
    "Best Buddies",
    "Blood Drive Committee",
    "Boys Basketball",
    "Boys Crew",
    "Boys Cross Country",
    "Boys Ice Hockey",
    "Boys Indoor Track",
    "Boys Lacrosse",
    "Boys Soccer",
    "Boys Squash",
    "Boys Swimming",
    "Boys Tennis",
    "Boys Track and Field",
    "Boys Ultimate",
    "Boys Volleyball",
    "BuildOn",
    "Chess Club",
    "Culinary Arts Club",
    "Dance Team",
    "Dawgma",
    "Drill Team",
    "Environmental Club",
    "Fall Cheer",
    "Field Hockey",
    "Film Club",
    "Flower Show Club",
    "Football",
    "French Club",
    "Friendship Club",
    "Girls Basketball",
    "Girls Crew",
    "Girls Cross Country",
    "Girls Ice Hockey",
    "Girls Indoor Track",
    "Girls Lacrosse",
    "Girls Soccer",
    "Girls Squash",
    "Girls Swimming",
    "Girls Tennis",
    "Girls Track and Field",
    "Girls Ultimate",
    "Girls Volleyball",
    "Golf",
    "InsideOut",
    "Intramural Baskteball",
    "Israeli Culture Club",
    "Jazz Band",
    "LMHStv",
    "Latin Club",
    "Math Club",
    "Merionite",
    "Mock Trial",
    "Model UN",
    "National Honor Society",
    "Pep Band",
    "Philly Mentoring",
    "Photography Club",
    "Players",
    "Programming Club",
    "S.A.D.D.",
    "Sage",
    "Science Olympiad",
    "Second Stage",
    "Service League",
    "Softball",
    "Spanish Club",
    "SpeakUp",
    "Speech and Debate",
    "TSA",
    "The Dolphin",
    "Winter Cheer",
    "Women in Power",
    "World Affairs Club",
    "Wrestling",
    "Yearbook"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        TableView.delegate = self
        TableView.dataSource = self
        ref = Database.database().reference()
    }

    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Base Cell")
        cell?.textLabel?.text = groups[indexPath.row]
        
        if selectedGroups.contains(groups[indexPath.row]){
            cell?.accessoryType = UITableViewCellAccessoryType.checkmark
        }
        else{
            cell?.accessoryType = UITableViewCellAccessoryType.none
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        
        if(cell?.accessoryType == UITableViewCellAccessoryType.checkmark){
            cell?.accessoryType = UITableViewCellAccessoryType.none
            selectedGroups.remove(at: selectedGroups.index(of: groups[indexPath.row])!)
        }
        else{
            cell?.accessoryType = UITableViewCellAccessoryType.checkmark
            selectedGroups.append(groups[indexPath.row])
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func cancelButtonClicked(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonClicked(_ sender: UIBarButtonItem) {
        
        for item in selectedGroups{
            
            self.ref.child("Users").child((Auth.auth().currentUser?.uid)!).child("Groups").child(item).setValue(item)
            self.ref.child("Groups").child(item).child("Members").child((Auth.auth().currentUser?.uid)!).setValue(UserDefaults.standard.string(forKey: "Username"))
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
}
