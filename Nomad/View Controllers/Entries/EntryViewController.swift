//
//  EntryViewController.swift
//  Nomad
//
//  Created by Raj Iyer on 2/29/16.
//  Copyright © 2016 Team 9. All rights reserved.
//


import UIKit

class EntryViewController: UITableViewController {
    var toPass : Entry!
    
    override func viewDidLoad() {
        print("in entry view");

        super.viewDidLoad()

        if let _entry = toPass {
            print(_entry.title);
            //print(_entry.info)
        } else {
            print("whyy");
        }
        self.title = "Details"
        //self.listOfEntries = toPass.entries'
        print("before calling tableview");
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 88
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        //self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Edit, target: self, action: "editTapped")
        
        let addEntryVC = AddEntryViewController()
        addEntryVC.editMode = false
        print("edit mode = \(addEntryVC.editMode)")
    }
    
    override func viewWillAppear(animated: Bool) {
        tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        print("in EntryViewController tableView()")
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        // Configure the cell...
        // Put in the name of the trip
        let entry : Entry! = Entry.loadFromDisk(toPass.filePath() as String)
        let formatter = NSDateFormatter()
        formatter.dateFormat =  "EEE, MMMM d, yyy 'at' h:mm a"
        
        let time = formatter.stringFromDate(entry.date)
        
        var entryInfo: String
        
        if entry.info != nil{
            entryInfo = entry.info!
        } else {
            entryInfo = ""
        }
        cell.textLabel?.text = "\(entry.title)\non \(time)\nat \(entry.coords)\n\(entryInfo)\n"
        
        cell.textLabel?.numberOfLines = 0
        return cell
    }
    
    func editTapped() {
        // pass entry information to AddEntryViewController
        print("Entry Edit")
        let selectedEntry = toPass
        print("selected a entry: " + selectedEntry.title);
        
        let AEViewController = AddEntryViewController()
        print("loaded vc")
        AEViewController.passToEditEntry = selectedEntry
        AEViewController.editMode = true
        print("passToEditEntry = " + AEViewController.passToEditEntry.title)
        print("edit mode from EntryVC = \(AEViewController.editMode)")

        //push AddEntryViewController
        self.navigationController?.pushViewController(AEViewController, animated: true)
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
        return 1
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
