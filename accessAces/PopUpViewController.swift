//
//  PopUpViewController.swift
//  Final Project
//
//  Created by Sebastian Connelly (student LM) on 12/12/16.
//  Copyright © 2016 Sebastian Connelly (student LM). All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class PopUpViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var events = [String]()
    
    var previousDate: String?
    
    let cellID = "cellID"
    
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.show()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let date = UserDefaults.standard.string(forKey: "Date") {
            
            if previousDate == date {
                return
            }
            
            events.removeAll()
            
            Database.database().reference().child("Calendar").child(date).observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    
                    for (event, _) in dictionary {
                        
                        DispatchQueue.main.async {
                            self.events.append(event )
                            
                            self.tableView.reloadData()
                        }
                        
                    }
                    
                } else {
                    self.events.append("No events for today")
                    self.tableView.reloadData()
                }
                
            }, withCancel: nil)
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID)
        
        cell?.textLabel?.textColor = UIColor.black
        cell?.textLabel?.text = events[indexPath.row]
        
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    @IBAction func closePopUp(_ sender: UIButton) {
        self.dismiss()
    }
    
    func show(){
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    func dismiss(){
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.view.removeFromSuperview()
            }
        });
    }
    

    
}
