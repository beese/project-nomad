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
    var description: String?
    var photo: Photo?
    var coords: Float?
    
    //When user first creates an entry
    init?(title: String, date: NSDate, description: String, photo: Photo, coords: Float) {
        // constructor for loading from the disk
        
        self.title = title
        self.date = date
        self.description = description
        self.photo = photo
        self.coords = coords
        
    }
    
    //When loading off of the disk
    init?(title: String, description: String, photo: Photo, coords: Float) {
        // constructor used for initial creation
        self.title = title
        self.description = description
        self.photo = photo
        self.coords = coords
        
        // calculate the date
        self.date = NSDate()
        
        
    }
    
    
}