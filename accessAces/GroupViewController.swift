//
//  GroupViewController.swift
//  accessAces
//
//  Created by Sebastian on 6/22/17.
//  Copyright © 2017 NewWave. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

class GroupViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet var pickImageView: UIImageView!
    @IBOutlet var bottomInputContainerViewConstant: NSLayoutConstraint!
    @IBOutlet var inputContainerView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var inputTextField: UITextField!    
    @IBOutlet weak var peopleButton: UIBarButtonItem!
    
    var messages: [Message] = []
    var profileImages: [String: String] = [:]
    
    let cellId = "cellId"
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.keyboardDismissMode = .none
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShowed), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHid), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keboardDidShow), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        
        collectionView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissTappedKeyboard)))
        
        pickImageView.isUserInteractionEnabled = true
        pickImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleShowingImages)))
        
        inputTextField.delegate = self
        
        ref = Database.database().reference()
        
    }
    
    @objc func keboardDidShow() {
        if messages.count > 0 {
            let indexPath = IndexPath(item: messages.count - 1, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .top, animated: true)
        }
    }
    
    @objc func handleShowingImages() {
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImage: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage{
            selectedImage = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            selectedImage = originalImage
        }
        
        if let image = selectedImage{
            uploadToFirebaseStorage(image: image)
        }
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    private func uploadToFirebaseStorage(image: UIImage) {
        
        let ref = Storage.storage().reference()
        let imageName = NSUUID().uuidString
        
        if let data = UIImageJPEGRepresentation(image, 0.2) {
            ref.child("Messages Images").child(imageName).putData(data, metadata: nil, completion: { (metadata, error) in
                
                if error != nil {
                    print("Failed to upload image: ", error)
                    return
                }
                
                if let imageURL = metadata?.downloadURL()?.absoluteString {
                    self.handleSendWithImage(imageURL: imageURL, image: image)
                }
                
            })
        }
        
    }
    
    private func handleSendWithImage(imageURL: String, image: UIImage) {
        
        let fromID = Auth.auth().currentUser!.uid
        let timestamp = NSDate().timeIntervalSince1970 as NSNumber
        let values = ["imageURL": imageURL, "fromID": fromID, "timestamp": timestamp, "imageWidth": image.size.width, "imageHeight": image.size.height] as [String : Any]
        ref.child("Messages").child(UserDefaults.standard.string(forKey: "Current Group")!).childByAutoId().updateChildValues(values)
        
        inputTextField.text = nil
        dismissKeyboard()
    
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func dismissTappedKeyboard(sender: UITapGestureRecognizer){
        dismissKeyboard()
    }
    
    func dismissKeyboard() {
        self.view.endEditing(true)
        self.bottomInputContainerViewConstant.constant = 0
        self.view.layoutIfNeeded()
    }
    
    @objc func keyboardShowed(notification: NSNotification) {
        
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        self.view.layoutIfNeeded()
        
        UIView.animate(withDuration: info[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval, animations: {
            
            self.bottomInputContainerViewConstant.constant = keyboardFrame.height - 50
            self.view.layoutIfNeeded()
            
        }, completion: nil)
        
    }
    
    @objc func keyboardHid(notification: NSNotification) {
        dismissKeyboard()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismissKeyboard()
        return true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if self.navigationItem.title == UserDefaults.standard.string(forKey: "Current Group"){
            return
        }
        
        self.navigationItem.title = UserDefaults.standard.string(forKey: "Current Group")
        
        if self.navigationItem.title == "General" {
            self.navigationItem.rightBarButtonItem = nil
        } else {
            self.navigationItem.rightBarButtonItem = peopleButton
        }
        
        collectionView.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellId)
        
        getProfileImageURL()
        
        ref.child("Messages").child(UserDefaults.standard.string(forKey: "Current Group")!).observe(.childAdded, with: { (snapshot) in
            
            guard let dictionary = snapshot.value as? [String: AnyObject] else {
                return
            }
            
            self.messages.append(Message(dictionary: dictionary))
            
            DispatchQueue.main.async(execute: {
                self.collectionView.reloadData()
                
                let indexPath = IndexPath(item: self.messages.count - 1, section: 0)
                self.collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
                
            })
            
        }, withCancel: nil)
        
    }
    
    func getProfileImageURL() {
        
        Database.database().reference().child("Users").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let children = snapshot.children.allObjects as? [DataSnapshot] {
                for child in children {
                    
                    if let dictionary = child.value as? [String: AnyObject] {
                        self.profileImages[child.key] = dictionary["Profile Image"] as! String
                    }
                    
                    DispatchQueue.main.async(execute: { 
                        self.collectionView.reloadData()
                    })
                    
                }
            }
            
        }, withCancel: nil)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatMessageCell
        
        let message = messages[indexPath.row]
        cell.textView.text = message.text
        
        if message.fromID == Auth.auth().currentUser?.uid {
            cell.bubbleView.backgroundColor = ChatMessageCell.blueColor
            cell.textView.textColor = UIColor.white
            cell.profileImageView.isHidden = true
            cell.bubbleViewLeftAnchor?.isActive = false
            cell.bubbleViewRightAnchor?.isActive = true
        }
        else {
            cell.bubbleView.backgroundColor = UIColor(red: 240/277, green: 240/277, blue: 240/277, alpha: 1)
            cell.textView.textColor = UIColor.black
            cell.profileImageView.isHidden = false
            cell.bubbleViewLeftAnchor?.isActive = true
            cell.bubbleViewRightAnchor?.isActive = false
            
            if let url = profileImages[message.fromID!] {
                cell.profileImageView.loadImageWithCache(url: url)
            }
            
        }
        
        if let imageURL = message.imageURL {
            cell.messageImageView.loadImageWithCache(url: imageURL)
            cell.messageImageView.isHidden = false
            cell.bubbleView.backgroundColor = UIColor.clear
        } else {
            cell.messageImageView.isHidden = true
        }
        
        if let text = message.text {
            cell.bubbleViewWidthAnchor?.constant = estimateFrame(text: text).width + 26
        } else if message.imageURL != nil {
            cell.bubbleViewWidthAnchor?.constant = 200
        }
        

        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height: CGFloat = 0
        
        let message = messages[indexPath.item]
        
        if let text = message.text{
            height = estimateFrame(text: text).height + 17
        } else if let imageWidth = message.imageWidth, let imageHeight = message.imageHeight {
            height = imageHeight / imageWidth * 200
        }
        
        return CGSize(width: view.frame.width, height: height)
    
    }
    
    func estimateFrame(text: String) -> CGRect {
        
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)], context: nil)
        
    }
    
    @IBAction func sendButtonClicked(_ sender: UIButton) {
        
        if inputTextField.text == nil || inputTextField.text == "" {
            return
        }
        
        let fromID = Auth.auth().currentUser!.uid
        let timestamp = NSDate().timeIntervalSince1970 as NSNumber
        let values = ["text": inputTextField.text!, "fromID": fromID, "timestamp": timestamp] as [String : Any]
        ref.child("Messages").child(UserDefaults.standard.string(forKey: "Current Group")!).childByAutoId().updateChildValues(values)
        
        inputTextField.text = nil
        dismissKeyboard()
    }
    
}
