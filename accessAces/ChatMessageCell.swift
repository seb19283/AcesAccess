//
//  ChatMessageCell.swift
//  accessAces
//
//  Created by Sebastian on 7/31/17.
//  Copyright © 2017 NewWave. All rights reserved.
//

import UIKit

class ChatMessageCell: UICollectionViewCell {
    
    var bubbleViewWidthAnchor: NSLayoutConstraint?
    var bubbleViewLeftAnchor: NSLayoutConstraint?
    var bubbleViewRightAnchor: NSLayoutConstraint?
    
    static let blueColor = UIColor(red: 0/277, green: 137/277, blue: 249/277, alpha: 1)
    
    let textView: UITextView = {
        let textview = UITextView()
        textview.text = ""
        textview.font = UIFont.systemFont(ofSize: 14)
        textview.translatesAutoresizingMaskIntoConstraints = false
        textview.backgroundColor = UIColor.clear
        textview.textColor = UIColor.white
        textview.isEditable = false
        return textview
    }()
    
    let bubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = blueColor
        view.layer.cornerRadius = 17
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let profileImageView: UIImageView = {
        let profileImage = UIImageView()
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        profileImage.layer.cornerRadius = 10
        profileImage.layer.masksToBounds = true
        profileImage.contentMode = .scaleAspectFill
        return profileImage
    }()
    
    let messageImageView: UIImageView = {
        let profileImage = UIImageView()
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        profileImage.layer.cornerRadius = 10
        profileImage.layer.masksToBounds = true
        profileImage.contentMode = .scaleAspectFill
        return profileImage
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //bubbleView
        addSubview(bubbleView)
        
        bubbleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        //right
        bubbleViewRightAnchor = bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -15)
        bubbleViewRightAnchor?.isActive = true
        
        //left
        bubbleViewLeftAnchor = bubbleView.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8)
        
        //width
        bubbleViewWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 200)
        bubbleViewWidthAnchor?.isActive = true
        
        //messageImageView
        bubbleView.addSubview(messageImageView)
        
        messageImageView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor).isActive = true
        messageImageView.topAnchor.constraint(equalTo: bubbleView.topAnchor).isActive = true
        messageImageView.widthAnchor.constraint(equalTo: bubbleView.widthAnchor).isActive = true
        messageImageView.heightAnchor.constraint(equalTo: bubbleView.heightAnchor).isActive = true
        
        //textView
        addSubview(textView)
        
        textView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 7).isActive = true
        textView.topAnchor.constraint(equalTo: self.topAnchor, constant: -1).isActive = true
        textView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor).isActive = true
        textView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        //profileImageView
        addSubview(profileImageView)
        
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
