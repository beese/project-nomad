//
//  EntryViewController.swift
//  Nomad
//
//  Created by Raj Iyer on 2/29/16.
//  Copyright © 2016 Team 9. All rights reserved.
//


import UIKit
import MapKit

class EntryViewController: UITableViewController, MKMapViewDelegate {
    var toPass : Entry!
    var imageView: UIImageView!
    var scaledImage: UIImage!
    
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
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "map")
        if ( toPass.photo != nil) {
            print("photo info")
            print(toPass.photo)
            print(toPass.photo!.photo?.scale)
            print(toPass.photo!.photo?.imageOrientation)
            print(toPass.photo!.photo?.CGImage)
        }


        //loading image
        if (toPass.photo == nil) {
            print("no image")
        } else {
            let image = toPass.photo!.photo
        
            //scaling image to screen width
            let screenSize: CGRect = UIScreen.mainScreen().bounds
            let factor = screenSize.size.width / image!.size.width
            
            let size = CGSizeApplyAffineTransform(image!.size, CGAffineTransformMakeScale(factor, factor))
            let hasAlpha = false
            let scale: CGFloat = UIScreen.mainScreen().scale // Automatically use scale factor of main screen
        
            UIGraphicsBeginImageContextWithOptions(size, !hasAlpha, scale)
            image!.drawInRect(CGRect(origin: CGPointZero, size: size))
        
            scaledImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        
            imageView = UIImageView(image: scaledImage!)
            imageView.sizeToFit()
        }
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 88
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None

        //imageView.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: 200)
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        //self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        let rightShareBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: #selector(shareEntry))
        
        if(toPass.trip.endDate == nil) {
            // show edit and show share buttons
            let rightEditBarButtonItem:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: #selector(editTapped))
            self.navigationItem.setRightBarButtonItems([rightEditBarButtonItem,rightShareBarButtonItem], animated: false)
        }
        else {
            // show share buttons
            self.navigationItem.rightBarButtonItem = rightShareBarButtonItem
        }
        
        let addEntryVC = AddEntryViewController()
        addEntryVC.editMode = false
        print("edit mode = \(addEntryVC.editMode)")
    }
    
    override func viewWillAppear(animated: Bool) {
        let updatedEntry : Entry! = Entry.loadFromDisk(toPass.filePath() as String)
        
        toPass.title = updatedEntry.title
        toPass.info = updatedEntry.info
        toPass.photo = updatedEntry.photo
        
        tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        print("in EntryViewController tableView()")
        
        var identifier = "cell"
        
        if indexPath.row == 1 {
            identifier = "map"
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath)
        
        cell.selectionStyle = .None
        
        // Configure the cell...
        // Put in the name of the trip
        let entry : Entry! = Entry.loadFromDisk(toPass.filePath() as String)
        if (indexPath.row == 0) {
        
            let formatter = NSDateFormatter()
            formatter.dateFormat =  "EEE, MMMM d, yyy 'at' h:mm a"
        
            let time = formatter.stringFromDate(entry.date)
        
            
        
            let titleText = "\(entry.title)\n"
            let timeText = "on \(time)"
            
            
            //attributes for title
            let attributes1 = [ NSFontAttributeName: UIFont.boldSystemFontOfSize(22),
                           NSForegroundColorAttributeName: UIColor.blackColor() ]
            let para = NSMutableParagraphStyle()
            para.lineBreakMode = .ByWordWrapping
            para.alignment = .Left
            
            //attributes for time
            let attributes2 = [ NSFontAttributeName: UIFont.systemFontOfSize(18),
                                NSForegroundColorAttributeName: UIColor.darkGrayColor(),
                                NSParagraphStyleAttributeName: para  ]
            
        
            let titleFormatted = NSMutableAttributedString(string: titleText, attributes: attributes1)
            
            titleFormatted.appendAttributedString(NSAttributedString(string: timeText, attributes: attributes2))
       
        
            cell.textLabel?.attributedText = titleFormatted
       
            //cell.backgroundColor = UIColor(red: 0.4627, green: 0.8549, blue: 0.698, alpha: 1.0)
        
            cell.textLabel?.numberOfLines = 0
        
        }
            
        else if (indexPath.row == 1) {
            
            if (toPass.coords != nil && cell.contentView.viewWithTag(1234) == nil) {
                // build the map view
                let view = MKMapView(frame: CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.size.width, height: 100))
                view.tag = 1234
                
                
                let a = MKPointAnnotation()
                a.coordinate = (toPass.coords?.coordinate)!
                view.addAnnotation(a)
                
                
                view.delegate = self
                
                
                //location is the center point
                
                let regionRadius : CLLocationDistance = 1000
                
                let coordinateRegion = MKCoordinateRegionMakeWithDistance(a.coordinate, regionRadius * 2.0, regionRadius * 2.0)
                
                view.setRegion(coordinateRegion, animated: true)
                
                cell.contentView.addSubview(view)
            }
            
        }
        
        else if (indexPath.row == 2) {
            //display picture
            //cell.backgroundColor = UIColor.grayColor()
            //cell.textLabel?.text = "picture goes here"
            print ("update image")
            cell.textLabel?.numberOfLines = 0
            if (toPass.photo != nil) {
                //cell.sizeToFit()
                print("sub view count \(cell.subviews.count)")
                if ( cell.subviews.count > 0) {
                //imageView.removeFromSuperview()
                    cell.subviews[0].removeFromSuperview()
                }
                    cell.addSubview(imageView)
                
            }
        } else if (indexPath.row == 3) {
            var entryInfo: String
            
            if entry.info != nil{
                entryInfo = entry.info!
            } else {
                entryInfo = ""
            }
            let restText = "\(entryInfo)\n"
            
            let para2 = NSMutableParagraphStyle()
            para2.lineBreakMode = .ByWordWrapping
            para2.alignment = .Left
            
            //attributes for description
            let attributes3 = [ NSFontAttributeName: UIFont.systemFontOfSize(18),
                                NSForegroundColorAttributeName: UIColor.blackColor(),
                                NSParagraphStyleAttributeName: para2 ]
            
             cell.textLabel?.attributedText = NSAttributedString(string: restText, attributes: attributes3)
            cell.textLabel?.numberOfLines = 0
            
            
        }
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
    
    func shareEntry() {
        // share selected entry
        
        var shareText = "I used Nomad to track when I went to \(toPass.title) on my \(toPass.trip.title) adventure. "
        
        if toPass.info != nil {
            shareText += "\n\(toPass.info!)\n"
        }
        
        shareText += "Download Nomad from the iOS App store today!"
        
        if toPass.photo != nil {
            let activityViewController = UIActivityViewController(activityItems: [shareText, toPass.photo!.photo!], applicationActivities: nil)
            self.presentViewController(activityViewController, animated: true, completion: nil)
        }
        else {
            let activityViewController = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
            self.presentViewController(activityViewController, animated: true, completion: nil)
        }
        
        
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
        return 4
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let row = indexPath.row
        
        if row == 1 {
            // coordinates
            if (toPass.coords == nil) {
                return 0
            }
            else {
                return 115
            }
            
        }
        else if row == 2 {
            // photo
            if (toPass.photo == nil) {
                return 0
            }
            else {
                let image = toPass.photo!.photo
                let screenSize: CGRect = UIScreen.mainScreen().bounds
                let factor = screenSize.size.width / image!.size.width
                
                let size = CGSizeApplyAffineTransform(image!.size, CGAffineTransformMakeScale(factor, factor))
                let hasAlpha = false
                let scale: CGFloat = UIScreen.mainScreen().scale // Automatically use scale factor of main screen
                
                UIGraphicsBeginImageContextWithOptions(size, !hasAlpha, scale)
                image!.drawInRect(CGRect(origin: CGPointZero, size: size))
                
                scaledImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                imageView = UIImageView(image: scaledImage!)
                imageView.sizeToFit()
                print("height \(scaledImage.size.height)\n")
                return scaledImage.size.height
            }
            
        }
        
        return UITableViewAutomaticDimension
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        var anView = mapView.dequeueReusableAnnotationViewWithIdentifier("pin") as? MKPinAnnotationView
        
        if anView == nil {
            anView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
        }
        
        anView?.annotation = annotation
        
        // change pin color
        
        anView?.pinTintColor = UIColor.blueColor()
        
        return anView
    }
        
}
