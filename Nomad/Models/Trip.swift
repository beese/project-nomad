//
//  Trip.swift
//  Nomad
//
//  Created by Kristin Beese on 2/20/16.
//  Copyright © 2016 Team 9. All rights reserved.
//

import Foundation
import CoreLocation

public class Trip: Model {
    
    // MARK: Properties
    
    var title: String
    var travelers: String
    var startDate: NSDate
    var entries: [Entry]
    
    // Read only computed property
    var activeTrip: Bool {
        get {
            return endDate == nil
        }
    }
    
    // optional variables
    public var endDate: NSDate?
    public var startCoords: CLLocation?
    public var endCoords: CLLocation?
    
    
    
    // MARK: Initializers
    
    // When the user first creates a trip
    init?(_title: String, _travelers: String, coords: CLLocation?) {
        
        
        title = _title
        travelers = _travelers
        
        // originally set to be empty
        entries = []
        
        // Take the current time and save it in startDate
        startDate = NSDate() // Format: Oct 12, 2015, 4:49 PM
        
        // May be nil if location services are off
        startCoords = coords
        
        super.init(guid: NSUUID())
        
    }
    
    // Loading a trip off the disk
    init?(_title: String, _travelers: String, _startCoords: CLLocation?, _endCoords: CLLocation?, _startDate: NSDate, _endDate: NSDate?, _guid: NSUUID) {
        
        title = _title
        travelers = _travelers
        
        entries = []
        
        startCoords = _startCoords
        endCoords = _endCoords
        
        startDate = _startDate
        
        // Should we create a bool to tell when a trip is currently active?
        
        endDate = _endDate
        
        super.init(guid: _guid)
        
    }
    
    // MARK: NSCoding
    
    // load
    required convenience public init?(coder decoder: NSCoder) {
        guard let title = decoder.decodeObjectForKey("title") as? String,
            let travelers = decoder.decodeObjectForKey("travelers") as? String,
            let startDate = decoder.decodeObjectForKey("start date") as? NSDate,
            let endDate = decoder.decodeObjectForKey("end date") as? NSDate?,
            let startCoords = decoder.decodeObjectForKey("start coords") as? CLLocation?,
            let endCoords = decoder.decodeObjectForKey("end coords") as? CLLocation?,
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
    
    // saving
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
        endDate = NSDate()
        
    }
    
    static public func loadAll() -> [Trip] {
        print("in load all")
        //return array of all trips with entries associated with it
        
        var trips: [Trip] = []
        
        do {
            // returns an array of paths to each item in the trips folder
            // should return an array of paths to each individual trip folder
            let folders = try NSFileManager.defaultManager().contentsOfDirectoryAtPath(allTripsFolder() as String)
            
            for folder in folders {
                //print("in folder in folders")
                // gets string of file containing trip info
                let tripFile = (allTripsFolder().stringByAppendingPathComponent(folder) as NSString).stringByAppendingPathComponent("trip")
                
                // load that file from the disk and use super's loadFromDisk to extract the trip
                let tripObject: Trip? = Trip.loadFromDisk(tripFile)
                
                // load in the trip's entries
                var loadedEntries: [Entry] = []
                
                //let entriesFolder = (folder as NSString).stringByAppendingPathComponent("entries")
                let entriesFolder = (allTripsFolder().stringByAppendingPathComponent(folder) as NSString).stringByAppendingPathComponent("entries")
                print("entriesFolder is ");
                print(entriesFolder)
                // check if folder exists
                
                if NSFileManager.defaultManager().fileExistsAtPath(entriesFolder) {
                    
                    // load in the entries
                    let allEntries = try NSFileManager.defaultManager().contentsOfDirectoryAtPath(entriesFolder as String)
                    
                    //print("got all entries")
                    // loop through entries
                    for entry in allEntries {
                        //print("looping through entries")
                        
                        let entryPath = (entriesFolder as NSString).stringByAppendingPathComponent(entry as String)
                        
                        let entryObject: Entry? = Entry.loadFromDisk(entryPath)
                        
                        // make sure it isn't nil
                        if let o = entryObject {
                            print("entry is " + o.title)
                            o.trip = tripObject
                            loadedEntries.append(o)
                        }
                        //print("loaded entries")
                        //print(loadedEntries)
                    }
                    
                }
                
                if let o = tripObject {
                    // make sure tripObject isn't nil
                    loadedEntries.sortInPlace {
                        $1.date.compare($0.date) == .OrderedAscending
                    }
                    o.entries = loadedEntries
                    trips.append(o)
                }
                
            }
        } catch let e as NSError {
            // error
            print(e)
        }
        
        // Sort based on the start date
        // returns true if $0 is less than $1
        trips.sortInPlace {
            $1.startDate.compare($0.startDate) == .OrderedAscending
        }
        
        return trips
        
    }
    
    
    public override func filePath() -> NSString {
        
        let tripsFolder = filePathFolder()
        return (tripsFolder as NSString).stringByAppendingPathComponent("trip")
        
    }
    
    public func filePathFolder() -> NSString {
        
        let tripsFolder = Model.rootFolder.stringByAppendingPathComponent("trips") as NSString
        return (tripsFolder.stringByAppendingPathComponent(guID.UUIDString) as NSString)
        
    }
    
    // returns path to folder containing all of the trips
    static func allTripsFolder() -> NSString {
        return Model.rootFolder.stringByAppendingPathComponent("trips")
    }
    
    // similar to Java toString method to print out an object for debugging
    override public var description : String {
        return "{ TRIP:\n\ttitle: \(title)\n\ttravellers: \(travelers) }\n"
    }
    
}