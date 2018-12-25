//
//  CoreDataStack.swift
//  ProximityReminders
//
//  Created by Ehsan on 24/12/2018.
//  Copyright © 2018 Ali C. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    private lazy var persistentContainer: NSPersistentContainer = {
       let container = NSPersistentContainer(name: "ProximityReminders")
        container.loadPersistentStores() { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error: \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    
    lazy var managedObjectContext: NSManagedObjectContext = {
       let container = self.persistentContainer
        return container.viewContext
    }()
    
}


extension NSManagedObjectContext {
    func saveChanges() {
        if self.hasChanges {
            do {
                try save()
            } catch {
                // TODO : alert user something went wrong
            }
        }
    }
}



