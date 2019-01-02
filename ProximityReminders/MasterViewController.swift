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
    
    lazy var dataSource: DataSource = {
        return DataSource(tableView: self.tableView, context: self.managedObjectContext)
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = dataSource
        
        // root view controller act as the delegate
        // this is the view which never gets dismissed
        locationManager.delegate = self
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
                }
            }
        }
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
}


extension MasterViewController {
    // LocationManager Delegate methods
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("user entered \(region)")
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("user exited \(region)")
    }
}
