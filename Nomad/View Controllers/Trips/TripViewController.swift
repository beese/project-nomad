//
//  TripViewController.swift
//  Nomad
//
//  Created by Kristin Beese on 2/25/16.
//  Copyright © 2016 Team 9. All rights reserved.
//

import UIKit

class TripViewController: UITableViewController {
    var toPass : Trip!
    var listOfEntries : [Entry]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let _trip = toPass {
            print(_trip.title);
            print(_trip.entries)
        } else {
            print("whyy");
        }
        self.title = toPass.title
        self.listOfEntries = toPass.entries
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 88
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Trip Information"
        }
        else {
            return "Entries"
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        if indexPath.section == 0 {
            // Information section
            
            cell.accessoryType = .None
            cell.textLabel?.numberOfLines = 0
            
            if indexPath.row == 0 {
                // display trip title
                
                cell.textLabel?.text = "Trip Title: \(toPass.title)"
                cell.accessoryType = .None
                cell.selectionStyle = .None
                
            }
            
            
            else if indexPath.row == 1 {
                // display travelers
                cell.textLabel?.text = "Travelers: \(toPass.travelers)"
                cell.accessoryType = .None
                cell.selectionStyle = .None
                
            }
            
            else if indexPath.row == 2 {
                // display trip dates
                
                let formatter = NSDateFormatter()
                formatter.dateFormat = "MMMM d, yyy"
                
                let startString = formatter.stringFromDate(toPass.startDate)
                
                // trip is over
                if (toPass.endDate != nil) {
                    let endString = formatter.stringFromDate(toPass.endDate!)
                    cell.textLabel?.text = "Dates: \(startString) - \(endString)"
                }
                // still on trip
                else {
                    cell.textLabel?.text = "Dates: \(startString) - now"
                }
                
                cell.accessoryType = .None
                cell.selectionStyle = .None
                
            }
            
            else if indexPath.row == 3 {
                // button for the map view
                
                cell.textLabel?.text = "View Map 🗺"
                cell.textLabel?.font = UIFont.boldSystemFontOfSize(UIFont.systemFontSize())
                cell.accessoryType = .DisclosureIndicator
                cell.textLabel?.textAlignment = .Center
            }
            
        }
        
        else {
            
            let entry = listOfEntries[indexPath.row]
            
            let formatter = NSDateFormatter()
            formatter.dateFormat =  "EEE, MMMM d, yyy 'at' h:mm a"
            let time = formatter.stringFromDate(entry.date)
            cell.textLabel?.text = "\(entry.title)\n\(time)"
            cell.textLabel?.numberOfLines = 0
            cell.accessoryType = .DisclosureIndicator
        }
       
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return 4
        }
        else {
            return listOfEntries.count
        }
    }
    
    //for an entry selected
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        if indexPath.section == 0 {
            if indexPath.row == 3 {
                // viewing the map
                
                let viewController = MapViewController(trip: toPass)
                print("loaded vc")
                self.navigationController?.pushViewController(viewController, animated: true)
                
            }
            
            return
        }
        
        
        else {
            let selectedEntry = listOfEntries[indexPath.row]
            
            print("selected a entry: " + selectedEntry.title);
            
            let viewController = EntryViewController()
            print("loaded vc")
            viewController.toPass = selectedEntry
            print("toPass = " + viewController.toPass.title)
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        
    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
