//
//  MapViewController.swift
//  Nomad
//
//  Created by Kristin Beese on 2/25/16.
//  Copyright © 2016 Team 9. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView!

    let regionRadius : CLLocationDistance = 1000
    var trip : Trip
    
    init(trip: Trip) {
        self.trip = trip
        super.init(nibName: "MapViewController", bundle: NSBundle.mainBundle())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //helper method
    func centerMapOnLocation(location : CLLocation) {
        //location is the center point
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.delegate = self
        
        self.title = "Map"
        
        let entriesWithCoords = trip.entries.filter { (current) -> Bool in
            if (current.coords) != nil {
                return true
            }
            
            return false
        }
        
        
        // plot starting point
        if let point = trip.startCoords {
            let a = MKPointAnnotation()
            a.coordinate = point.coordinate
            a.title = "Starting Point"
            self.mapView.addAnnotation(a)
        }
        
        //plot ending point
        if let point = trip.endCoords {
            let a = MKPointAnnotation()
            a.coordinate = point.coordinate
            a.title = "Ending Point"
            self.mapView.addAnnotation(a)
        }
        
        // plotting entries on map
        for entry in entriesWithCoords {
            // make markings on the map
            let a = MKPointAnnotation()
            a.coordinate = (entry.coords?.coordinate)!
            a.title = entry.title
            a.subtitle = entry.info
            self.mapView.addAnnotation(a)
        }

        // set initial position
        if let initialLocation = trip.startCoords {
            centerMapOnLocation(initialLocation)
        }
        
        else if let e = entriesWithCoords.first?.coords {
            centerMapOnLocation(e)
        }
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
        
        anView?.canShowCallout = true
        
        if trip.startCoords != nil && compareCoords(annotation.coordinate, coord2: trip.startCoords!.coordinate) {
            anView?.pinTintColor = UIColor.greenColor()
        }
        
        else if trip.endCoords != nil && compareCoords(annotation.coordinate, coord2: trip.endCoords!.coordinate) {
            anView?.pinTintColor = UIColor.redColor()
        }
        
        else {
            anView?.pinTintColor = UIColor.blueColor()
            anView?.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        }
        
        
        return anView
        
    }
    
    func compareCoords(coord1: CLLocationCoordinate2D, coord2: CLLocationCoordinate2D) -> Bool {
        if coord1.latitude == coord2.latitude && coord1.longitude == coord2.longitude {
            return true
        }
        
        return false
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tappedCallout)))
    }
    
    func pushEntryForPinView(pinView: MKPinAnnotationView) {
        let entryMatch = trip.entries.filter({ (entry) -> Bool in
            
            if let coords = entry.coords {
                return compareCoords(pinView.annotation!.coordinate, coord2: (coords.coordinate))
            }
            
            return false
            
        }).first
        
        
        if entryMatch != nil {
            let viewController = EntryViewController()
            viewController.toPass = entryMatch
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }

    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let pinView = view as? MKPinAnnotationView {
            pushEntryForPinView(pinView)
        }
    }
 
    func tappedCallout(sender: UITapGestureRecognizer) {
        if let pinView = sender.view as? MKPinAnnotationView {
            pushEntryForPinView(pinView)
            pinView.removeGestureRecognizer(sender)

        }
    }
    
}
