//
//  DataSource.swift
//  ProximityReminders
//
//  Created by Ehsan on 26/12/2018.
//  Copyright © 2018 Ali C. All rights reserved.
//

import UIKit
import CoreData

class DataSource: NSObject, UITableViewDataSource {
    // the following will be used for dependency injection
    private let tableView: UITableView
    var context: NSManagedObjectContext
    var manager: LocationManager
    
    lazy var fetchedResultsController: ReminderFetchedResultsController = {
        return ReminderFetchedResultsController(managedObjectContext: self.context, tableView: self.tableView)
    }()
    
    init(tableView: UITableView, context: NSManagedObjectContext, manager: LocationManager) {
        self.tableView = tableView
        self.context = context
        self.manager = manager
    }
    
    func object(at indexPath: IndexPath) -> Reminder {
        return fetchedResultsController.object(at: indexPath)
    }
    
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = fetchedResultsController.sections?[section] else {
            return 0
        }
        return section.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        let item = fetchedResultsController.object(at: indexPath)
        
        cell.textLabel?.text = item.text
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let item = fetchedResultsController.object(at: indexPath)
        // turning off monitoring if reminder is getting deleted
        manager.stopMonitoring(latitude: item.latitude, longitude: item.longitude, locationName: item.locationName)
        
        context.delete(item)
        context.saveChanges()
    }
    
}
