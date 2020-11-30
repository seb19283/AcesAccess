//
//  Message.swift
//  accessAces
//
//  Created by Sebastian on 7/4/17.
//  Copyright © 2017 NewWave. All rights reserved.
//

import UIKit

class Message: NSObject {
    var fromID: String?
    var text: String?
    var timestamp: NSNumber?
    var group: String?
    
    var imageURL: String?
    var imageWidth: CGFloat?
    var imageHeight: CGFloat?
    
    init(dictionary: [String: AnyObject]){
        fromID = dictionary["fromID"] as? String
        text = dictionary["text"] as? String
        timestamp = dictionary["timestamp"] as? NSNumber
        group = dictionary["group"] as? String
        
        imageURL = dictionary["imageURL"] as? String
        imageWidth = dictionary["imageWidth"] as? CGFloat
        imageHeight = dictionary["imageHeight"] as? CGFloat
    }
}
