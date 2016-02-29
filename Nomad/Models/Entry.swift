//
//  Entry.swift
//  Nomad
//
//  Created by Kristin Beese on 2/20/16.
//  Edited by Janka Gal on 2/25/16.
//  Edited by Raj Iyer on 2/29/16.
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
    
    static public func loadAll() -> [Entry] {
        
        var entry: [Entry] = []
        do {
            // returns an array of paths to each item in the entry folder
            // should return an array of paths to each individual entry folder
            let folders = try NSFileManager.defaultManager().contentsOfDirectoryAtPath(allEntriesFolder() as String)
            
            for folder in folders {
                
                // gets string of file containing entry info
                let entryFile = (allEntriesFolder().stringByAppendingPathComponent(folder) as NSString).stringByAppendingPathComponent("entry")
                
                // load that file from the disk and use super's loadFromDisk to extract the entry
                //let entryObject: Entry? = Entry.loadFromDisk(entryFile)
                // NOT sure how to load objects
                
                
                
            }
        } catch let e as NSError {
            // error
            print(e)
        }
        
        // Sort based on the start date
        // returns true if $0 is less than $1
        entry.sortInPlace {
            $1.date.compare($0.date) == .OrderedAscending
        }
        
        return entry
        
    }
    
    public override func filePath() -> NSString {
        
        // rootfolder/trips/tripGUID/entries/{entryGUID}
        
        let entryFolder = self.trip!.filePathFolder() as NSString
        return (entryFolder.stringByAppendingPathComponent("entries") as NSString).stringByAppendingPathComponent(guID.UUIDString)
        
    }
    // NOT SURE
    public func filePathFolder() -> NSString {
        
        let entriesFolder = Model.rootFolder.stringByAppendingPathComponent("entries") as NSString
        return (entriesFolder.stringByAppendingPathComponent(guID.UUIDString) as NSString)
        
    }
    // NOT SURE
    static func allEntriesFolder() -> NSString {
        return Model.rootFolder.stringByAppendingPathComponent("entries")
    }
}