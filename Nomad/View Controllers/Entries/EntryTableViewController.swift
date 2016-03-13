//
//  EntryTableViewController.swift
//  Nomad
//
//  Created by Kristin Beese on 2/25/16.
//  Copyright © 2016 Team 9. All rights reserved.
//

import UIKit

class EntryTableViewController: UITableViewController {
    // current trip
    
    var currentTrip : Trip?
    var allTrips: [Trip] = Trip.loadAll()
    var listOfEntries: [Entry] = []
    var selectedEntry : Entry?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for trip in allTrips {
            if (trip.endDate == nil) {
                currentTrip = trip
            }
        }
        
       
        listOfEntries = currentTrip!.entries
        print("Current trip: " + currentTrip!.title)
        print("List of entries: ")
        print(listOfEntries);
        
        self.title = "All Entries"
        
        tableView.registerClass(UITableViewCell.self,forCellReuseIdentifier: "cell")
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 88

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
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return listOfEntries.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)

        // Configure the cell...
        
        let entry = listOfEntries[indexPath.row]
        let formatter = NSDateFormatter()
        formatter.dateFormat =  "EEE, MMMM d, yyy 'at' h:mm a"
        let time = formatter.stringFromDate(entry.date)
        cell.textLabel?.text = "\(entry.title)\n\(time)"
        cell.textLabel?.numberOfLines = 0
        cell.accessoryType = .DisclosureIndicator
        return cell
    }
    //for an entry selected
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedEntry = listOfEntries[indexPath.row]
        
        print("selected a entry: " + selectedEntry.title);
        
        let viewController = EntryViewController()
        print("loaded vc")
        viewController.toPass = selectedEntry
        print("toPass = " + viewController.toPass.title)
        self.navigationController?.pushViewController(viewController, animated: true)
        
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
