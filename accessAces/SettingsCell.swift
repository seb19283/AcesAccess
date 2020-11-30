//
//  SettingsCell.swift
//  Settings Test
//
//  Created by Sebastian Connelly (student LM) on 10/13/17.
//  Copyright © 2017 Sebastian Connelly (student LM). All rights reserved.
//

import UIKit

class SettingsCell: UITableViewCell {
    
    let iconImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 50
        image.layer.masksToBounds = true
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    let textView: UITextView = {
        let textview = UITextView()
        textview.text = ""
        textview.font = UIFont.systemFont(ofSize: 16)
        textview.translatesAutoresizingMaskIntoConstraints = false
        textview.backgroundColor = .clear
        textview.textColor = .black
        textview.isScrollEnabled = false
        return textview
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        //iconImage
        self.addSubview(iconImage)
        
        iconImage.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        iconImage.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        iconImage.widthAnchor.constraint(equalToConstant: 50).isActive = true
        iconImage.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        //textView
        self.addSubview(textView)
        
        textView.leftAnchor.constraint(equalTo: iconImage.rightAnchor).isActive = true
        textView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -16)
        textView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        textView.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
