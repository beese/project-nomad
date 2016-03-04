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

    override func viewDidLoad() {
        self.title = "Add an Entry"
        super.viewDidLoad()
        //self.title = "Add an Entry"
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
        
        let travel = Entry(_title: title!, _info: info!, _photo: photo, _coords: nil)
        
        //get currentTrip
        var currentTrip : Trip?
        var allTrips: [Trip] = []
        allTrips = Trip.loadAll();
        
        for trip in allTrips {
            if (trip.endDate == nil) {
                currentTrip = trip
            }
        }
        //go through array and find nil
        travel!.trip = currentTrip;
        currentTrip!.entries.append(travel!);
        
        travel!.save()
        //save currentTrip
        currentTrip!.save()
        
        self.navigationController?.popViewControllerAnimated(true)
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
