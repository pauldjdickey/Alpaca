//
//  ListItemsTableViewController.swift
//  Alpaca
//
//  Created by Paul Dickey2 on 7/27/18.
//  Copyright © 2018 Paul Dickey. All rights reserved.
//

import UIKit
import RealmSwift

class ProjectTasksTableViewController: SwipeTableViewController {
    
    var projectTasks: Results<Task>?
    let realm = try! Realm()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
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
            cell.accessoryType = task.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No tasks added"
        }
        return cell
    }
    
    
    //MARK: - TableView Delegate Methods (What happens when a cell is selected)
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let task = projectTasks?[indexPath.row] {
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
    
    //MARK: - Add items w/ Plus Button
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new task", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add task", style: .default) { (action) in
            if let currentProject = self.selectedProject {
                do {
                    try self.realm.write {
                        let newTask = Task()
                        newTask.title = textField.text!
                        newTask.dateCreated = Date()
                        newTask.id = ""
                        currentProject.tasks.append(newTask)
                    }
                } catch {
                    print("Could not save new task \(error)")
                }
            }
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new task"
            textField = alertTextField
        }

        alert.addAction(action)
        present(alert, animated: true, completion: nil)
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
    
}

extension ProjectTasksTableViewController: UISearchBarDelegate {
    //MARK: - Search bar methods
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        projectTasks = projectTasks?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        loadTasks()
        DispatchQueue.main.async {
            searchBar.resignFirstResponder()
        }
    }
}

