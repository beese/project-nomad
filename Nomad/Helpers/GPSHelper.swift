//
//  GPSHelper.swift
//  Nomad
//
//  Created by Kristin Beese on 4/3/16.
//  Copyright © 2016 Team 9. All rights reserved.
//

import Foundation
import CoreLocation

public class GPSHelper: NSObject, CLLocationManagerDelegate {
    
    static var sharedInstance = GPSHelper()
    
    var locationManager:CLLocationManager = CLLocationManager()
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    var callback: ((CLLocation?) -> (Void))?;
    
    func getQuickLocationUpdate(cb: (CLLocation?) -> (Void)) {
        // Request location authorization
        self.locationManager.requestWhenInUseAuthorization()
        
        // Request a location update
        self.locationManager.requestLocation()
        // Note: requestLocation may timeout and produce an error if authorization has not yet been granted by the user
        // once it has the location it calls locationManager()
        
        callback = cb
    }
    
    public func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Process the received location update
        
        if let cb = callback, let loc = locations.last {
            // only enters if the values above are not nil
            cb(loc)
            callback = nil
        }
    }
    
    public func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error);
        print(" taking GPS coords failed");
        if let cb = callback {
            cb(nil);
        }
    }
}