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

class MasterViewController: UITableViewController, UNUserNotificationCenterDelegate, LocationManagerDelegate {
    
    var managedObjectContext = CoreDataStack().managedObjectContext
    var locationManager = LocationManager()
    // Dependency injection
    lazy var dataSource: DataSource = {
        return DataSource(tableView: self.tableView, context: self.managedObjectContext, manager: self.locationManager)
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = dataSource
        
        // root view controller act as the delegate
        // this is the view which never gets dismissed
        locationManager.delegate = self
        
        // User notification center delegate
        UNUserNotificationCenter.current().delegate = self
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (didAllow, error) in
            if let error = error {
                print(error)
            }
        }
        
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newReminder" {
            if let navigationController = segue.destination as? UINavigationController {
                if let addReminderController = navigationController.topViewController as? AddReminderController {
                    addReminderController.context = managedObjectContext
                    addReminderController.manager = locationManager
                }
            }
        } else if segue.identifier == "showDetail" {
            if let navigationController  = segue.destination as? UINavigationController {
                if let detailViewController = navigationController.topViewController as? DetailViewController, let indexPath = tableView.indexPathForSelectedRow {
                    let item = dataSource.object(at: indexPath)
                    detailViewController.reminder = item
                    detailViewController.context = managedObjectContext
                    detailViewController.manager = locationManager
                }
            }
        }
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
}

// LocationManager Delegate methods
extension MasterViewController {
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        setupNotification(type: "Entry Notification", body: "You have entered \(region.identifier)")
        print("enter notification is setup")
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        setupNotification(type: "Exit Notification", body: "You have exited \(region.identifier)")
        print("exit notification is setup")
    }
}



// User Notification methods
extension MasterViewController {
    
    func setupNotification(type: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = type
        content.body = body
        content.sound = UNNotificationSound.default
        
        //let trigger = UNLocationNotificationTrigger(region: region, repeats: true)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1.0, repeats: false)
        
        let request = UNNotificationRequest(identifier: "Reminder", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print(error)
            }
        }
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
}
