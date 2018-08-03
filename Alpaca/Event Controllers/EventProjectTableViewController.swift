//
//  AllItemsTableViewController.swift
//  Alpaca
//
//  Created by Paul Dickey2 on 7/29/18.
//  Copyright © 2018 Paul Dickey. All rights reserved.
//

import UIKit
import RealmSwift

class EventProjectTableViewController: SwipeTableViewController {

    let realm = try! Realm()
    var projects: Results<Project>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadProjects()
        print(Realm.Configuration.defaultConfiguration.fileURL!)
    }
    override func viewDidAppear(_ animated: Bool) {
        loadProjects()
    }
    
    //MARK: - TableView Datasource Methods (Code that tells each cell what to load)
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projects?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let project = projects?[indexPath.row] {
            cell.textLabel?.text = project.name
        }
        return cell
    }
    
    //MARK: - TableView Delegate Methods (Code that says what happens when we select a cell)
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToEventProjectTasks", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! EventProjectTasksTableViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedProject = projects?[indexPath.row]
        }
    }
    
    //MARK: - Data Manipulation Methods (Save and Load)
    
    func save(project: Project) {
        do {
            try realm.write {
                realm.add(project)
            }
        } catch {
            print("Error saving Project \(error)")
        }
        tableView.reloadData()
    }
    
    func loadProjects () {
        projects = realm.objects(Project.self)
        tableView.reloadData()
    }
    
    //MARK: - Delete Data From Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        
        if let projectForDeletion = self.projects?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(projectForDeletion)
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
