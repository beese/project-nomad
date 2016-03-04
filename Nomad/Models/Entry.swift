//
//  Entry.swift
//  Nomad
//
//  Created by Kristin Beese on 2/20/16.
//  Copyright © 2016 Team 9. All rights reserved.
//

import Foundation

public class Entry: Model {
    
    // MARK: Properties
    
    var title: String
    var date: NSDate
    var trip: Trip?
    
    // optional variables
    var info: String?
    var photo: Photo?
    var coords: [Float]?
    
    init?(_title: String, _info: String, _photo: Photo?, _coords: [Float]?) {
        // constructor for loading from the disk
        
        title = _title
        date = NSDate()
        info = _info
        photo = _photo
        coords = _coords
        
         super.init(guid: NSUUID())
        
    }
    
    //When loading off of the disk
    init?(_title: String, _date: NSDate, _info: String?, _photo: Photo?, _coords: [Float]?, _guid: NSUUID) {
        // constructor used for initial creation
        title = _title
        info = _info
        photo = _photo
        coords = _coords
        date = _date
        
        super.init(guid: _guid)
        
    }
    
    required convenience public init?(coder decoder: NSCoder) {
        guard let title = decoder.decodeObjectForKey("title") as? String,
        let date = decoder.decodeObjectForKey("date") as? NSDate,
        let info = decoder.decodeObjectForKey("info") as? String?,
        let photo = decoder.decodeObjectForKey("photo") as? Photo?,
        let coords = decoder.decodeObjectForKey("coords") as? [Float]?,
        let guid = decoder.decodeObjectForKey("guid") as? NSUUID            else {return nil}
        
        self.init(
            _title: title,
            _date: date,
            _info: info,
            _photo: photo,
            _coords: coords,
            _guid: guid
        )
        
    }
    
    public override func encodeWithCoder(coder: NSCoder) {
        super.encodeWithCoder(coder)
    
        coder.encodeObject(self.title, forKey: "title")
        coder.encodeObject(self.date, forKey: "date")
        coder.encodeObject(self.info, forKey: "info")
        coder.encodeObject(self.photo, forKey: "photo")
        coder.encodeObject(self.coords, forKey: "coords")
    }
    
    
    public override func filePath() -> NSString {
        
        // rootfolder/trips/tripGUID/entries/{entryGUID}
        
        let entryFolder = self.trip!.filePathFolder() as NSString
        print(entryFolder)
        return (entryFolder.stringByAppendingPathComponent("entries") as NSString).stringByAppendingPathComponent(guID.UUIDString)
        
    }
    public func filePathFolder() -> NSString {
        
        let entriesFolder = Model.rootFolder.stringByAppendingPathComponent("entries") as NSString
        return (entriesFolder.stringByAppendingPathComponent(guID.UUIDString) as NSString)
        
    }
    
    // returns path to folder containing all of the trips
    static func allTripsFolder() -> NSString {
        return Model.rootFolder.stringByAppendingPathComponent("entries")
    }
    
    // similar to Java toString method to print out an object for debugging
    override public var description : String {
        return "{ Entry:\n\ttitle: \(self.title)\n\tinfo: \(self.info) }\n"
    }
    
}