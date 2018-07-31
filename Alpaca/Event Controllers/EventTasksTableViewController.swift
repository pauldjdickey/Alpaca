//
//  EventItemsTableViewController.swift
//  Alpaca
//
//  Created by Paul Dickey2 on 7/28/18.
//  Copyright © 2018 Paul Dickey. All rights reserved.
//

import UIKit
import RealmSwift

class EventTasksTableViewController: SwipeRemoveTableViewController {
    
    var eventTasks: Results<Task>?
    var userSelected: Results<UserSelectedEvent>?
    let realm = try! Realm()

    var selectedEvent : Event? {
        didSet{
            loadTasks()            
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTasks()
    }
    override func viewDidAppear(_ animated: Bool) {
        loadTasks()
    }
    override func viewWillAppear(_ animated: Bool) {
        title = selectedEvent?.name
        loadTasks()
    }
    
    //MARK: - Tableview Datasource Methods (What to load into cells)
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventTasks?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let task = eventTasks?[indexPath.row] {
            cell.textLabel?.text = task.title
            cell.accessoryType = task.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No tasks added"
        }
        return cell
    }
    
    //MARK: - TableView Delegate Methods (What happens when a cell is selected)
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let task = eventTasks?[indexPath.row] {
            do {
                try realm.write {
                    task.done = !task.done
                }
            } catch {
                print("Error saving the done status \(error)")
            }
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    //MARK: - Data Manipulaton (Load)
    func loadTasks() {
        eventTasks = realm.objects(Task.self).filter("id = '\(selectedEvent!.eventID)'")
        tableView.reloadData()
    }
    
    //MARK: - Delete Data From Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        
        if let taskForDeletion = self.eventTasks?[indexPath.row] {
            do {
                try self.realm.write {
                    taskForDeletion.addedToEvent = false
                    taskForDeletion.id = ""
                }
            } catch {
                print("Error removing task from event, \(error)")
            }
        }
    }
    
}
