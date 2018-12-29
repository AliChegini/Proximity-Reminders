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
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (didallow, error) in
            
        }
        
        setupNotification()
        
    
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
    
    // Creating notification
    func setupNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Test Title"
        content.subtitle = "Test SubTitle"
        content.body = "Test Body"
        content.badge = 1
        content.sound = UNNotificationSound.default
        
        
        //getting the notification trigger
        //it will be called after 5 seconds
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3.0, repeats: false)
        
        //create notification request
        let request = UNNotificationRequest(identifier: "SimplifiedIOSNotification", content: content, trigger: trigger)
        
        //adding the notification to notification center
        UNUserNotificationCenter.current().add(request) { (error) in
            
        }
    }
    

    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
}
