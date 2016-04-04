//
//  NewTripViewController.swift
//  Nomad
//
//  Created by Janka Gal on 3/13/16.
//  Copyright © 2016 Team 9. All rights reserved.
//

import UIKit

class NewTripViewController: UIViewController {
    
    var toPass : Trip!
   
    
    //Labels to display trip information
    @IBOutlet weak var tripTitleLabel: UILabel!
    @IBOutlet weak var tripTravelersLabel: UILabel!
    @IBOutlet weak var tripDateLabel: UILabel!
    
    
    override func viewDidLoad() {
        
        //set up for labels
        tripTitleLabel.numberOfLines = 0
        tripTravelersLabel.numberOfLines = 0
        tripDateLabel.numberOfLines = 0
        
        super.viewDidLoad()
        if let _trip = toPass {
            print(_trip.title);
            print(_trip.entries)
        } else {
            print("why");
        }
        self.title = toPass.title
        
        
        
        tripTitleLabel.text = toPass.title
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEE, MMMM d, yyy"
        
        let startString = formatter.stringFromDate(toPass.startDate)
        if (toPass.endDate != nil) {
            let endString = formatter.stringFromDate(toPass.endDate!)
           tripDateLabel.text = "\(startString) - \(endString)"
        } else {
            tripDateLabel.text = "\(startString) - now"
        }
        
        tripTravelersLabel.text = "Travelers: \(toPass.travelers)"
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
