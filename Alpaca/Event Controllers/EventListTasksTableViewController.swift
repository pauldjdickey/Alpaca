//
//  EventListItemsTableViewController.swift
//  Alpaca
//
//  Created by Paul Dickey2 on 7/29/18.
//  Copyright © 2018 Paul Dickey. All rights reserved.
//

import UIKit
import RealmSwift

class EventListTasksTableViewController: SwipeTableViewController {
    
    var listTasks: Results<Task>?
    let realm = try! Realm()
    
    
    
    var selectedList : List? {
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
        title = selectedList?.name
    }
    
    //MARK: - Tableview Datasource Methods (What to load into cells)
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listTasks?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let task = listTasks?[indexPath.row] {
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
            if let task = listTasks?[indexPath.row] {
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
        listTasks = selectedList?.tasks.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
    //MARK: - Delete Data From Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        
        if let taskForDeletion = self.listTasks?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(taskForDeletion)
                }
            } catch {
                print("Error deleting list, \(error)")
            }
        }
    }
    //MARK: - Done Button Pressed
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
