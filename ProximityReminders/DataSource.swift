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
    private let tableView: UITableView
    // context will be used for dependency injection
    var context: NSManagedObjectContext
    
    init(tableView: UITableView, context: NSManagedObjectContext) {
        
    }
}
