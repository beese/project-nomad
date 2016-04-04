//
//  TripsTableViewController.swift
//  Nomad
//
//  Created by Kristin Beese on 2/25/16.
//  Copyright © 2016 Team 9. All rights reserved.
//

import UIKit

class TripsTableViewController: UITableViewController, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    var listOfTrips: [Trip] = Trip.loadAll()
    var selectedTrip: Trip?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "All Trips"
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 88
        
        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self
        
        self.tableView.tableFooterView = UIView()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        // only 1 section
        
        if listOfTrips.count == 0 {
            return 0
        }
        
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return listOfTrips.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)

        // Configure the cell...
        
        // Put in the name of the trip
        
        let trip = listOfTrips[indexPath.row]
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEE, MMMM d, yyy"
        
        let startString = formatter.stringFromDate(trip.startDate)
        if (trip.endDate != nil) {
            let endString = formatter.stringFromDate(trip.endDate!)
            cell.textLabel?.text = "\(trip.title)\nwith \(trip.travelers)\n\(startString) - \(endString)"
        } else {
            cell.textLabel?.text = "\(trip.title)\nwith \(trip.travelers)\n\(startString) - now\n"
        }
        
        //cell.textLabel?.text = "\(trip.title)\n\(trip.travelers)\n\(trip.startDate) – \(trip.endDate)"
        cell.textLabel?.numberOfLines = 0
        // Puts arrow next to it
        cell.accessoryType = .DisclosureIndicator
        

        return cell
    }
    
    //for a trip selected
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedTrip = listOfTrips[indexPath.row]
        
        print("selected a trip: " + selectedTrip.title);
        
        let viewController = TripViewController()
        viewController.toPass = selectedTrip
        
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    
    // empty data set
    
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "No Trips"
        
        let attributes = [ NSFontAttributeName: UIFont.boldSystemFontOfSize(18),
                           NSForegroundColorAttributeName: UIColor.darkGrayColor() ]
        
        return NSAttributedString(string: text, attributes: attributes)
    }
    
    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "Oh no! You haven't started a trip yet. Go on an adventure today and create a trip!"
        
        let para = NSMutableParagraphStyle()
        para.lineBreakMode = .ByWordWrapping
        para.alignment = .Center
        
        let attributes = [ NSFontAttributeName: UIFont.systemFontOfSize(14),
                           NSForegroundColorAttributeName: UIColor.lightGrayColor(),
                           NSParagraphStyleAttributeName: para ]
        
        return NSAttributedString(string: text, attributes: attributes)
    }
    
    func buttonTitleForEmptyDataSet(scrollView: UIScrollView!, forState state: UIControlState) -> NSAttributedString! {
        let attr = [ NSFontAttributeName: UIFont.boldSystemFontOfSize(17) ]
        
        return NSAttributedString(string: "Add Trip", attributes: attr)
    }
    
    func emptyDataSet(scrollView: UIScrollView!, didTapButton button: UIButton!) {
        let vc = AddTripViewController()
        self.navigationController?.popToRootViewControllerAnimated(true)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
}
