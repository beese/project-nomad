//
//  AddTripViewController.swift
//  Nomad
//
//  Created by Kristin Beese on 2/25/16.
//  Copyright © 2016 Team 9. All rights reserved.
//

import UIKit

class AddTripViewController: UIViewController {

    @IBOutlet weak var titleTextBox: UITextField!
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
        
        // TODO: get coordinates
        
        let travel = Trip(_title: title!, _travelers: travelers!, coords: nil)
        
        travel!.save()
        
        self.navigationController?.popViewControllerAnimated(true)
        
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
