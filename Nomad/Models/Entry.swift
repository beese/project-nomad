//
//  Entry.swift
//  Nomad
//
//  Created by Kristin Beese on 2/20/16.
//  Copyright © 2016 Team 9. All rights reserved.
//

import Foundation

class Entry: Model {
    
    // MARK: Properties
    
    var title: String
    var date: NSDate
    
    // optional variables
    var info: String?
    var photo: Photo?
    var coords: Float?
    
    init(title: String, date: NSDate, info: String, photo: Photo, coords: Float) {
        // constructor for loading from the disk
        
        self.title = title
        self.date = date
        self.info = info
        self.photo = photo
        self.coords = coords
        
         super.init(guid: NSUUID())
        
    }
    
    //When loading off of the disk
    init?(title: String, date: NSDate, info: String, photo: Photo, coords: Float, guid: NSUUID) {
        // constructor used for initial creation
        self.title = title
        self.info = info
        self.photo = photo
        self.coords = coords
        self.date = date
        
        super.init(guid: guid)
        
    }
    
    required convenience public init?(coder dcoder: NSCoder) {
        guard let title = decoder.decodeObjectForKey("title") as? String,
        let 
    }

    required convenience internal init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}