//
//  EventProjectItemsTableViewController.swift
//  Alpaca
//
//  Created by Paul Dickey2 on 7/29/18.
//  Copyright © 2018 Paul Dickey. All rights reserved.
//

import UIKit
import RealmSwift

class EventProjectTasksTableViewController: SwipeTableViewController {
    
    var projectTasks: Results<Task>?
    let realm = try! Realm()
    
    
    
    var selectedProject : Project? {
        didSet{
            loadTasks()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
        loadTasks()
    }
    override func viewWillAppear(_ animated: Bool) {
        title = selectedProject?.name
    }
    
    //MARK: - Tableview Datasource Methods (What to load into cells)
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projectTasks?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let task = projectTasks?[indexPath.row] {
            cell.textLabel?.text = task.title
            cell.accessoryType = task.addedToEvent ? .checkmark : .none
            if task.addedToEvent == true {
                cell.backgroundColor = UIColor.green
            } else {
                cell.backgroundColor = UIColor.clear
            }
        }
        return cell
    }
    //MARK: - TableView Delegate Methods (What happens when a cell is selected)
        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let userSelection = realm.objects(UserSelectedEvent.self).first
            if let task = projectTasks?[indexPath.row] {
                do {
                    try realm.write {
                        if task.id == "" {
                            task.id = "\(userSelection!.name)"
                            task.addedToEvent = true
                        } else {
                            task.id = ""
                            task.addedToEvent = false
                        }
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
        projectTasks = selectedProject?.tasks.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
    //MARK: - Delete Data From Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        
        if let taskForDeletion = self.projectTasks?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(taskForDeletion)
                }
            } catch {
                print("Error deleting project, \(error)")
            }
        }
    }
    //MARK: - Done Button Pressed
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
