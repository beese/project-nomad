//
//  HomeViewController.swift
//  Nomad
//
//  Created by Kristin Beese on 2/25/16.
//  Copyright © 2016 Team 9. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var viewTripsButton: UIButton!
    @IBOutlet weak var addEntryButton: UIButton!
    
    // check to see if on any current trips
    var onTrip: Bool {
        get {
            return allTrips.filter({ $0.endDate == nil }).count > 0
        }
    }
    var allTrips: [Trip] = []
    //get currentTrip
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        
        allTrips = Trip.loadAll()
        updateUI()
        
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    
    @IBAction func startTripTapped(sender: AnyObject) {
        // code for when user taps start trip button
        
        // open add trip view
        
        if (onTrip) {
            
            // ends the trip
            let tripToEnd = allTrips.filter({ $0.endDate == nil })
            
            for trip in tripToEnd {
                trip.endDate = NSDate()
                trip.save()
            }
            
            // change the home screen
            
            updateUI()
        }
        else {
            // not on trip
            // can add a trip
            self.navigationController?.pushViewController(AddTripViewController(), animated: true)
        }
        
        // change button to say end trip
        
        // add an add entry button
    }
    
    @IBAction func viewTripsTapped(sender: AnyObject) {
        // code for when user taps view trips
        
        // open view trips view
        
        self.navigationController?.pushViewController(TripsTableViewController(), animated: true)
    }

    @IBAction func addEntryTapped(sender: AnyObject) {
        // code for when user taps add entry
        
        self.navigationController?.pushViewController(AddEntryViewController(), animated: true)
        
    }
    
    func updateUI() {
        addEntryButton.hidden = true
        
        
        // if user is on a trip
        // onTrip is temporary, in the future we will access model functions
        if (onTrip) {
            
            // on a trip
            
            addEntryButton.hidden = false
            startButton.backgroundColor = UIColor(red: 0.9615, green: 0.7353, blue: 0.724, alpha: 1.0)
            startButton.setTitle("End Trip", forState: UIControlState.Normal)
            
        }
        
        else {
            
            // not on a trip
            
            addEntryButton.hidden = true
            startButton.backgroundColor = UIColor(red: 0.8233, green: 1.0, blue: 0.8367, alpha: 1.0)
            startButton.setTitle("Start Trip", forState: UIControlState.Normal)
        }
    }
}
