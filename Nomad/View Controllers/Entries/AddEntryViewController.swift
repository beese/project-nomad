//
//  AddEntryViewController.swift
//  Nomad
//
//  Created by Kristin Beese on 2/25/16.
//  Copyright © 2016 Team 9. All rights reserved.
//

import UIKit

class AddEntryViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var titleTextBox: UITextField!
    @IBOutlet weak var infoTextBox: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    
    var passToEditEntry : Entry!
    var editMode : Bool = false

    override func viewDidLoad() {
        print("in addEntryVC, editMode is \(editMode)")
        
        if ((editMode) != false) {
            self.title = "Edit Entry"
            print("Loading selected entry to edit into text boxes")
            let selectedEntry = passToEditEntry
            titleTextBox.text = selectedEntry.title
            infoTextBox.text = selectedEntry.info
            //photoImageView.image = selectedEntry.photo
        }
        else {
            self.title = "Add an Entry"
        }
        
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Save, target: self, action: "saveTapped")

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func saveTapped() {
        print("Entry Save")
        let title = titleTextBox.text
        let info = infoTextBox.text
        // This creates an NSData instance containing the raw bytes for a JPEG image at a 60% quality setting.
        let photo = Photo(_photo: NSData(data:UIImageJPEGRepresentation(photoImageView.image!, 0.6)!))
        
        if (editMode == false) {
            titleTextBox.resignFirstResponder()
            infoTextBox.resignFirstResponder()
            
            SwiftSpinner.show("Fetching GPS Coordinates...", animated: true);
            
            GPSHelper.sharedInstance.getQuickLocationUpdate { (locations) -> (Void) in
                
                
                let travel = Entry(_title: title!, _info: info!, _photo: photo, _coords: locations)
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
                    let alertController = UIAlertController(title: "GPS Coordinates Failed", message: "Entry created but there are no entry coordinates", preferredStyle: .Alert)
                    alertController.addAction(UIAlertAction(title: "Okay", style: .Default, handler: nil))
                    self.navigationController?.presentViewController(alertController, animated: true, completion: nil)
                }
                
                
            }
            
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
        photoImageView.image = selectedImage
        
        // Dismiss the picker.
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func hideKeyboards(sender: AnyObject) {
        titleTextBox.resignFirstResponder()
        infoTextBox.resignFirstResponder()
    }
    
    //MARK: Actions

    @IBAction func selectImage(sender: UITapGestureRecognizer) {
        
        // Hide the keyboard.
        //titleTextBox.resignFirstResponder()
        //infoTextBox.resignFirstResponder()
        
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePicker = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePicker.sourceType = .PhotoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        //imagePicker.delegate = self
        
        presentViewController(imagePicker, animated: true, completion: nil)
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
