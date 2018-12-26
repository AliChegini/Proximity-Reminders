//
//  DetailViewController.swift
//  ProximityReminders
//
//  Created by Ehsan on 24/12/2018.
//  Copyright © 2018 Ali C. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UITableViewController {

    var reminder: Reminder?
    
    var context: NSManagedObjectContext!
    
    @IBOutlet weak var textField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let reminder = reminder {
            textField.text = reminder.text
        }
        
    }
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        
        
        
        if let reminder = reminder, let newText = textField.text {
            reminder.text = newText
            context.saveChanges()
            navigationController?.navigationController?.popViewController(animated: true)
        }
    }
    
    
    @IBAction func deleteItem(_ sender: UIButton) {
        if let reminder = reminder {
            context.delete(reminder)
            context.saveChanges()
            navigationController?.navigationController?.popViewController(animated: true)
        }
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell")!
//
//        return cell
//    }
    
}
