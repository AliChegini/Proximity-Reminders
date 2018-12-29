//
//  AddReminderController.swift
//  ProximityReminders
//
//  Created by Ehsan on 25/12/2018.
//  Copyright © 2018 Ali C. All rights reserved.
//

import UIKit
import CoreData
import MapKit

class AddReminderController: UIViewController, UISearchBarDelegate {

    // context will be used to get the existing context from master view
    var context: NSManagedObjectContext!
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var switchOutlet: UISwitch!
    
    // Variables to be used for saving in Core Data
    var storedLatitude: Double?
    var storedLongitude: Double?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    @IBAction func searchButton(_ sender: Any) {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        present(searchController, animated: true, completion: nil)
        
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // ignoring user interactions
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        // Hide search bar
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        
        // Create the search request
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = searchBar.text
        
        let activeSearch = MKLocalSearch(request: searchRequest)
        
        activeSearch.start { (response, error) in
            
            UIApplication.shared.endIgnoringInteractionEvents()
            
            if response == nil {
                print("ERROR")
            } else {
                // Remove all annotations
                let annotations = self.mapView.annotations
                self.mapView.removeAnnotations(annotations)
                
                // Getting coordinates
                guard let latitude = response?.boundingRegion.center.latitude else {
                    return
                }
                guard let longitude = response?.boundingRegion.center.longitude else {
                    return
                }
                
                self.storedLatitude = latitude
                self.storedLongitude = longitude
                
                // Create annotations
                let annotation = MKPointAnnotation()
                annotation.title = searchBar.text
                annotation.coordinate = CLLocationCoordinate2DMake(latitude, longitude)
                self.mapView.addAnnotation(annotation)
                
                // Zooming on annotation
                let coordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
                let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                let region = MKCoordinateRegion(center: coordinate, span: span)
                self.mapView.setRegion(region, animated: true)
            }
        }
        
    }
    
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        
        guard let reminder = NSEntityDescription.insertNewObject(forEntityName: "Reminder", into: context) as? Reminder else {
            return
        }
        
        guard let text = textField.text, !text.isEmpty else {
            return
        }
        
        reminder.text = text
        reminder.reminderState = switchOutlet.isOn
        
        if let storedLatitude = storedLatitude, let storedLongitude = storedLongitude {
            reminder.latitude = storedLatitude
            reminder.longitude = storedLongitude
        }
        
        context.saveChanges()
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    

}
