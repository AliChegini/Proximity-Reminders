//
//  Reminder+CoreDataProperties.swift
//  ProximityReminders
//
//  Created by Ehsan on 25/12/2018.
//  Copyright © 2018 Ali C. All rights reserved.
//
//

import Foundation
import CoreData


extension Reminder {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Reminder> {
        let request = NSFetchRequest<Reminder>(entityName: "Reminder")
        request.sortDescriptors = [NSSortDescriptor(key: "text", ascending: true)]
        return request
    }

    @NSManaged public var text: String
    @NSManaged public var reminderState: Bool
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double

}
