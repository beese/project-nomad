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
    
    override func viewDidLoad() {
        print("TripViewController viewDidLoad()")
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(addEntry))
        
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
        
        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self
        
        self.tableView.tableFooterView = UIView()
        
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        print("toPass trip file path: \(toPass.filePath())")
        toPass = Trip.loadFromDisk(toPass.filePath() as String)
        print("toPass entries: \(toPass.entries)")
        print("listOfEntries: \(listOfEntries)")
        tableView.reloadData()
    }
    
    func addEntry() {
        let vc = AddEntryViewController()
        self.navigationController?.popToRootViewControllerAnimated(true)
        self.navigationController?.pushViewController(vc, animated: true)
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
        print("the important table view stuff")
        
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
        if toPass == nil || (listOfEntries.count == 0 && toPass.endDate == nil) {
            return 0
        }
        
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("number of rows table view")
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
        let vc = AddEntryViewController()
        self.navigationController?.popToRootViewControllerAnimated(true)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
