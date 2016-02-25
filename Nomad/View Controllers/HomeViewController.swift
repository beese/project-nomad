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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    }
    
    @IBAction func viewTripsTapped(sender: AnyObject) {
        // code for when user taps view trips
        
        // open view trips view
        
        self.navigationController?.pushViewController(TripsTableViewController(), animated: true)
    }

}
