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
    var photo: UIImage?
    var entry: Entry?

    
    // Create a new Photo
    
    init?(_photo: UIImage?) {
        
        // Initialize variables
        //fileName = _fileName
        //thumbnailPath = _thumbnailPath
        //fullSizePath = _fullSizePath
        photo =  _photo
        
        // Create a guid for file name
        super.init(guid: NSUUID())
        
    }
 
    // Loading a photo off the disk
    
    init?(_photo: UIImage?, _guid: NSUUID) {
        
        // Initialize variables
        //fileName = _fileName
        //thumbnailPath = _thumbnailPath
        //fullSizePath = _fullSizePath
        photo =  _photo
        // Find the file name??
        super.init(guid: _guid)
        
    }
    
    // MARK: NSCoding 
    
    required convenience public init?(coder decoder: NSCoder) {
        guard //let fileName = decoder.decodeObjectForKey("fileName") as? String,
            //let thumbnailPath = decoder.decodeObjectForKey("thumbnailPath") as? String,
            //let fullSizePath = decoder.decodeObjectForKey("fullSizePath") as? String,
            let photo = decoder.decodeObjectForKey("photo") as? UIImage,
            let guid = decoder.decodeObjectForKey("guid") as? NSUUID
            else { return nil }
        
        self.init(
            //_fileName: fileName,
            //_thumbnailPath: thumbnailPath,
            //_fullSizePath: fullSizePath,
            _photo: photo,
            _guid: guid
        )
    }

    public override func encodeWithCoder(coder: NSCoder) {
        
        // encodes guid
        super.encodeWithCoder(coder)
        
        //coder.encodeObject(self.fileName, forKey: "fileName")
        //coder.encodeObject(self.thumbnailPath, forKey: "thumbnailPath")
        //coder.encodeObject(self.fullSizePath, forKey: "fullSizePath")
        coder.encodeObject(self.photo, forKey: "photo")

    }
    
    public override func filePath() -> NSString {
        
        // rootfolder/trips/tripGUID/entries/{entryGUID}
        
        let photopath = self.entry!.filePath() as NSString
        print(photopath)
        return (photopath.stringByAppendingPathComponent("photo") as NSString).stringByAppendingPathComponent(guID.UUIDString)
        
    }
    
    
}