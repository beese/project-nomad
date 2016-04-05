//
//  Model.swift
//  Nomad
//
//  Created by Kristin Beese on 2/20/16.
//  Copyright © 2016 Team 9. All rights reserved.
//

import Foundation

public class Model: NSObject, NSCoding {
    
    // MARK: Properties
    
    var guID: NSUUID
    
    // need rootFolder to be static for all children
    // declares an anonymous function and then immediately calls it
    static var rootFolder: NSString = {
        
        // Finds the path to user's documents
        let documentsDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
        
        // Creates path to Nomad folder
        let rFolder = documentsDirectory.stringByAppendingPathComponent("nomad")
        
        // Create Nomad Folder
        // Will throw an error if the file had already been created
        do {
            try NSFileManager.defaultManager().createDirectoryAtPath(rFolder as String, withIntermediateDirectories: false, attributes: nil)
        } catch _ as NSError {
            // file has already been created
        }
        
        return rFolder
        
    }()
    
    override convenience init() {
        
        // Generate GUID
        self.init(guid: NSUUID())
        
    }
    
    init(guid: NSUUID) {
        
        self.guID = guid
        
    }
    
    
    
    
    // MARK: NSCoding
    
    required convenience public init?(coder decoder: NSCoder) {
        guard let guid = decoder.decodeObjectForKey("guid") as? NSUUID else {
            return nil
        }
        
        self.init(guid: guid)
    }
    
    public func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(self.guID, forKey: "guid")
    }
    
    
    
    
    // MARK: Methods
    
    func saveToDisk(path: String) {
        do {
            let folder = (path as NSString).stringByDeletingLastPathComponent
            try NSFileManager.defaultManager().createDirectoryAtPath(folder, withIntermediateDirectories: true, attributes: nil)
        } catch _ as NSError {
            // file has already been created
        }
        
        // Writes information to the disk
        NSKeyedArchiver.archiveRootObject(self, toFile: path)
        
    }
    
    public static func loadFromDisk<T>(path: String) -> T? {
        
        //print("print path in loadFromDisk: " + path)
        
        // Loads information from the disk
        guard let model = NSKeyedUnarchiver.unarchiveObjectWithFile(path) as? T else {
            return nil
        }
        
        // return the model loaded from the disk
        return model
        
    }
    
    func filePath() -> NSString {
        
        // Return the file path
        return Model.rootFolder
        
    }
    
    func save() {
        
        let path = filePath()
        saveToDisk(path as String)
        
    }
    
}