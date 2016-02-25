//
//  Photo.swift
//  Nomad
//
//  Created by Kristin Beese on 2/20/16.
//  Copyright © 2016 Team 9. All rights reserved.
//

import Foundation

public class Photo: Model {
    
    // MARK: Read only Properties
    
    var fileName: String
    var thumbnailPath: String {
        get {
            return self.guID.UUIDString
        }
    }
    var fullSizePath: String {
        get {
            return self.guID.UUIDString
        }
    }
    
    // Create a new Photo
    
    init?(_fileName: String, _thumbnailPath: String, _fullSizePath: String) {
        
        // Initialize variables
        fileName = _fileName
        //thumbnailPath = _thumbnailPath
        //fullSizePath = _fullSizePath
        // Create a guid for file name
        super.init(guid: NSUUID())
        
    }
 
    // Loading a photo off the disk
    
    init(_fileName: String, _thumbnailPath: String, _fullSizePath: String, _guid: NSUUID) {
        
        // Initialize variables
        fileName = _fileName
        //thumbnailPath = _thumbnailPath
        //fullSizePath = _fullSizePath
        // Find the file name??
        super.init(guid: _guid)
        
    }
    
    // MARK: NSCoding 
    
    required convenience public init?(coder decoder: NSCoder) {
        guard let fileName = decoder.decodeObjectForKey("fileName") as? String,
            let thumbnailPath = decoder.decodeObjectForKey("thumbnailPath") as? String,
            let fullSizePath = decoder.decodeObjectForKey("fullSizePath") as? String,
            let guid = decoder.decodeObjectForKey("guid") as? NSUUID
            else { return nil }
        
        self.init(
            _fileName: fileName,
            _thumbnailPath: thumbnailPath,
            _fullSizePath: fullSizePath,
            _guid: guid
        )
    }

    public override func encodeWithCoder(coder: NSCoder) {
        
        // encodes guid
        super.encodeWithCoder(coder)
        
        coder.encodeObject(self.fileName, forKey: "fileName")
        coder.encodeObject(self.thumbnailPath, forKey: "thumbnailPath")
        coder.encodeObject(self.fullSizePath, forKey: "fullSizePath")

    }
    
    public override func filePath() -> NSString {
        
        let photosFolder = rootFolder.stringByAppendingPathComponent("photo") as NSString
        return (photosFolder.stringByAppendingPathComponent(guID.UUIDString) as NSString).stringByAppendingPathComponent("photo")
        
    }
    
    
}