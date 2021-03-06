//
//  TripViewController.swift
//  Nomad
//
//  Created by Kristin Beese on 2/25/16.
//  Copyright © 2016 Team 9. All rights reserved.
//

import UIKit

class TripViewController: UITableViewController, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate{
    var toPass : Trip!
    var listOfEntries : [Entry]!
    
    var trip : Trip!
    
    override func viewDidLoad() {
        print("TripViewController viewDidLoad()")
        
        self.trip = toPass
        
        if (self.trip.endDate == nil) {
            // multiple buttons in navigation controller
            let rightAddBarButtonItem:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(addEntry))
            let rightEditBarButtonItem:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: #selector(editTrip))
            self.navigationItem.setRightBarButtonItems([rightAddBarButtonItem,rightEditBarButtonItem], animated: true)
            
            // + button only
            //self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(addEntry))
        }
        
        super.viewDidLoad()
        
        if let _trip = trip {
            print(_trip.title);
            print(_trip.entries)
        } else {
            print("whyy");
        }
        self.title = trip.title
        self.listOfEntries = trip.entries
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "center")
        
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
    
    override func viewWillAppear(animated: Bool) {
        
        //reload entries from disk to update table view
        // load that file from the disk and use super's loadFromDisk to extract the trip
        print("after loading from disk, adventure is \(trip) at")
        print("toPass")
        print(toPass.entries)
        //trip = toPass
        trip = Trip.loadFromDisk(trip!.filePath() as String)
        self.title = trip.title
        print("trip")
        print(trip.entries)
        print("\(trip?.filePath())")
        // load in the trip's entries
        var loadedEntries: [Entry] = []
        
        //let entriesFolder = (folder as NSString).stringByAppendingPathComponent("entries")
        let entriesFolder = (trip!.filePath().stringByDeletingLastPathComponent as NSString).stringByAppendingPathComponent("entries")
        // check if folder exists
        
        if NSFileManager.defaultManager().fileExistsAtPath(entriesFolder) {
            // load in the entries
            do {
                let allEntries = try NSFileManager.defaultManager().contentsOfDirectoryAtPath(entriesFolder as String)
            
                // loop through entries
                for entry in allEntries {
                    let entryPath = (entriesFolder as NSString).stringByAppendingPathComponent(entry as String)
                    
                    let entryObject: Entry? = Entry.loadFromDisk(entryPath)
                
                    // make sure it isn't nil
                    if let o = entryObject {
                        print("entry is " + o.title)
                        o.trip = trip
                        loadedEntries.append(o)
                    }
                } // end for loop
                
                //sort entries
                loadedEntries.sortInPlace {
                    $1.date.compare($0.date) == .OrderedAscending
                }
                trip!.entries = loadedEntries
                
            } catch {
                print("something went wrong with loading all the entries in TripViewController()")
            }
            
        } // end if
        
        //trip!.entries = loadedEntries
        //listOfEntries = trip!.entries
        
        print("toPass trip file path: \(self.trip!.filePath())")
        print("toPass entries: \(self.trip!.entries)")
        print("listOfEntries: \(listOfEntries)")
        
        tableView.reloadData()
    }
    
    func addEntry() {
        //let vc = AddEntryViewController()
        let vc = AddEntryVC()
        vc.editMode = false
        let nav = self.navigationController!
        self.navigationController?.popToRootViewControllerAnimated(true)
        nav.pushViewController(vc, animated: true)
    }
    
    func editTrip() {
        print("Edit button pushed in TripViewController")
        let vc = AddTripViewController()
        vc.editMode = true
        vc.toPass = trip
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Adventure Information"
        }
        else {
            return "Entries"
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var identifier = "cell"
        
        if indexPath.section == 0 && (indexPath.row == 2 || indexPath.row == 3) {
            identifier = "center"
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath)
        
        if indexPath.section == 0 {
            // Information section
            
            cell.accessoryType = .None
            cell.textLabel?.numberOfLines = 0
            
            if indexPath.row == 0 {
                // display travelers
                cell.textLabel?.text = "Travelers: \(trip!.travelers)"
                cell.accessoryType = .None
                cell.selectionStyle = .None
                
            }
            
            else if indexPath.row == 1 {
                // display trip dates
                
                let formatter = NSDateFormatter()
                formatter.dateFormat = "MMMM d, yyy"
                
                let startString = formatter.stringFromDate(trip!.startDate)
                
                // trip is over
                if (trip!.endDate != nil) {
                    let endString = formatter.stringFromDate(trip!.endDate!)
                    cell.textLabel?.text = "Dates: \(startString) - \(endString)"
                }
                // still on trip
                else {
                    cell.textLabel?.text = "Dates: \(startString) - now"
                }
                
                cell.accessoryType = .None
                cell.selectionStyle = .None
                
            }
            
            else if indexPath.row == 2 {
                // button for the map view
                
                cell.textLabel?.text = "View Map 🗺"
                cell.textLabel?.font = UIFont.boldSystemFontOfSize(UIFont.systemFontSize())
                cell.accessoryType = .DisclosureIndicator
                cell.textLabel?.textAlignment = .Center
            }
            
            else if indexPath.row == 3 {
                // button for sharing trip
                
                cell.textLabel?.text = "Share with Friends"
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
            let attributesTime = [ NSFontAttributeName: UIFont.systemFontOfSize(16),
                               NSForegroundColorAttributeName: UIColor.darkGrayColor() ]
            let attributesTitle = [ NSFontAttributeName: UIFont.systemFontOfSize(18),
                                   NSForegroundColorAttributeName: UIColor.blackColor() ]
             let formattedString = NSMutableAttributedString(string: "\(entry.title)\n", attributes: attributesTitle)
            
            formattedString.appendAttributedString(NSAttributedString(string: time, attributes: attributesTime))
            
            cell.textLabel?.attributedText = formattedString
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
        if trip == nil || (listOfEntries.count == 0 && trip!.endDate == nil) {
            return 0
        } else if (listOfEntries.count == 0 ) {
            return 1
        }
        
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
            if indexPath.row == 2 {
                // viewing the map
                self.tableView.reloadData()
                let viewController = MapViewController(trip: trip!)
                print("loaded vc")
                self.navigationController?.pushViewController(viewController, animated: true)
                
            }
            
            else if indexPath.row == 3 {
                // sharing options
                self.tableView.reloadData()
                
                var shareText = ""
                
                let formatter = NSDateFormatter()
                formatter.dateFormat =  "EEE, MMMM d 'at' h:mm a"
                let starttime = formatter.stringFromDate(trip.startDate)
                
                if trip.endDate == nil {
                    shareText += "I am using the Nomad App to track my current \(trip.title) Adventure where I am travelling with \(trip.travelers).  The adventure started on \(starttime).  Download Nomad from the iOS App store today!"
                }
                else {
                    let endtime = formatter.stringFromDate(trip.endDate!)
                    shareText += "I used the Nomad App to track my \(trip.title) Adventure when I travelled with \(trip.travelers).  The adventure started on \(starttime) and ended on \(endtime).  Nomad the app from the iOS App store today!"
                }
                
                let activityViewController = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
                self.presentViewController(activityViewController, animated: true, completion: nil)
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
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let index = indexPath.row
            print ("delete " + self.listOfEntries[index].title)
            let delPath = self.listOfEntries[index].filePath()
            print ("count=\(self.listOfEntries.count)")

            // Delete the row from the listOfEntries variable
            self.listOfEntries.removeAtIndex(index)
            self.trip.entries.removeAtIndex(index)
            print("Removed from listOfEntries array > 1")
            // Remove row from table view
            tableView.beginUpdates()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            print("Removed from Table view")
            
            if listOfEntries.count == 0 && trip.endDate == nil {
                tableView.deleteSections(NSIndexSet(indexesInRange: NSMakeRange(0, 2)), withRowAnimation: .None)
            }
            else if listOfEntries.count == 0 {
                tableView.deleteSections(NSIndexSet(index: 1), withRowAnimation: .None)
            }
            tableView.endUpdates()

            // Remove file frm disk
            let fileManager = NSFileManager.defaultManager()
            do {
                try fileManager.removeItemAtPath(delPath as String)
                print("deleted")
            }
            catch let error as NSError {
                print("Ooops! Something went wrong: \(error)")
            }
            
            
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    // empty data set

    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "No Entries"
        
        let attributes = [ NSFontAttributeName: UIFont.boldSystemFontOfSize(18),
                           NSForegroundColorAttributeName: UIColor.darkGrayColor() ]
        
        return NSAttributedString(string: text, attributes: attributes)
    }
    
    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "Oh no! You haven't added any entries to your trip yet. Log something you've done on your trip!"
        
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
        
        return NSAttributedString(string: "Add Entry", attributes: attr)
    }
    
    func emptyDataSet(scrollView: UIScrollView!, didTapButton button: UIButton!) {
        //let vc = AddEntryViewController()
        let vc = AddEntryVC()
        vc.editMode = false
        let nav = self.navigationController!
        self.navigationController?.popToRootViewControllerAnimated(true)
        nav.pushViewController(vc, animated: true)        
    }
    
}
