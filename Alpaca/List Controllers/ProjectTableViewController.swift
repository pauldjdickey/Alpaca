//
//  Project
// TableViewController.swift
//  Alpaca
//
//  Created by Paul Dickey2 on 7/23/18.
//  Copyright © 2018 Paul Dickey. All rights reserved.
//

import UIKit
import RealmSwift

class ProjectTableViewController: SwipeTableViewController {
    
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
        performSegue(withIdentifier: "goToTasks", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ProjectTasksTableViewController
        
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
            print("Error saving project \(error)")
        }
        tableView.reloadData()
    }
    
    func loadProjects () {
        projects = realm.objects(Project.self)
        tableView.reloadData()
    }
    
    //MARK: - Delete Data From Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        if let projectForDeletion = self.projects?[indexPath.row], let projectDelete = self.projects?[indexPath.row].tasks {
            do {
                try self.realm.write {
                    self.realm.delete(projectDelete)
                    self.realm.delete(projectForDeletion)
                }
            } catch {
                print("Error deleting project, \(error)")
            }
        }
    }
    
    //MARK: - Add Button Pressed
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Project", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newProject = Project()
            newProject.name = textField.text!
            self.save(project: newProject)
            
        }
        
        alert.addAction(action)
        
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add a new project"
        }
        
        present(alert, animated: true, completion: nil)
        
    }
}
