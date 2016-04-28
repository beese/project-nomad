//
//  AddEntryVC.swift
//  Nomad
//
//  Created by Raj Iyer on 4/26/16.
//  Copyright © 2016 Team 9. All rights reserved.
//

import UIKit

class AddEntryVC: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var titleTextBox: UITextField!
    @IBOutlet weak var infoTextBox: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var chooseButton: UIButton!
    @IBOutlet weak var deleteImage: UIButton!
    
    var passToEditEntry : Entry!
    var editMode : Bool = false
    var buttonText: String? = ""
    
    override func viewDidLoad() {
        print("in addEntryVC, editMode is \(editMode)")
        
        self.buttonText = self.chooseButton.titleForState(.Normal)
        if ((editMode) != false) {
            self.title = "Edit Entry"
            print("Loading selected entry to edit into text boxes")
            let selectedEntry = passToEditEntry
            titleTextBox.text = selectedEntry.title
            infoTextBox.text = selectedEntry.info
            if (selectedEntry.photo != nil) {
                deleteImage.hidden = false
                chooseButton.hidden = true
                photoImageView.image = selectedEntry.photo!.photo
            }
            else {
                deleteImage.hidden = true
            }
        }
        else {
            self.title = "Add an Entry"
            deleteImage.hidden = true
        }
        
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Save, target: self, action: #selector(saveTapped))
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func saveTapped() {
        print("Entry Save")
        
        //get info from text boxes
        let title = titleTextBox.text
        let info = infoTextBox.text
        // This creates an NSData instance containing the raw bytes for a JPEG image at a 60% quality setting.
        //let photo = Photo(_photo: NSData(data:UIImageJPEGRepresentation(photoImageView.image!, 0.6)!))
        
        let photo = photoImageView.image
        print("default image in add entry")
        print(photoImageView.image)
        let image = Photo (_photo: photo)
        titleTextBox.resignFirstResponder()
        infoTextBox.resignFirstResponder()
        
        if (editMode == false) {
            SwiftSpinner.show("Fetching GPS Coordinates...", animated: true);
            
            GPSHelper.sharedInstance.getQuickLocationUpdate { (locations) -> (Void) in
                
                let travel = Entry(_title: title!, _info: info!, _photo: image!, _coords: locations)
                print("Entry Title is " + travel!.title)
                
                //get currentTrip
                var currentTrip : Trip?
                var allTrips: [Trip] = []
                allTrips = Trip.loadAll();
                
                for trip in allTrips {
                    if (trip.endDate == nil) {
                        currentTrip = trip
                    }
                }
                
                print("Current trip is " + currentTrip!.title)
                //go through array and find nil
                travel!.trip = currentTrip;
                
                print(currentTrip!.entries);
                print("Saved trip to entry: " + travel!.trip!.title)
                
                travel!.save()
                //save currentTrip
                currentTrip!.save()
                
                SwiftSpinner.hide()
                
                self.navigationController?.popViewControllerAnimated(true)
                
                if locations == nil {
                    let alertController = UIAlertController(title: "GPS Coordinates Failed", message: "Entry created without coordinates", preferredStyle: .Alert)
                    alertController.addAction(UIAlertAction(title: "Okay", style: .Default, handler: nil))
                    self.navigationController?.presentViewController(alertController, animated: true, completion: nil)
                }
            } //end gps
        } //end if
        
        if (editMode == true) {
            print("passToEditEntry:\(passToEditEntry)")
            
            
            // initiate updated entry
            let travel = Entry(_title: title!, _date: passToEditEntry.date, _info: info!, _photo: image!, _coords: passToEditEntry.coords, _guid: passToEditEntry.guID)
            print("Entry Title is " + travel!.title)
            
            //save updated entry
            //get currentTrip
            var currentTrip : Trip?
            var allTrips: [Trip] = []
            allTrips = Trip.loadAll();
            
            for trip in allTrips {
                if (trip.endDate == nil) {
                    currentTrip = trip
                }
            }
            
            print("Current trip is " + currentTrip!.title)
            //go through array and find nil
            travel!.trip = currentTrip;
            
            print(currentTrip!.entries);
            print("Saved trip to entry: " + travel!.trip!.title)
            
            //delete old file
            let fileManager = NSFileManager.defaultManager()
            do {
                try fileManager.removeItemAtPath(passToEditEntry.filePath() as String)
                print("\(passToEditEntry.filePath() as String) is deleted")
            }
            catch let error as NSError {
                print("Something went wrong when deleting the old entry file: \(error)")
            }
            
            travel!.save()
            //save currentTrip
            currentTrip!.save()
            
            currentTrip!.entries.append(travel!)
            print("after editing, trip entries: \(currentTrip?.entries)")
            
            let vc = EntryViewController()
            vc.toPass = travel!
            
            // TODO: update view controller
            //self.navigationController?.pushViewController(vc, animated: true)
            super.viewWillAppear(true)
            self.navigationController?.popViewControllerAnimated(true)
        }
        
    }
    
    // MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismissViewControllerAnimated(true, completion: nil)
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        // The info dictionary contains multiple representations of the image, and this uses the original.
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        // Set photoImageView to display the selected image.
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let factor = screenSize.size.width / selectedImage.size.width
        
        let size = CGSizeApplyAffineTransform(selectedImage.size, CGAffineTransformMakeScale(factor, factor))
        let hasAlpha = false
        let scale: CGFloat = 0.0 // Automatically use scale factor of main screen
        
        UIGraphicsBeginImageContextWithOptions(size, !hasAlpha, scale)
        selectedImage.drawInRect(CGRect(origin: CGPointZero, size: size))
        var scaledImage: UIImage!
        scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        photoImageView.image = scaledImage
        
        self.chooseButton.setTitle("", forState: .Normal)
        
        // Dismiss the picker.
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: Actions
    @IBAction func hideKeyboards(sender: AnyObject) {
        titleTextBox.resignFirstResponder()
        infoTextBox.resignFirstResponder()
    }
    
    @IBAction func selectImage(sender: UIButton) {
        print("tap gesture works");
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .PhotoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        
        presentViewController(imagePickerController, animated: true, completion: nil)
    }
 
    @IBAction func deletePhoto(sender: AnyObject) {
        

        
        print("deleting\n");
        photoImageView.image = nil
        
        let photo = photoImageView.image
        let image = Photo (_photo: photo)

        
        passToEditEntry.photo = image
        //viewDidLoad()
        
        
    }
    
    
}
