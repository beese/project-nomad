//
//  AddTripViewController.swift
//  Nomad
//
//  Created by Kristin Beese on 2/25/16.
//  Copyright © 2016 Team 9. All rights reserved.
//

import UIKit

class AddTripViewController: UIViewController {

    @IBOutlet weak var tripTitleLabel: UILabel!
    @IBOutlet weak var titleTextBox: UITextField!
    @IBOutlet weak var travelerTitleLabel: UILabel!
    @IBOutlet weak var travelersTextBox: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Add a Trip"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Save, target: self, action: "saveTapped")

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func saveTapped() {
        print("hi")
        let title = titleTextBox.text
        let travelers = travelersTextBox.text
        
        titleTextBox.resignFirstResponder()
        travelersTextBox.resignFirstResponder()

        SwiftSpinner.show("Fetching GPS Coordinates...", animated: true);
        
        // get coordinates
        GPSHelper.sharedInstance.getQuickLocationUpdate { (locations) -> (Void) in
            
            let travel = Trip(_title: title!, _travelers: travelers!, coords: locations)
            
            SwiftSpinner.hide();
            
            travel!.save()
            
            self.navigationController?.popViewControllerAnimated(true)
            
            if locations == nil {
                let alertController = UIAlertController(title: "GPS Coordinates Failed", message: "Trip created but there are no starting coordinates", preferredStyle: .Alert)
                alertController.addAction(UIAlertAction(title: "Okay", style: .Default, handler: nil))
                self.navigationController?.presentViewController(alertController, animated: true, completion: nil)
            }
            
        }
        
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
