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
    
    // Read only computed property
    var activeTrip: Bool {
        get {
            return endDate == nil
        }
    }
    
    // optional variables
    public var endDate: NSDate?
    public var startCoords: [Float]?
    public var endCoords: [Float]?
    
    
    
    // MARK: Initializers
    
    // When the user first creates a trip
    init?(_title: String, _travelers: String, coords: [Float]?) {
        
        
        title = _title
        travelers = _travelers
        
        // Take the current time and save it in startDate
        startDate = NSDate() // Format: Oct 12, 2015, 4:49 PM
        
        // May be nil if location services are off
        startCoords = coords
        
        super.init(guid: NSUUID())
        
    }
    
    // Loading a trip off the disk
    init?(_title: String, _travelers: String, _startCoords: [Float]?, _endCoords: [Float]?, _startDate: NSDate, _endDate: NSDate?, _guid: NSUUID) {
        
        title = _title
        travelers = _travelers
        
        startCoords = _startCoords
        endCoords = _endCoords
        
        startDate = _startDate
        
        // Should we create a bool to tell when a trip is currently active?
        
        endDate = _endDate
        
        super.init(guid: _guid)
        
    }
    
    // MARK: NSCoding

    required convenience public init?(coder decoder: NSCoder) {
        guard let title = decoder.decodeObjectForKey("title") as? String,
            let travelers = decoder.decodeObjectForKey("travelers") as? String,
            let startDate = decoder.decodeObjectForKey("start date") as? NSDate,
            let endDate = decoder.decodeObjectForKey("end date") as? NSDate,
            let startCoords = decoder.decodeObjectForKey("start coords") as? [Float],
            let endCoords = decoder.decodeObjectForKey("end coords") as? [Float],
            let guid = decoder.decodeObjectForKey("guid") as? NSUUID
            else { return nil }
        
        self.init(
            _title: title,
            _travelers: travelers,
            _startCoords: startCoords,
            _endCoords: endCoords,
            _startDate: startDate,
            _endDate: endDate,
            _guid: guid
        )
    }
    
    public override func encodeWithCoder(coder: NSCoder) {
        
        // encodes guid
        super.encodeWithCoder(coder)
        
        coder.encodeObject(self.title, forKey: "title")
        coder.encodeObject(self.travelers, forKey: "travelers")
        coder.encodeObject(self.startDate, forKey: "start date")
        coder.encodeObject(self.endDate, forKey: "end date")
        coder.encodeObject(self.startCoords, forKey: "start coords")
        coder.encodeObject(self.endCoords, forKey: "end coords")
        
    }
    
    
    // MARK: Methods
    
    func endTrip() {
        
        // get ending date
        self.endDate = NSDate()
        
    }
    
    public override func filePath() -> NSString {
        
        let tripsFolder = rootFolder.stringByAppendingPathComponent("trips") as NSString
        return (tripsFolder.stringByAppendingPathComponent(guID.UUIDString) as NSString).stringByAppendingPathComponent("trip")
        
    }
    
}