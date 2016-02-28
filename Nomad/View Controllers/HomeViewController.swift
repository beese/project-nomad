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
    
    // temp bool for code
    // when we have models we will determine current status
    var onTrip = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        // if statements to decide which buttons to show
        
        addEntryButton.hidden = true
        
        // if user is on a trip
        // onTrip is temporary, in the future we will access model functions
        if (onTrip) {
            
            addEntryButton.hidden = false
            startButton.backgroundColor = UIColor(red: 0.9615, green: 0.7353, blue: 0.724, alpha: 1.0)
            startButton.setTitle("End Trip", forState: UIControlState.Normal)
            
        }
        
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
        self.navigationController?.pushViewController(AddTripViewController(), animated: true)
        
        // change button to say end trip
        
        // add an add entry button
        
        // temporarily change boolean
        // This will be gone when the models are connected
        onTrip = !onTrip
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
}
