//
//  EventTableViewController.swift
//  Alpaca
//
//  Created by Paul Dickey2 on 7/23/18.
//  Copyright © 2018 Paul Dickey. All rights reserved.
//

import UIKit
import RealmSwift

class EventTableViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    var events: Results<Event>?

    @IBOutlet weak var eventLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadEvents()
        tableView.rowHeight = 100.00
        tableView.separatorStyle = .none

    }
    
    override func viewWillAppear(_ animated: Bool) {
        let userEventSelection = realm.objects(UserSelectedEvent.self)
        try! realm.write {
            realm.delete(userEventSelection)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadEvents()
    }
    
    //MARK: - TableView Datasource Methods (Code that tells each cell what to load)
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        // Use tags to reference things in the prototype cell
        let label = cell.viewWithTag(1) as! UILabel
    
        if let event = events?[indexPath.row] {
            cell.textLabel?.text = event.time
            label.text = event.name
        }
        return cell
    }
    
    //MARK: - TableView Delegate Methods (Code that says what happens when we select a cell)
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToEventTasks", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! EventTasksTableViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedEvent = events?[indexPath.row]
            
            let newEventSelection = UserSelectedEvent()
            newEventSelection.name = destinationVC.selectedEvent!.eventID
            save(userSelect: newEventSelection)
            
        }
        
    }
    
    //MARK: - Data Manipulation Methods (Save and Load)
    
    func save(event: Event) {
        do {
            try realm.write {
                realm.add(event)
            }
        } catch {
            print("Error saving event \(error)")
        }
        tableView.reloadData()
    }
    
    func save(userSelect: UserSelectedEvent) {
        do {
            try realm.write {
                realm.add(userSelect)
            }
        } catch {
            print("Error saving userSelect \(error)")
        }
    }
    
    func loadEvents () {
        events = realm.objects(Event.self).sorted(byKeyPath: "time", ascending: true)
        tableView.reloadData()
    }
    
    //MARK: - Delete Data From Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        
        if let eventForDeletion = self.events?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(eventForDeletion)
                }
            } catch {
                print("Error deleting event, \(error)")
            }
        }
    }
    
    //MARK: - Add Button Pressed
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        var dateField = UITextField()
        
        let alert = UIAlertController(title: "Add New Event", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newEvent = Event()
            newEvent.name = textField.text!
            newEvent.time = dateField.text!
            self.save(event: newEvent)
        }
        
        alert.addAction(action)
        
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add a new event name"
        }
        alert.addTextField { (field) in
            dateField = field
            dateField.placeholder = "Add a date"
        }
        present(alert, animated: true, completion: nil)
        
    }
    
}
