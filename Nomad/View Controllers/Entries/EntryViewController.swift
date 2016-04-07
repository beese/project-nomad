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
        
        
        //loading image
        //let url = NSURL(string: "https://index.co/uploads/lists/a981c586ee454b2f0210d64d013870dab46332c8.jpeg")
        //let data = NSData(contentsOfURL: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check
        
        //let image = UIImage(data: data!)
        let image = toPass.photo!.photo
        
        //scaling image to screen width
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let factor = screenSize.size.width / image!.size.width
        print("factor: ")
        print( factor )
        let size = CGSizeApplyAffineTransform(image!.size, CGAffineTransformMakeScale(factor, factor))
        let hasAlpha = false
        let scale: CGFloat = 0.0 // Automatically use scale factor of main screen
        
        UIGraphicsBeginImageContextWithOptions(size, !hasAlpha, scale)
        image!.drawInRect(CGRect(origin: CGPointZero, size: size))
        
        scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        imageView = UIImageView(image: scaledImage!)
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 88
        //imageView.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: 200)
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        //self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Edit, target: self, action: #selector(editTapped))
        
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
            //display picture
            //cell.backgroundColor = UIColor.grayColor()
            //cell.textLabel?.text = "picture goes here"
            cell.textLabel?.numberOfLines = 0
           
            cell.addSubview(self.imageView)
        } else if (indexPath.row == 2) {
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
        return 3
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let section = indexPath.section
        let row = indexPath.row
        if section == 0 && row == 1{
            return scaledImage.size.height
        }
        return UITableViewAutomaticDimension
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
