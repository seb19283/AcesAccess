//
//  CalendarVIewController.swift
//  Final Project
//
//  Created by Sebastian Connelly (student LM) on 1/9/17.
//  Copyright © 2017 Sebastian Connelly (student LM). All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class CalendarViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var Button1: UIButton!
    @IBOutlet weak var Button2: UIButton!
    @IBOutlet weak var Button3: UIButton!
    @IBOutlet weak var Button4: UIButton!
    @IBOutlet weak var Button5: UIButton!
    @IBOutlet weak var Button6: UIButton!
    @IBOutlet weak var Button7: UIButton!
    @IBOutlet weak var Button8: UIButton!
    @IBOutlet weak var Button9: UIButton!
    @IBOutlet weak var Button10: UIButton!
    @IBOutlet weak var Button11: UIButton!
    @IBOutlet weak var Button12: UIButton!
    @IBOutlet weak var Button13: UIButton!
    @IBOutlet weak var Button14: UIButton!
    @IBOutlet weak var Button15: UIButton!
    @IBOutlet weak var Button16: UIButton!
    @IBOutlet weak var Button17: UIButton!
    @IBOutlet weak var Button18: UIButton!
    @IBOutlet weak var Button19: UIButton!
    @IBOutlet weak var Button20: UIButton!
    @IBOutlet weak var Button21: UIButton!
    @IBOutlet weak var Button22: UIButton!
    @IBOutlet weak var Button23: UIButton!
    @IBOutlet weak var Button24: UIButton!
    @IBOutlet weak var Button25: UIButton!
    @IBOutlet weak var Button26: UIButton!
    @IBOutlet weak var Button27: UIButton!
    @IBOutlet weak var Button28: UIButton!
    @IBOutlet weak var Button29: UIButton!
    @IBOutlet weak var Button30: UIButton!
    @IBOutlet weak var Button31: UIButton!
    @IBOutlet weak var Button32: UIButton!
    @IBOutlet weak var Button33: UIButton!
    @IBOutlet weak var Button34: UIButton!
    @IBOutlet weak var Button35: UIButton!
    @IBOutlet weak var Button36: UIButton!
    @IBOutlet weak var Button37: UIButton!
    @IBOutlet weak var Button38: UIButton!
    @IBOutlet weak var Button39: UIButton!
    @IBOutlet weak var Button40: UIButton!
    @IBOutlet weak var Button41: UIButton!
    @IBOutlet weak var Button42: UIButton!
    
    var lastDay = " "
    var dayNum = 0
    var firstDay = " "
    var events: [String] = []
    var todaysDate: Int?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidAppear(_ animated: Bool) {
        unHide()
        start()
        
        if(UserDefaults.standard.bool(forKey: "Set Name")){
            Database.database().reference().child("Users").child((Auth.auth().currentUser?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject]{
                    UserDefaults.standard.set(dictionary["Name"] as! String, forKey: "Username")
                    UserDefaults.standard.set(dictionary["Profile Image"], forKey: "Profile Image")
                    UserDefaults.standard.set(false, forKey: "Set Name")
                }
            }, withCancel: nil)
        }
        
        if todaysDate != UserDefaults.standard.integer(forKey: "Day of Month") {
            
            todaysDate = UserDefaults.standard.integer(forKey: "Day of Month")
            
            Database.database().reference().child("Calendar").child("\(UserDefaults.standard.object(forKey: "Month")!)_\(todaysDate!)_\(UserDefaults.standard.integer(forKey: "Year"))").observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    
                    for (event, _) in dictionary {
                        
                        self.events.append(event)
                        
                        self.tableView.reloadData()
                        
                    }
                    
                    if self.events.count == 1 {
                        self.tableView.separatorStyle = .none
                    }
                    
                } else {
                    self.events.append("No events for today!")
                    self.tableView.separatorStyle = .none
                    self.tableView.reloadData()
                }
                
            }, withCancel: nil)
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(Auth.auth().currentUser == nil){
            performSegue(withIdentifier: "Prompt Login", sender: nil)
        }
        
        start()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        cell.textLabel?.text = events[indexPath.row]
        
        return cell
    }
    
    @IBAction func backAMonth(_ sender: UIBarButtonItem) {
        unHide()
        let defaults = UserDefaults.standard
        let Month = (String)(describing: defaults.object(forKey: "Month")!)
        if(Month == "1"){
            defaults.set("12", forKey: "Month")
            defaults.set(defaults.integer(forKey: "Year") - 1, forKey: "Year")
            navigationItem.title = "December " + (String)(defaults.integer(forKey: "Year"))
        }
        else if(Month == "2"){
            defaults.set("1", forKey: "Month")
            navigationItem.title = "January " + (String)(defaults.integer(forKey: "Year"))
        }
        else if(Month == "3"){
            defaults.set("2", forKey: "Month")
            navigationItem.title = "February " + (String)(defaults.integer(forKey: "Year"))
        }
        else if(Month == "4"){
            defaults.set("3", forKey: "Month")
            navigationItem.title = "March " + (String)(defaults.integer(forKey: "Year"))
        }
        else if(Month == "5"){
            defaults.set("4", forKey: "Month")
            navigationItem.title = "April " + (String)(defaults.integer(forKey: "Year"))
        }
        else if(Month == "6"){
            defaults.set("5", forKey: "Month")
            navigationItem.title = "May " + (String)(defaults.integer(forKey: "Year"))
        }
        else if(Month == "7"){
            defaults.set("6", forKey: "Month")
            navigationItem.title = "June " + (String)(defaults.integer(forKey: "Year"))
        }
        else if(Month == "8"){
            defaults.set("7", forKey: "Month")
            navigationItem.title = "July " + (String)(defaults.integer(forKey: "Year"))
        }
        else if(Month == "9"){
            defaults.set("8", forKey: "Month")
            navigationItem.title = "August " + (String)(defaults.integer(forKey: "Year"))
        }
        else if(Month == "10"){
            defaults.set("9", forKey: "Month")
            navigationItem.title = "September " + (String)(defaults.integer(forKey: "Year"))
        }
        else if(Month == "11"){
            defaults.set("10", forKey: "Month")
            navigationItem.title = "October " + (String)(defaults.integer(forKey: "Year"))
        }
        else if(Month == "12"){
            defaults.set("11", forKey: "Month")
            navigationItem.title = "November " + (String)(defaults.integer(forKey: "Year"))
        }
        setStartDate(getOriginalDay(dayNum, firstDay))
    }
    
    @IBAction func forwardAMonth(_ sender: UIBarButtonItem) {
        unHide()
        let defaults = UserDefaults.standard
        let Month = (String)(describing: defaults.object(forKey: "Month")!)
        if(Month == "1"){
            defaults.set("2", forKey: "Month")
            navigationItem.title = "February " + (String)(defaults.integer(forKey: "Year"))
        }
        else if(Month == "2"){
            defaults.set("3", forKey: "Month")
            navigationItem.title = "March " + (String)(defaults.integer(forKey: "Year"))
        }
        else if(Month == "3"){
            defaults.set("4", forKey: "Month")
            navigationItem.title = "April " + (String)(defaults.integer(forKey: "Year"))
        }
        else if(Month == "4"){
            defaults.set("5", forKey: "Month")
            navigationItem.title = "May " + (String)(defaults.integer(forKey: "Year"))
        }
        else if(Month == "5"){
            defaults.set("6", forKey: "Month")
            navigationItem.title = "June " + (String)(defaults.integer(forKey: "Year"))
        }
        else if(Month == "6"){
            defaults.set("7", forKey: "Month")
            navigationItem.title = "July " + (String)(defaults.integer(forKey: "Year"))
        }
        else if(Month == "7"){
            defaults.set("8", forKey: "Month")
            navigationItem.title = "August " + (String)(defaults.integer(forKey: "Year"))
        }
        else if(Month == "8"){
            defaults.set("9", forKey: "Month")
            navigationItem.title = "September " + (String)(defaults.integer(forKey: "Year"))
        }
        else if(Month == "9"){
            defaults.set("10", forKey: "Month")
            navigationItem.title = "October " + (String)(defaults.integer(forKey: "Year"))
        }
        else if(Month == "10"){
            defaults.set("11", forKey: "Month")
            navigationItem.title = "November " + (String)(defaults.integer(forKey: "Year"))
        }
        else if(Month == "11"){
            defaults.set("12", forKey: "Month")
            navigationItem.title = "December " + (String)(defaults.integer(forKey: "Year"))
        }
        else if(Month == "12"){
            defaults.set("1", forKey: "Month")
            defaults.set(defaults.integer(forKey: "Year") + 1, forKey: "Year")
            navigationItem.title = "January " + (String)(defaults.integer(forKey: "Year"))
        }
        setStartDate(lastDay)
        
    }
    
    func start(){
        
        GetDay()
        
        let defaults = UserDefaults.standard
        let Month = (String)(describing: defaults.object(forKey: "Month")!)
        
        if(Month == "1"){
            navigationItem.title = "January " + (String)(defaults.integer(forKey: "Year"))
        }
        else if(Month == "2"){
            navigationItem.title = "February " + (String)(defaults.integer(forKey: "Year"))
        }
        else if(Month == "3"){
            navigationItem.title = "March " + (String)(defaults.integer(forKey: "Year"))
        }
        else if(Month == "4"){
            navigationItem.title = "April " + (String)(defaults.integer(forKey: "Year"))
        }
        else if(Month == "5"){
            navigationItem.title = "May " + (String)(defaults.integer(forKey: "Year"))
        }
        else if(Month == "6"){
            navigationItem.title = "June " + (String)(defaults.integer(forKey: "Year"))
        }
        else if(Month == "7"){
            navigationItem.title = "July " + (String)(defaults.integer(forKey: "Year"))
        }
        else if(Month == "8"){
            navigationItem.title = "August " + (String)(defaults.integer(forKey: "Year"))
        }
        else if(Month == "9"){
            navigationItem.title = "September " + (String)(defaults.integer(forKey: "Year"))
        }
        else if(Month == "10"){
            navigationItem.title = "October " + (String)(defaults.integer(forKey: "Year"))
        }
        else if(Month == "11"){
            navigationItem.title = "November " + (String)(defaults.integer(forKey: "Year"))
        }
        else if(Month == "12"){
            navigationItem.title = "December " + (String)(defaults.integer(forKey: "Year"))
        }
    }
    
    @IBAction func ShowPopUp(_ sender: UIButton) {
        
        let defaults = UserDefaults.standard
        defaults.set("\(defaults.object(forKey: "Month")!)_\((sender.titleLabel?.text)!)_\(defaults.integer(forKey: "Year"))", forKey: "Date")
        
        let popUpViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PopUpID") as! PopUpViewController
        self.addChildViewController(popUpViewController)
        popUpViewController.view.frame = self.view.frame
        self.view.addSubview(popUpViewController.view)
        popUpViewController.didMove(toParentViewController: self)
    }
    
    func GetDay() {
        let defaults = UserDefaults.standard
        getDay()
        
        let dif = defaults.integer(forKey: "Day of Month") - 1
        let originalDay = getOriginalDay(dif)
        
        for _ in 0...1 {
            if("Sun" == originalDay){
                Button1.setTitle("1", for: UIControlState.normal)
                addDays("Sun")
                firstDay = "Sat"
                break
            }
            else if("Sun" != originalDay){
                Button1.isHidden = true
            }
            if("Mon" == originalDay){
                Button2.setTitle("1", for: UIControlState.normal)
                addDays("Mon")
                firstDay = "Sun"
                break
            }
            else if("Mon" != originalDay){
                Button2.isHidden = true
            }
            if("Tue" == originalDay){
                Button3.setTitle("1", for: UIControlState.normal)
                addDays("Tue")
                firstDay = "Mon"
                break
            }
            else if("Tue" != originalDay){
                Button3.isHidden = true
            }
            if("Wed" == originalDay){
                Button4.setTitle("1", for: UIControlState.normal)
                addDays("Tue")
                firstDay = "Tue"
                break
            }
            else if("Wed" != originalDay){
                Button4.isHidden = true
            }
            if("Thu" == originalDay){
                Button5.setTitle("1", for: UIControlState.normal)
                addDays("Thu")
                firstDay = "Wed"
                break
            }
            else if("Thu" != originalDay){
                Button5.isHidden = true
            }
            if("Fri" == originalDay){
                Button6.setTitle("1", for: UIControlState.normal)
                addDays("Fri")
                firstDay = "Thu"
                break
            }
            else if("Fri" != originalDay){
                Button6.isHidden = true
            }
            if("Sat" == originalDay){
                Button7.setTitle("1", for: UIControlState.normal)
                addDays("Sat")
                firstDay = "Fri"
                break
            }
            else if("Sat" != originalDay){
                Button7.isHidden = true
            }
        }
        
    }
    
    func setStartDate(_ originalDay: String) {
        for _ in 0...1 {
            if("Sat" == originalDay){
                Button1.setTitle("1", for: UIControlState.normal)
                addDays("Sun")
                firstDay = "Sat"
                break
            }
            if("Sun" == originalDay){
                Button2.setTitle("1", for: UIControlState.normal)
                Button1.isHidden = true
                addDays("Mon")
                firstDay = "Sun"
                break
            }
            else if("Sun" != originalDay){
                Button1.isHidden = true
            }
            if("Mon" == originalDay){
                Button3.setTitle("1", for: UIControlState.normal)
                Button2.isHidden = true
                addDays("Tue")
                firstDay = "Mon"
                break
            }
            else if("Mon" != originalDay){
                Button2.isHidden = true
            }
            if("Tue" == originalDay){
                Button4.setTitle("1", for: UIControlState.normal)
                Button3.isHidden = true
                addDays("Wed")
                firstDay = "Tue"
                break
            }
            else if("Tue" != originalDay){
                Button3.isHidden = true
            }
            if("Wed" == originalDay){
                Button5.setTitle("1", for: UIControlState.normal)
                Button4.isHidden = true
                addDays("Thu")
                firstDay = "Wed"
                break
            }
            else if("Wed" != originalDay){
                Button4.isHidden = true
            }
            if("Thu" == originalDay){
                Button6.setTitle("1", for: UIControlState.normal)
                Button5.isHidden = true
                addDays("Fri")
                firstDay = "Thu"
                break
            }
            else if("Thu" != originalDay){
                Button5.isHidden = true
            }
            if("Fri" == originalDay){
                Button7.setTitle("1", for: UIControlState.normal)
                Button6.isHidden = true
                addDays("Sat")
                firstDay = "Fri"
                break
            }
            else if("Fri" != originalDay){
                Button6.isHidden = true
            }
        }
    }
    
    func unHide(){
        Button1.isHidden = false
        Button2.isHidden = false
        Button3.isHidden = false
        Button4.isHidden = false
        Button5.isHidden = false
        Button6.isHidden = false
        Button7.isHidden = false
        Button8.isHidden = false
        Button9.isHidden = false
        Button10.isHidden = false
        Button11.isHidden = false
        Button12.isHidden = false
        Button13.isHidden = false
        Button14.isHidden = false
        Button15.isHidden = false
        Button16.isHidden = false
        Button17.isHidden = false
        Button18.isHidden = false
        Button19.isHidden = false
        Button20.isHidden = false
        Button21.isHidden = false
        Button22.isHidden = false
        Button23.isHidden = false
        Button24.isHidden = false
        Button25.isHidden = false
        Button26.isHidden = false
        Button27.isHidden = false
        Button28.isHidden = false
        Button29.isHidden = false
        Button30.isHidden = false
        Button31.isHidden = false
        Button32.isHidden = false
        Button33.isHidden = false
        Button34.isHidden = false
        Button35.isHidden = false
        Button36.isHidden = false
        Button37.isHidden = false
    }
    
    func getDay(){
        let date = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat  = "EE"
        let dayInWeek = dateFormatter.string(from: date as Date)
        let cal = Calendar.current
        let components = cal.dateComponents([.year, .month, .day], from: date as Date)
        let day = components.day
        let month = cal.component(.month, from: date as Date)
        let defaults = UserDefaults.standard
        defaults.set(dayInWeek, forKey: "Weekday")
        defaults.set(day!, forKey: "Day of Month")
        defaults.set(month, forKey: "Month")
        defaults.set(components.year!, forKey: "Year")
        defaults.synchronize()
    }
    
    func getOriginalDay(_ dif: Int) -> String{
        let defaults = UserDefaults.standard
        var date = defaults.object(forKey: "Weekday")!
        var difference = dif
        
        while(difference != 0){
            if((String)(describing: date) == "Mon"){
                date = "Sun"
            }
            else if((String)(describing: date) == "Tue"){
                date = "Mon"
            }
            else if((String)(describing: date) == "Wed"){
                date = "Tue"
            }
            else if((String)(describing: date) == "Thu"){
                date = "Wed"
            }
            else if((String)(describing: date) == "Fri"){
                date = "Thu"
            }
            else if((String)(describing: date) == "Sat"){
                date = "Fri"
            }
            else if((String)(describing: date) == "Sun"){
                date = "Sat"
            }
            difference = difference - 1
        }
        return date as! String
        
    }
    
    func getOriginalDay(_ dif: Int, _ date: String) -> String{ // Use last date for date and dif is equal to days in month
        var difference = dif
        var returnDate = date
        
        while(difference != 0){
            if(returnDate == "Mon"){
                returnDate = "Sun"
            }
            else if(returnDate == "Tue"){
                returnDate = "Mon"
            }
            else if(returnDate == "Wed"){
                returnDate = "Tue"
            }
            else if(returnDate == "Thu"){
                returnDate = "Wed"
            }
            else if(returnDate == "Fri"){
                returnDate = "Thu"
            }
            else if(returnDate == "Sat"){
                returnDate = "Fri"
            }
            else if(returnDate == "Sun"){
                returnDate = "Sat"
            }
            difference = difference - 1
        }
        return returnDate
        
    }
    
    func addDays(_ startDate: String){
        let defaults = UserDefaults.standard
        
        if(startDate=="Mon"){
            Button3.setTitle("2", for: UIControlState.normal)
            Button4.setTitle("3", for: UIControlState.normal)
            Button5.setTitle("4", for: UIControlState.normal)
            Button6.setTitle("5", for: UIControlState.normal)
            Button7.setTitle("6", for: UIControlState.normal)
            Button8.setTitle("7", for: UIControlState.normal)
            Button9.setTitle("8", for: UIControlState.normal)
            Button10.setTitle("9", for: UIControlState.normal)
            Button11.setTitle("10", for: UIControlState.normal)
            Button12.setTitle("11", for: UIControlState.normal)
            Button13.setTitle("12", for: UIControlState.normal)
            Button14.setTitle("13", for: UIControlState.normal)
            Button15.setTitle("14", for: UIControlState.normal)
            Button16.setTitle("15", for: UIControlState.normal)
            Button17.setTitle("16", for: UIControlState.normal)
            Button18.setTitle("17", for: UIControlState.normal)
            Button19.setTitle("18", for: UIControlState.normal)
            Button20.setTitle("19", for: UIControlState.normal)
            Button21.setTitle("20", for: UIControlState.normal)
            Button22.setTitle("21", for: UIControlState.normal)
            Button23.setTitle("22", for: UIControlState.normal)
            Button24.setTitle("23", for: UIControlState.normal)
            Button25.setTitle("24", for: UIControlState.normal)
            Button26.setTitle("25", for: UIControlState.normal)
            Button27.setTitle("26", for: UIControlState.normal)
            Button28.setTitle("27", for: UIControlState.normal)
            Button29.setTitle("28", for: UIControlState.normal)
            
            if((String)(describing: defaults.object(forKey: "Month")!) == "2"){
                Button30.isHidden = true
                Button31.isHidden = true
                Button32.isHidden = true
                Button33.isHidden = true
                Button34.isHidden = true
                Button35.isHidden = true
                Button36.isHidden = true
                Button37.isHidden = true
                dayNum = 31
                lastDay = "Sun"
            }
            else if((String)(describing: defaults.object(forKey: "Month")!) == "4" || (String)(describing: defaults.object(forKey: "Month")!) == "6" || (String)(describing: defaults.object(forKey: "Month")!) == "9" || (String)(describing: defaults.object(forKey: "Month")!) == "11"){
                
                Button30.setTitle("29", for: UIControlState.normal)
                Button31.setTitle("30", for: UIControlState.normal)
                Button32.isHidden = true
                Button33.isHidden = true
                Button34.isHidden = true
                Button35.isHidden = true
                Button36.isHidden = true
                Button37.isHidden = true
                dayNum = 31
                lastDay = "Tue"
            }
            else if((String)(describing: defaults.object(forKey: "Month")!) == "1" || (String)(describing: defaults.object(forKey: "Month")!) == "3" || (String)(describing: defaults.object(forKey: "Month")!) == "5" || (String)(describing: defaults.object(forKey: "Month")!) == "7" || (String)(describing: defaults.object(forKey: "Month")!) == "8" || (String)(describing: defaults.object(forKey: "Month")!) == "10" || (String)(describing: defaults.object(forKey: "Month")!) == "12"){
                
                Button30.setTitle("29", for: UIControlState.normal)
                Button31.setTitle("30", for: UIControlState.normal)
                Button32.setTitle("31", for: UIControlState.normal)
                Button33.isHidden = true
                Button34.isHidden = true
                Button35.isHidden = true
                Button36.isHidden = true
                Button37.isHidden = true
                if((String)(describing: defaults.object(forKey: "Month")!) == "1" || (String)(describing: defaults.object(forKey: "Month")!) == "8"){
                    dayNum = 31
                }
                else if((String)(describing: defaults.object(forKey: "Month")!) == "3"){
                    dayNum = 28
                }
                else{
                    dayNum = 30
                }
                lastDay = "Wed"
            }
        }
        if(startDate=="Tue"){
            Button4.setTitle("2", for: UIControlState.normal)
            Button5.setTitle("3", for: UIControlState.normal)
            Button6.setTitle("4", for: UIControlState.normal)
            Button7.setTitle("5", for: UIControlState.normal)
            Button8.setTitle("6", for: UIControlState.normal)
            Button9.setTitle("7", for: UIControlState.normal)
            Button10.setTitle("8", for: UIControlState.normal)
            Button11.setTitle("9", for: UIControlState.normal)
            Button12.setTitle("10", for: UIControlState.normal)
            Button13.setTitle("11", for: UIControlState.normal)
            Button14.setTitle("12", for: UIControlState.normal)
            Button15.setTitle("13", for: UIControlState.normal)
            Button16.setTitle("14", for: UIControlState.normal)
            Button17.setTitle("15", for: UIControlState.normal)
            Button18.setTitle("16", for: UIControlState.normal)
            Button19.setTitle("17", for: UIControlState.normal)
            Button20.setTitle("18", for: UIControlState.normal)
            Button21.setTitle("19", for: UIControlState.normal)
            Button22.setTitle("20", for: UIControlState.normal)
            Button23.setTitle("21", for: UIControlState.normal)
            Button24.setTitle("22", for: UIControlState.normal)
            Button25.setTitle("23", for: UIControlState.normal)
            Button26.setTitle("24", for: UIControlState.normal)
            Button27.setTitle("25", for: UIControlState.normal)
            Button28.setTitle("26", for: UIControlState.normal)
            Button29.setTitle("27", for: UIControlState.normal)
            Button30.setTitle("28", for: UIControlState.normal)
            
            if((String)(describing: defaults.object(forKey: "Month")!) == "2"){
                Button31.isHidden = true
                Button32.isHidden = true
                Button33.isHidden = true
                Button34.isHidden = true
                Button35.isHidden = true
                Button36.isHidden = true
                Button37.isHidden = true
                dayNum = 31
                lastDay = "Mon"
            }
            else if((String)(describing: defaults.object(forKey: "Month")!) == "4" || (String)(describing: defaults.object(forKey: "Month")!) == "6" || (String)(describing: defaults.object(forKey: "Month")!) == "9" || (String)(describing: defaults.object(forKey: "Month")!) == "11"){
                
                Button31.setTitle("29", for: UIControlState.normal)
                Button32.setTitle("30", for: UIControlState.normal)
                Button33.isHidden = true
                Button34.isHidden = true
                Button35.isHidden = true
                Button36.isHidden = true
                Button37.isHidden = true
                dayNum = 31
                lastDay = "Wed"
            }
            else if((String)(describing: defaults.object(forKey: "Month")!) == "1" || (String)(describing: defaults.object(forKey: "Month")!) == "3" || (String)(describing: defaults.object(forKey: "Month")!) == "5" || (String)(describing: defaults.object(forKey: "Month")!) == "7" || (String)(describing: defaults.object(forKey: "Month")!) == "8" || (String)(describing: defaults.object(forKey: "Month")!) == "10" || (String)(describing: defaults.object(forKey: "Month")!) == "12"){
                
                Button31.setTitle("29", for: UIControlState.normal)
                Button32.setTitle("30", for: UIControlState.normal)
                Button33.setTitle("31", for: UIControlState.normal)
                Button34.isHidden = true
                Button35.isHidden = true
                Button36.isHidden = true
                Button37.isHidden = true
                if((String)(describing: defaults.object(forKey: "Month")!) == "1" || (String)(describing: defaults.object(forKey: "Month")!) == "8"){
                    dayNum = 31
                }
                else if((String)(describing: defaults.object(forKey: "Month")!) == "3"){
                    dayNum = 28
                }
                else{
                    dayNum = 30
                }
                lastDay = "Thu"
            }
        }
        if(startDate=="Wed"){
            Button5.setTitle("2", for: UIControlState.normal)
            Button6.setTitle("3", for: UIControlState.normal)
            Button7.setTitle("4", for: UIControlState.normal)
            Button8.setTitle("5", for: UIControlState.normal)
            Button9.setTitle("6", for: UIControlState.normal)
            Button10.setTitle("7", for: UIControlState.normal)
            Button11.setTitle("8", for: UIControlState.normal)
            Button12.setTitle("9", for: UIControlState.normal)
            Button13.setTitle("10", for: UIControlState.normal)
            Button14.setTitle("11", for: UIControlState.normal)
            Button15.setTitle("12", for: UIControlState.normal)
            Button16.setTitle("13", for: UIControlState.normal)
            Button17.setTitle("14", for: UIControlState.normal)
            Button18.setTitle("15", for: UIControlState.normal)
            Button19.setTitle("16", for: UIControlState.normal)
            Button20.setTitle("17", for: UIControlState.normal)
            Button21.setTitle("18", for: UIControlState.normal)
            Button22.setTitle("19", for: UIControlState.normal)
            Button23.setTitle("20", for: UIControlState.normal)
            Button24.setTitle("21", for: UIControlState.normal)
            Button25.setTitle("22", for: UIControlState.normal)
            Button26.setTitle("23", for: UIControlState.normal)
            Button27.setTitle("24", for: UIControlState.normal)
            Button28.setTitle("25", for: UIControlState.normal)
            Button29.setTitle("26", for: UIControlState.normal)
            Button30.setTitle("27", for: UIControlState.normal)
            Button31.setTitle("28", for: UIControlState.normal)
            
            if((String)(describing: defaults.object(forKey: "Month")!) == "2"){
                Button32.isHidden = true
                Button33.isHidden = true
                Button34.isHidden = true
                Button35.isHidden = true
                Button36.isHidden = true
                Button37.isHidden = true
                dayNum = 31
                lastDay = "Tue"
            }
            else if((String)(describing: defaults.object(forKey: "Month")!) == "4" || (String)(describing: defaults.object(forKey: "Month")!) == "6" || (String)(describing: defaults.object(forKey: "Month")!) == "9" || (String)(describing: defaults.object(forKey: "Month")!) == "11"){
                
                Button32.setTitle("29", for: UIControlState.normal)
                Button33.setTitle("30", for: UIControlState.normal)
                Button34.isHidden = true
                Button35.isHidden = true
                Button36.isHidden = true
                Button37.isHidden = true
                dayNum = 31
                lastDay = "Thu"
            }
            else if((String)(describing: defaults.object(forKey: "Month")!) == "1" || (String)(describing: defaults.object(forKey: "Month")!) == "3" || (String)(describing: defaults.object(forKey: "Month")!) == "5" || (String)(describing: defaults.object(forKey: "Month")!) == "7" || (String)(describing: defaults.object(forKey: "Month")!) == "8" || (String)(describing: defaults.object(forKey: "Month")!) == "10" || (String)(describing: defaults.object(forKey: "Month")!) == "12"){
                
                Button32.setTitle("29", for: UIControlState.normal)
                Button33.setTitle("30", for: UIControlState.normal)
                Button34.setTitle("31", for: UIControlState.normal)
                Button35.isHidden = true
                Button36.isHidden = true
                Button37.isHidden = true
                if((String)(describing: defaults.object(forKey: "Month")!) == "1" || (String)(describing: defaults.object(forKey: "Month")!) == "8"){
                    dayNum = 31
                }
                else if((String)(describing: defaults.object(forKey: "Month")!) == "3"){
                    dayNum = 28
                }
                else{
                    dayNum = 30
                }
                lastDay = "Fri"
            }
        }
        if(startDate=="Thu"){
            Button6.setTitle("2", for: UIControlState.normal)
            Button7.setTitle("3", for: UIControlState.normal)
            Button8.setTitle("4", for: UIControlState.normal)
            Button9.setTitle("5", for: UIControlState.normal)
            Button10.setTitle("6", for: UIControlState.normal)
            Button11.setTitle("7", for: UIControlState.normal)
            Button12.setTitle("8", for: UIControlState.normal)
            Button13.setTitle("9", for: UIControlState.normal)
            Button14.setTitle("10", for: UIControlState.normal)
            Button15.setTitle("11", for: UIControlState.normal)
            Button16.setTitle("12", for: UIControlState.normal)
            Button17.setTitle("13", for: UIControlState.normal)
            Button18.setTitle("14", for: UIControlState.normal)
            Button19.setTitle("15", for: UIControlState.normal)
            Button20.setTitle("16", for: UIControlState.normal)
            Button21.setTitle("17", for: UIControlState.normal)
            Button22.setTitle("18", for: UIControlState.normal)
            Button23.setTitle("19", for: UIControlState.normal)
            Button24.setTitle("20", for: UIControlState.normal)
            Button25.setTitle("21", for: UIControlState.normal)
            Button26.setTitle("22", for: UIControlState.normal)
            Button27.setTitle("23", for: UIControlState.normal)
            Button28.setTitle("24", for: UIControlState.normal)
            Button29.setTitle("25", for: UIControlState.normal)
            Button30.setTitle("26", for: UIControlState.normal)
            Button31.setTitle("27", for: UIControlState.normal)
            Button32.setTitle("28", for: UIControlState.normal)
            
            if((String)(describing: defaults.object(forKey: "Month")!) == "2"){
                Button33.isHidden = true
                Button34.isHidden = true
                Button35.isHidden = true
                Button36.isHidden = true
                Button37.isHidden = true
                dayNum = 31
                lastDay = "Wed"
            }
            else if((String)(describing: defaults.object(forKey: "Month")!) == "4" || (String)(describing: defaults.object(forKey: "Month")!) == "6" || (String)(describing: defaults.object(forKey: "Month")!) == "9" || (String)(describing: defaults.object(forKey: "Month")!) == "11"){
                
                Button33.setTitle("29", for: UIControlState.normal)
                Button34.setTitle("30", for: UIControlState.normal)
                Button35.isHidden = true
                Button36.isHidden = true
                Button37.isHidden = true
                dayNum = 31
                lastDay = "Fri"
            }
            else if((String)(describing: defaults.object(forKey: "Month")!) == "1" || (String)(describing: defaults.object(forKey: "Month")!) == "3" || (String)(describing: defaults.object(forKey: "Month")!) == "5" || (String)(describing: defaults.object(forKey: "Month")!) == "7" || (String)(describing: defaults.object(forKey: "Month")!) == "8" || (String)(describing: defaults.object(forKey: "Month")!) == "10" || (String)(describing: defaults.object(forKey: "Month")!) == "12"){
                
                Button33.setTitle("29", for: UIControlState.normal)
                Button34.setTitle("30", for: UIControlState.normal)
                Button35.setTitle("31", for: UIControlState.normal)
                Button36.isHidden = true
                Button37.isHidden = true
                if((String)(describing: defaults.object(forKey: "Month")!) == "1" || (String)(describing: defaults.object(forKey: "Month")!) == "8"){
                    dayNum = 31
                }
                else if((String)(describing: defaults.object(forKey: "Month")!) == "3"){
                    dayNum = 28
                }
                else{
                    dayNum = 30
                }
                lastDay = "Sat"
            }
        }
        if(startDate=="Fri"){
            Button7.setTitle("2", for: UIControlState.normal)
            Button8.setTitle("3", for: UIControlState.normal)
            Button9.setTitle("4", for: UIControlState.normal)
            Button10.setTitle("5", for: UIControlState.normal)
            Button11.setTitle("6", for: UIControlState.normal)
            Button12.setTitle("7", for: UIControlState.normal)
            Button13.setTitle("8", for: UIControlState.normal)
            Button14.setTitle("9", for: UIControlState.normal)
            Button15.setTitle("10", for: UIControlState.normal)
            Button16.setTitle("11", for: UIControlState.normal)
            Button17.setTitle("12", for: UIControlState.normal)
            Button18.setTitle("13", for: UIControlState.normal)
            Button19.setTitle("14", for: UIControlState.normal)
            Button20.setTitle("15", for: UIControlState.normal)
            Button21.setTitle("16", for: UIControlState.normal)
            Button22.setTitle("17", for: UIControlState.normal)
            Button23.setTitle("18", for: UIControlState.normal)
            Button24.setTitle("19", for: UIControlState.normal)
            Button25.setTitle("20", for: UIControlState.normal)
            Button26.setTitle("21", for: UIControlState.normal)
            Button27.setTitle("22", for: UIControlState.normal)
            Button28.setTitle("23", for: UIControlState.normal)
            Button29.setTitle("24", for: UIControlState.normal)
            Button30.setTitle("25", for: UIControlState.normal)
            Button31.setTitle("26", for: UIControlState.normal)
            Button32.setTitle("27", for: UIControlState.normal)
            Button33.setTitle("28", for: UIControlState.normal)
            
            if((String)(describing: defaults.object(forKey: "Month")!) == "2"){
                Button34.isHidden = true
                Button35.isHidden = true
                Button36.isHidden = true
                Button37.isHidden = true
                dayNum = 31
                lastDay = "Thu"
            }
            else if((String)(describing: defaults.object(forKey: "Month")!) == "4" || (String)(describing: defaults.object(forKey: "Month")!) == "6" || (String)(describing: defaults.object(forKey: "Month")!) == "9" || (String)(describing: defaults.object(forKey: "Month")!) == "11"){
                
                Button34.setTitle("29", for: UIControlState.normal)
                Button35.setTitle("30", for: UIControlState.normal)
                Button36.isHidden = true
                Button37.isHidden = true
                dayNum = 31
                lastDay = "Sat"
            }
            else if((String)(describing: defaults.object(forKey: "Month")!) == "1" || (String)(describing: defaults.object(forKey: "Month")!) == "3" || (String)(describing: defaults.object(forKey: "Month")!) == "5" || (String)(describing: defaults.object(forKey: "Month")!) == "7" || (String)(describing: defaults.object(forKey: "Month")!) == "8" || (String)(describing: defaults.object(forKey: "Month")!) == "10" || (String)(describing: defaults.object(forKey: "Month")!) == "12"){
                
                Button34.setTitle("29", for: UIControlState.normal)
                Button35.setTitle("30", for: UIControlState.normal)
                Button36.setTitle("31", for: UIControlState.normal)
                Button37.isHidden = true
                if((String)(describing: defaults.object(forKey: "Month")!) == "1" || (String)(describing: defaults.object(forKey: "Month")!) == "8"){
                    dayNum = 31
                }
                else if((String)(describing: defaults.object(forKey: "Month")!) == "3"){
                    dayNum = 28
                }
                else{
                    dayNum = 30
                }
                lastDay = "Sun"
            }
        }
        if(startDate=="Sat"){
            Button8.setTitle("2", for: UIControlState.normal)
            Button9.setTitle("3", for: UIControlState.normal)
            Button10.setTitle("4", for: UIControlState.normal)
            Button11.setTitle("5", for: UIControlState.normal)
            Button12.setTitle("6", for: UIControlState.normal)
            Button13.setTitle("7", for: UIControlState.normal)
            Button14.setTitle("8", for: UIControlState.normal)
            Button15.setTitle("9", for: UIControlState.normal)
            Button16.setTitle("10", for: UIControlState.normal)
            Button17.setTitle("11", for: UIControlState.normal)
            Button18.setTitle("12", for: UIControlState.normal)
            Button19.setTitle("13", for: UIControlState.normal)
            Button20.setTitle("14", for: UIControlState.normal)
            Button21.setTitle("15", for: UIControlState.normal)
            Button22.setTitle("16", for: UIControlState.normal)
            Button23.setTitle("17", for: UIControlState.normal)
            Button24.setTitle("18", for: UIControlState.normal)
            Button25.setTitle("19", for: UIControlState.normal)
            Button26.setTitle("20", for: UIControlState.normal)
            Button27.setTitle("21", for: UIControlState.normal)
            Button28.setTitle("22", for: UIControlState.normal)
            Button29.setTitle("23", for: UIControlState.normal)
            Button30.setTitle("24", for: UIControlState.normal)
            Button31.setTitle("25", for: UIControlState.normal)
            Button32.setTitle("26", for: UIControlState.normal)
            Button33.setTitle("27", for: UIControlState.normal)
            Button34.setTitle("28", for: UIControlState.normal)
            
            if((String)(describing: defaults.object(forKey: "Month")!) == "2"){
                Button35.isHidden = true
                Button36.isHidden = true
                Button37.isHidden = true
                dayNum = 31
                lastDay = "Fri"
            }
            else if((String)(describing: defaults.object(forKey: "Month")!) == "4" || (String)(describing: defaults.object(forKey: "Month")!) == "6" || (String)(describing: defaults.object(forKey: "Month")!) == "9" || (String)(describing: defaults.object(forKey: "Month")!) == "11"){
                
                Button35.setTitle("29", for: UIControlState.normal)
                Button36.setTitle("30", for: UIControlState.normal)
                Button37.isHidden = true
                dayNum = 31
                lastDay = "Sun"
            }
            else if((String)(describing: defaults.object(forKey: "Month")!) == "1" || (String)(describing: defaults.object(forKey: "Month")!) == "3" || (String)(describing: defaults.object(forKey: "Month")!) == "5" || (String)(describing: defaults.object(forKey: "Month")!) == "7" || (String)(describing: defaults.object(forKey: "Month")!) == "8" || (String)(describing: defaults.object(forKey: "Month")!) == "10" || (String)(describing: defaults.object(forKey: "Month")!) == "12"){
                
                Button35.setTitle("29", for: UIControlState.normal)
                Button36.setTitle("30", for: UIControlState.normal)
                Button37.setTitle("31", for: UIControlState.normal)
                if((String)(describing: defaults.object(forKey: "Month")!) == "1" || (String)(describing: defaults.object(forKey: "Month")!) == "8"){
                    dayNum = 31
                }
                else if((String)(describing: defaults.object(forKey: "Month")!) == "3"){
                    dayNum = 28
                }
                else{
                    dayNum = 30
                }
                lastDay = "Mon"
            }
        }
        if(startDate=="Sun"){
            Button2.setTitle("2", for: UIControlState.normal)
            Button3.setTitle("3", for: UIControlState.normal)
            Button4.setTitle("4", for: UIControlState.normal)
            Button5.setTitle("5", for: UIControlState.normal)
            Button6.setTitle("6", for: UIControlState.normal)
            Button7.setTitle("7", for: UIControlState.normal)
            Button8.setTitle("8", for: UIControlState.normal)
            Button9.setTitle("9", for: UIControlState.normal)
            Button10.setTitle("10", for: UIControlState.normal)
            Button11.setTitle("11", for: UIControlState.normal)
            Button12.setTitle("12", for: UIControlState.normal)
            Button13.setTitle("13", for: UIControlState.normal)
            Button14.setTitle("14", for: UIControlState.normal)
            Button15.setTitle("15", for: UIControlState.normal)
            Button16.setTitle("16", for: UIControlState.normal)
            Button17.setTitle("17", for: UIControlState.normal)
            Button18.setTitle("18", for: UIControlState.normal)
            Button19.setTitle("19", for: UIControlState.normal)
            Button20.setTitle("20", for: UIControlState.normal)
            Button21.setTitle("21", for: UIControlState.normal)
            Button22.setTitle("22", for: UIControlState.normal)
            Button23.setTitle("23", for: UIControlState.normal)
            Button24.setTitle("24", for: UIControlState.normal)
            Button25.setTitle("25", for: UIControlState.normal)
            Button26.setTitle("26", for: UIControlState.normal)
            Button27.setTitle("27", for: UIControlState.normal)
            Button28.setTitle("28", for: UIControlState.normal)
            
            if((String)(describing: defaults.object(forKey: "Month")!) == "2"){
                Button29.isHidden = true
                Button30.isHidden = true
                Button30.isHidden = true
                Button31.isHidden = true
                Button32.isHidden = true
                Button33.isHidden = true
                Button34.isHidden = true
                Button35.isHidden = true
                Button36.isHidden = true
                Button37.isHidden = true
                dayNum = 31
                lastDay = "Sat"
            }
            else if((String)(describing: defaults.object(forKey: "Month")!) == "4" || (String)(describing: defaults.object(forKey: "Month")!) == "6" || (String)(describing: defaults.object(forKey: "Month")!) == "9" || (String)(describing: defaults.object(forKey: "Month")!) == "11"){
                
                Button29.setTitle("29", for: UIControlState.normal)
                Button30.setTitle("30", for: UIControlState.normal)
                Button31.isHidden = true
                Button32.isHidden = true
                Button33.isHidden = true
                Button34.isHidden = true
                Button35.isHidden = true
                Button36.isHidden = true
                Button37.isHidden = true
                dayNum = 31
                lastDay = "Mon"
            }
            else if((String)(describing: defaults.object(forKey: "Month")!) == "1" || (String)(describing: defaults.object(forKey: "Month")!) == "3" || (String)(describing: defaults.object(forKey: "Month")!) == "5" || (String)(describing: defaults.object(forKey: "Month")!) == "7" || (String)(describing: defaults.object(forKey: "Month")!) == "8" || (String)(describing: defaults.object(forKey: "Month")!) == "10" || (String)(describing: defaults.object(forKey: "Month")!) == "12"){
                
                Button29.setTitle("29", for: UIControlState.normal)
                Button30.setTitle("30", for: UIControlState.normal)
                Button31.setTitle("31", for: UIControlState.normal)
                Button32.isHidden = true
                Button33.isHidden = true
                Button34.isHidden = true
                Button35.isHidden = true
                Button36.isHidden = true
                Button37.isHidden = true
                if((String)(describing: defaults.object(forKey: "Month")!) == "1" || (String)(describing: defaults.object(forKey: "Month")!) == "8"){
                    dayNum = 31
                }
                else if((String)(describing: defaults.object(forKey: "Month")!) == "3"){
                    dayNum = 28
                }
                else{
                    dayNum = 30
                }
                lastDay = "Tue"
            }
        }
    }
}
