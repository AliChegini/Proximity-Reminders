//
//  AddReminderController.swift
//  ProximityReminders
//
//  Created by Ehsan on 25/12/2018.
//  Copyright © 2018 Ali C. All rights reserved.
//

import UIKit
import CoreData

class AddReminderController: UIViewController {
    
    @IBOutlet weak var reminder: UITextField!
    // will be used to get the existing context from master view
    var context: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        
        guard let rm = NSEntityDescription.insertNewObject(forEntityName: "Reminder", into: context) as? Reminder else {
            return
        }
        
        guard let text = reminder.text, !text.isEmpty else {
            return
        }
        
        rm.text = text
        context.saveChanges()
        
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    

}
