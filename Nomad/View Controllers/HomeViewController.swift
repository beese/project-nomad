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
    
    @IBOutlet weak var constraintCenterXMyAdventures: NSLayoutConstraint!
    @IBOutlet weak var contraintCenterXEndAdventure: NSLayoutConstraint!
    @IBOutlet weak var constraintCenterXAddEntry: NSLayoutConstraint!
    // check to see if on any current trips
    var onTrip: Bool {
        get {
            return allTrips.filter({ $0.endDate == nil }).count > 0
        }
    }
    var allTrips: [Trip] = []
    //get currentTrip
    
    override func viewDidLoad() {
        self.constraintCenterXMyAdventures.constant = -1 * (self.view.bounds.size.width / 2 + 150)
        self.contraintCenterXEndAdventure.constant = -1 * (self.view.bounds.size.width / 2 + 150)
        self.constraintCenterXAddEntry.constant = -1 * (self.view.bounds.size.width / 2 + 150)
        self.view.layoutIfNeeded()
    }
    
    override func viewDidAppear(animated: Bool) {
        UIView.animateKeyframesWithDuration(1.0, delay: 0.5, options: .AllowUserInteraction, animations: {
            UIView.addKeyframeWithRelativeStartTime(0.0, relativeDuration: 0.33333, animations: {
                self.constraintCenterXMyAdventures.constant = 0
                self.view.layoutIfNeeded()
            })
            UIView.addKeyframeWithRelativeStartTime(0.25, relativeDuration: 0.33333, animations: {
                self.contraintCenterXEndAdventure.constant = 0
                self.view.layoutIfNeeded()
            })
            UIView.addKeyframeWithRelativeStartTime(0.5, relativeDuration: 0.33333, animations: {
                self.constraintCenterXAddEntry.constant = 0
                self.view.layoutIfNeeded()
            })
        }, completion: nil)
    }

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
            // MARK: End trip confirmation dialog
            // create the alert
            let alert = UIAlertController(title: "Are you sure?", message: "You will not be able to add any more entries to this adventure.", preferredStyle: UIAlertControllerStyle.Alert)
            
            // add the actions (buttons)
            alert.addAction(UIAlertAction(title: "End Adventure", style: UIAlertActionStyle.Destructive, handler: { action in
                // ends the trip
                let tripToEnd = self.allTrips.filter({ $0.endDate == nil })
                
                for trip in tripToEnd {
                    trip.endDate = NSDate()
                    
                    SwiftSpinner.show("Fetching Ending GPS Coordinates...", animated: true);
                    
                    GPSHelper.sharedInstance.getQuickLocationUpdate { (locations) -> (Void) in
                        
                        trip.endCoords = locations
                        
                        SwiftSpinner.hide()
                        
                        trip.save()
                        
                        self.navigationController?.popViewControllerAnimated(true)
                        
                        if locations == nil {
                            let alertController = UIAlertController(title: "GPS Coordinates Failed", message: "Adventure ended but there are no ending coordinates", preferredStyle: .Alert)
                            alertController.addAction(UIAlertAction(title: "Okay", style: .Default, handler: nil))
                            self.navigationController?.presentViewController(alertController, animated: true, completion: nil)
                        }
                        
                    }

                }
                
                // change the home screen
                self.updateUI()
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
            
            // show the alert
            self.presentViewController(alert, animated: true, completion: nil)
        }
        else {
            // not on trip
            // can add a trip
            let vc = AddTripViewController()
            vc.editMode = false
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    @IBAction func viewTripsTapped(sender: AnyObject) {
        // code for when user taps view trips
        
        // open view trips view
        
        self.navigationController?.pushViewController(TripsTableViewController(), animated: true)
    }

    @IBAction func addEntryTapped(sender: AnyObject) {
        // code for when user taps add entry
        
        //self.navigationController?.pushViewController(AddEntryViewController(), animated: true)
        self.navigationController?.pushViewController(AddEntryVC(), animated: true)

    }
    
    @IBAction func viewEntriesTapped(sender: AnyObject) {
        
        
        let currentTrip =  allTrips.filter({ $0.endDate == nil }).first
        let viewController = TripViewController()
        viewController.toPass = currentTrip
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    func updateUI() {
        
        addEntryButton.hidden = true
        
        
        // if user is on a trip
        // onTrip is temporary, in the future we will access model functions
        if (onTrip) {
            
            // on a trip
            
            addEntryButton.hidden = false
            //startButton.backgroundColor = UIColor(red: 0.9615, green: 0.7353, blue: 0.724, alpha: 1.0)
            startButton.setTitle("end adventure", forState: UIControlState.Normal)
            
        }
        
        else {
            
            // not on a trip
            
            addEntryButton.hidden = true
            //startButton.backgroundColor = UIColor(red: 0.8233, green: 1.0, blue: 0.8367, alpha: 1.0)
            startButton.setTitle("start adventure", forState: UIControlState.Normal)
        }
    }
}
