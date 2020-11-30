//
//  RideShareViewController.swift
//  accessAces
//
//  Created by Sebastian on 6/19/17.
//  Copyright © 2017 NewWave. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class RideShareViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    
    var events = [RideShareEvents]()
    
    var ref: DatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        observeEvents()
    }
    
    func observeEvents() {
        
        ref?.child("Giving Rides").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                let rideShareEvent = RideShareEvents()
                
                rideShareEvent.date = dictionary["Date"] as? String
                rideShareEvent.event = snapshot.key
                rideShareEvent.giver = dictionary["Person"] as? String
                rideShareEvent.people = dictionary["Number of People"] as? String
                rideShareEvent.time = dictionary["Time"] as? String
                rideShareEvent.location = dictionary["Location"] as? [String]
                
                self.events.append(rideShareEvent)
                
                self.events.sort(by: { (event1, event2) -> Bool in
                    
                    guard let date1 = event1.date, let date2 = event2.date else {
                        return true
                    }
                    
                    let date1YearIndex: Range<String.Index> = date1.index(date1.startIndex, offsetBy: 6)..<date1.endIndex
                    let date2YearIndex: Range<String.Index> = date2.index(date2.startIndex, offsetBy: 6)..<date2.endIndex
                    
                    let date1DayIndex: Range<String.Index> = date1.index(date1.startIndex, offsetBy: 3)..<date1.index(date1.startIndex, offsetBy: 5)
                    let date2DayIndex: Range<String.Index> = date2.index(date2.startIndex, offsetBy: 3)..<date2.index(date2.startIndex, offsetBy: 5)
                    
                    if Int(date1.substring(with: date1YearIndex))! < Int(date2.substring(with: date2YearIndex))! {
                        return true
                    }else if Int(date1.substring(to: date1.index(date1.startIndex, offsetBy: 2)))! < Int(date2.substring(to: date2.index(date2.startIndex, offsetBy: 2)))! {
                        return true
                    } else if Int(date1.substring(with: date1DayIndex))! < Int(date2.substring(with: date2DayIndex))! {
                        return true
                    } else {
                        return false
                    }
                    
                })
                
                for event in self.events{
                    
                    guard let date = event.date else {
                        return
                    }
                    
                    let dateYearIndex: Range<String.Index> = date.index(date.startIndex, offsetBy: 6)..<date.endIndex
                    
                    let dateDayIndex: Range<String.Index> = date.index(date.startIndex, offsetBy: 3)..<date.index(date.startIndex, offsetBy: 5)
                    
                    let todaysDate = Date()
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat  = "dd"
                    let day: Int = Int(dateFormatter.string(from: todaysDate))!
                    dateFormatter.dateFormat = "yyyy"
                    let year: Int = Int(dateFormatter.string(from: todaysDate))!
                    dateFormatter.dateFormat = "MM"
                    let month: Int = Int(dateFormatter.string(from: todaysDate))!
                    
                    if Int(date.substring(with: dateYearIndex))! < year{
                        self.events.remove(at: self.events.index(of: event)!)
                    } else if Int(date.substring(to: date.index(date.startIndex, offsetBy: 2)))! < month{
                        self.events.remove(at: self.events.index(of: event)!)
                    } else if Int(date.substring(with: dateDayIndex))! < day {
                        self.events.remove(at: self.events.index(of: event)!)
                    }
                    
                }
                
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                })
                
            }
            
        }, withCancel: nil)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID")
        
        cell?.textLabel?.text = events[indexPath.row].event
        cell?.detailTextLabel?.text = events[indexPath.row].time!
        
        return cell!
    }
    
}
