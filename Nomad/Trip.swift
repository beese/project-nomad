//
//  Trip.swift
//  Nomad
//
//  Created by Kristin Beese on 2/20/16.
//  Copyright © 2016 Team 9. All rights reserved.
//

import Foundation

public class Trip: Model {
    
    // MARK: Properties
    
    var title: String
    var travelers: String
    var startDate: NSDate
    
    // optional variables
    public var endDate: NSDate?
    public var startCoords: Float?
    public var endCoords: Float?
    
    init(title: String, travelers: String) {
        self.title = title
        self.travelers = travelers
        
    }
    
    
    
    
    
    
    
}