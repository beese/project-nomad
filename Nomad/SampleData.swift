//
//  SampleData.swift
//  Nomad
//
//  Created by Kristin Beese on 4/26/16.
//  Copyright © 2016 Team 9. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

public class SampleData {
    
    private static func loadImage(named: String) -> UIImage? {
        let first = UIImage(named: named)
        
        if let i = first {
            return UIImage(CGImage: i.CGImage!, scale: i.scale, orientation: i.imageOrientation)
        }
        
        return nil
    }
    
    private static func createAndAppendEntry(inTrip trip: Trip?, title: String, info: String, imageName: String, lat: Double, long: Double, timestamp: NSTimeInterval) {
        let d2 = NSDate(timeIntervalSince1970: timestamp)
        
        let p2 = Photo(_photo: loadImage(imageName), _guid: NSUUID())
        
        let e2 = CLLocation(latitude: lat, longitude: long)
        
        let ent = Entry(_title: title, _date: d2, _info: info, _photo: p2, _coords: e2, _guid: NSUUID())
        ent?.trip = trip
        
        trip?.entries.append(ent!)
    }
    
    private static func europeanTrip() -> Trip {
        
        // build sample trip
        
        // Starting coordinates
        
        let latitude: CLLocationDegrees = 49.0097
        let longitude: CLLocationDegrees = 2.5479
        
        let parisAirport = CLLocation(latitude: latitude, longitude: longitude)
        
        // Ending coordinates
        
        let latitude1: CLLocationDegrees = 51.4700
        let longitude1: CLLocationDegrees = -0.4543
        
        let startDate = NSDate(timeIntervalSince1970: 1434112200)
        
        let endDate = NSDate(timeIntervalSince1970: 1434568800)
        
        let londonAirport = CLLocation(latitude: latitude1, longitude: longitude1)
        
        let t = Trip(_title: "Sample: Paris and London!", _travelers: "Carolyn, and me", coords: parisAirport)
        t?.endDate = endDate
        t?.startDate = startDate
        t?.endCoords = londonAirport
        
        // adding entries
        
        // entry 1
        
        createAndAppendEntry(inTrip: t,
                             title: "Arrived in Paris!",
                             info: "We just landed in Paris! We are so excited for our European adventure to start.  The airport here is beautiful, and luckily our flight here went smoothly.  I can't wait to see what we have in store for us on this trip! Photo credit: Flickr (rjackb)",
                             imageName: "parisairport.jpg",
                             lat: 49.009750,
                             long: 2.546905,
                             timestamp: 1434112500)
        
        // entry 2
        
        createAndAppendEntry(inTrip: t,
                             title: "Tiny Hostel",
                             info: "This is an image of our great hostel in Paris.  It is very small, but it's a great price and we are in an awesome location for exploring the city.  The other people staying here seem really nice too.  Photo credit: Flickr (Dan Herbon)",
                             imageName: "hostel.jpg",
                             lat: 48.879873,
                             long: 2.342238,
                             timestamp: 1434125280)
        
        
        // entry 3
        
        createAndAppendEntry(inTrip: t,
                             title: "Eiffel Tower",
                             info: "What a beautiful day in Paris! This morning Carolyn and I decided that we had to see one of the best attractions in Paris: the Eiffel Tower!  It was packed with tourists, but at least we got some great photos!  Photo credit: Flickr (crosby_cj)",
                             imageName: "eifeltower.jpg",
                             lat: 48.858476,
                             long: 2.293902,
                             timestamp: 1434190440)
        
        // entry 4
        
        createAndAppendEntry(inTrip: t,
                             title: "Love Locks",
                             info: "The countless thousands of “love locks” attached to along the full length of both sides of the bridge’s railings have become a tradition among young (and not so young) lovers. Couples fasten a lock to the bridge railing and then toss the key into the Seine to symbolize that their love will keep them locked together forever and is now beyond their control. Given that background, it seems that the couples who put up those combination locks either do not quite grasp the concept or are having commitment issues.  Photo credit: Flickr (Ken and Nyetta)",
                             imageName: "lovebridge.jpg",
                             lat: 48.858379,
                             long: 2.337520,
                             timestamp: 1434213840)
        
        // entry 5
        
        createAndAppendEntry(inTrip: t,
                             title: "London: Big Ben!",
                             info: "After a day of travel, we made it to London!  This morning we saw Big Ben and then afterwards had some delicious lunch.  Photo credit: Flickr (Kevin Oliver)",
                             imageName: "bigben.jpg",
                             lat: 51.500849,
                             long: -0.124926,
                             timestamp: 1434275400)
        
        // entry 6
        
        createAndAppendEntry(inTrip: t,
                             title: "The London Eye",
                             info: "This morning Carolyn and I decided to explore London by taking a ride on the London Eye.  I loved the amazing views of the city!  We are hoping to do more exploring today.  I love London!  Photo credit: Flickr (Dan Dao)",
                             imageName: "eye.jpg",
                             lat: 51.503211,
                             long: -0.119401,
                             timestamp: 1434366900)
        
        // entry 7
        
        createAndAppendEntry(inTrip: t,
                             title: "Telephone Box",
                             info: "Of course I coudln't pass up on taking a picture of the classic London Red Telephone Box!  Photo credit: Flickr (Aaron Webb)",
                             imageName: "phone.jpg",
                             lat: 51.502136,
                             long: -0.099167,
                             timestamp: 1434452400)
        
        // entry 8
        
        createAndAppendEntry(inTrip: t,
                             title: "Queen's Guards",
                             info: "The guards in front of Buckingham Palace were so serious!  I couldn't believe how they didn't even flinch at all.  Photo credit: Flickr (esartee)",
                             imageName: "guard.jpg",
                             lat: 51.501284,
                             long: -0.141847,
                             timestamp: 1434550920)
        
        // entry 9
        
        createAndAppendEntry(inTrip: t,
                             title: "Goodbye Europe",
                             info: "I can't believe how fast these days in Europe went by.  I am sitting on our plane about to head back to the USA and I wish we just had some more time!  Carolyn and I loved this trip, and we will definitely be back in Europe again some day!  Photo credit: Flickr (brewbooks)",
                             imageName: "londonairport.jpg",
                             lat: 51.4700,
                             long: -0.4543,
                             timestamp: 1434568800)
        
        
        
        return t!;
    }
    
    public static func generateAndSaveData() {
        let t = europeanTrip()
        
        t.save()
        
        for e in t.entries {
            e.save()
        }
        
    }
    
}