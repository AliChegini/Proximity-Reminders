//
//  DetailViewController.swift
//  ProximityReminders
//
//  Created by Ehsan on 24/12/2018.
//  Copyright © 2018 Ali C. All rights reserved.
//

import UIKit
import CoreData
import MapKit

class DetailViewController: UIViewController {

    var reminder: Reminder?
    var context: NSManagedObjectContext!
    var manager: LocationManager!
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var reminderSwitch: UISwitch!
    @IBOutlet weak var mapView: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let reminderUnwrapped = reminder else {
            return
        }
        
        textField.text = reminderUnwrapped.text
        reminderSwitch.setOn(reminderUnwrapped.reminderState, animated: false)
        
        // Create annotations
        let annotation = MKPointAnnotation()
        annotation.title = reminderUnwrapped.locationName
        annotation.coordinate = CLLocationCoordinate2DMake(reminderUnwrapped.latitude, reminderUnwrapped.longitude)
        self.mapView.addAnnotation(annotation)

        // Zooming on annotation
        let coordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(reminderUnwrapped.latitude, reminderUnwrapped.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        self.mapView.setRegion(region, animated: true)

    }
    
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        if let reminder = reminder, let newText = textField.text {
            reminder.text = newText
            reminder.reminderState = reminderSwitch.isOn
            
            // turning off monitoring if switch is off
            if reminderSwitch.isOn == false {
                manager.stopMonitoring(latitude: reminder.latitude, longitude: reminder.longitude, locationName: reminder.locationName)
            } else if reminderSwitch.isOn == true {
                // turning on monitoring if switch is on
                manager.setupGeoFenceAndMonitor(latitude: reminder.latitude, longitude: reminder.longitude, locationName: reminder.locationName)
            }
            
            context.saveChanges()
            navigationController?.navigationController?.popViewController(animated: true)
        }
    }
    
    
    @IBAction func deleteItem(_ sender: UIButton) {
        if let reminder = reminder {
            // turning off monitoring if reminder is getting deleted
            manager.stopMonitoring(latitude: reminder.latitude, longitude: reminder.longitude, locationName: reminder.locationName)
    
            context.delete(reminder)
            context.saveChanges()
            navigationController?.navigationController?.popViewController(animated: true)
        }
    }
    
}
