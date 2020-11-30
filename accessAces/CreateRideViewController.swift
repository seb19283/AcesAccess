//
//  CreateRideViewController.swift
//  accessAces
//
//  Created by Sebastian on 8/14/17.
//  Copyright © 2017 NewWave. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class CreateRideViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {

    
    @IBOutlet var eventDate: UIDatePicker!
    @IBOutlet var chooseEventTextLabel: UITextField!
    @IBOutlet var dropDownMenu: UIPickerView!
    @IBOutlet var peopleInCar: UITextField!
    @IBOutlet var locationTableView: UITableView!
    @IBOutlet var timeTextField: UITextField!
    @IBOutlet var am_pmPicker: UISegmentedControl!
    
    var events: [String] = ["Choose an event"]
    var times: [String] = [""]
    var locations = ["Merion/Narberth", "Bala Cynwyd", "Ardmore/Wynnewood", "Penn Wynne"]
    var selectedDate = String()
    var ref: DatabaseReference?
    var location: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        chooseEventTextLabel.text = "Choose an event"
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func postRide(_ sender: UIBarButtonItem) {
        
        if chooseEventTextLabel.text == "Choose an event" || chooseEventTextLabel.text == "" {
            alertMessage("Please choose an event")
            return
        }else if timeTextField.text == "" || timeTextField.text == nil {
            alertMessage("Please fill in a time")
            return
        } else if peopleInCar.text == "" || peopleInCar.text == nil {
            alertMessage("Please let us know how many people you can fit in your car")
            return
        } else if location.count == 0 {
            alertMessage("Please enter your location")
            return
        }
        
        sender.isEnabled = false
        
        if !events.contains(chooseEventTextLabel.text!) {
            ref?.child("Ride Share Events").child(selectedDate).child(chooseEventTextLabel.text!).setValue(timeTextField.text!)
        }
        
        let timeOfDay: String = am_pmPicker.selectedSegmentIndex == 0 ? "am" : "pm"
        
        ref?.child("Giving Rides").child(chooseEventTextLabel.text!).child("Time").setValue("\(timeTextField.text!) \(timeOfDay)")
        ref?.child("Giving Rides").child(chooseEventTextLabel.text!).child("Date").setValue(selectedDate)
        ref?.child("Giving Rides").child(chooseEventTextLabel.text!).child("Number of People").setValue(peopleInCar.text!)
        ref?.child("Giving Rides").child(chooseEventTextLabel.text!).child("Location").setValue(location)
        ref?.child("Giving Rides").child(chooseEventTextLabel.text!).child("Person").setValue(UserDefaults.standard.string(forKey: "Username"))
        
        sender.isEnabled = true
        
        _ = navigationController?.popViewController(animated: true)
        
    }
    
    func alertMessage(_ message: String){
        let alert = UIAlertController(title: "Ride not completed", message: message, preferredStyle: UIAlertControllerStyle.alert)
        let OK = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        
        alert.addAction(OK)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID")
        
        cell?.textLabel?.text = locations[indexPath.row]
        
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.checkmark
        location.append(locations[indexPath.row])
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.none
        location.remove(at: location.index(of: locations[indexPath.row])!)
        
    }
    
    // PickerView
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return events.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        self.view.endEditing(true)
        return events[row]
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if row == events.count - 1 {
            chooseEventTextLabel.text = ""
            UserDefaults.standard.set(true, forKey: "Creating own event")
        } else {
            chooseEventTextLabel.text = events[row]
            timeTextField.text = times[row]
        }
        
        chooseEventTextLabel.endEditing(false)
        dropDownMenu.isHidden = true
        peopleInCar.isHidden = false
        locationTableView.isHidden = false
        am_pmPicker.isHidden = false
        	
    }
    
    // TextField
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.chooseEventTextLabel && !UserDefaults.standard.bool(forKey: "Creating own event"){
            
            dropDownMenu.isHidden = false
            peopleInCar.isHidden = true
            locationTableView.isHidden = true
            am_pmPicker.isHidden = true
            
            textField.endEditing(true)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/y"
            
            if selectedDate == dateFormatter.string(from: eventDate.date){
                return
            }
            
            selectedDate = dateFormatter.string(from: eventDate.date)
            
            print(selectedDate)
            
            self.ref?.child("Ride Share Events").child(selectedDate).observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    
                    for (event, time) in dictionary {
                        
                        self.events.removeAll()
                        self.events.append("Choose an event")
                        
                        self.events.append(event)
                        
                        self.times.removeAll()
                        self.times.append("")
                        
                        self.times.append(time as! String)
                        
                        DispatchQueue.main.async {
                            
                            self.events.append("Create my own event")
                            self.dropDownMenu.reloadAllComponents()
                            
                        }
                        
                    }
                    
                } else {
                    
                    self.events.removeAll()
                    self.events = ["Choose an event", "Create my own event"]
                    
                    DispatchQueue.main.async {
                        self.dropDownMenu.reloadAllComponents()
                    }
                    
                }
                
            }, withCancel: nil)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UserDefaults.standard.set(false, forKey: "Creating own event")
    }
    
}
