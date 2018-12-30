//
//  MasterViewController.swift
//  ProximityReminders
//
//  Created by Ehsan on 24/12/2018.
//  Copyright © 2018 Ali C. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation
import UserNotifications

class MasterViewController: UITableViewController, CLLocationManagerDelegate, UNUserNotificationCenterDelegate {
    
    var managedObjectContext = CoreDataStack().managedObjectContext
    
    lazy var dataSource: DataSource = {
        return DataSource(tableView: self.tableView, context: self.managedObjectContext)
    }()
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = dataSource
        
        // Location related 
//        locationManager.delegate = self
//        locationManager.requestAlwaysAuthorization()
//        locationManager.startUpdatingLocation()
//        locationManager.distanceFilter = 100
//        let geoFenceRegion: CLCircularRegion = CLCircularRegion(center: CLLocationCoordinate2DMake(item.latitude, item.longitude), radius: 40, identifier: item.text)
        
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newReminder" {
            if let navigationController = segue.destination as? UINavigationController {
                if let addReminderController = navigationController.topViewController as? AddReminderController {
                    addReminderController.context = managedObjectContext
                }
            }
        } else if segue.identifier == "showDetail" {
            if let navigationController  = segue.destination as? UINavigationController {
                if let detailViewController = navigationController.topViewController as? DetailViewController, let indexPath = tableView.indexPathForSelectedRow {
                    let item = dataSource.object(at: indexPath)
                    detailViewController.reminder = item
                    detailViewController.context = managedObjectContext
                }
            }
        }
    }
    

    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
}
