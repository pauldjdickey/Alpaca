//
//  ListTableViewController.swift
//  Alpaca
//
//  Created by Paul Dickey2 on 7/23/18.
//  Copyright © 2018 Paul Dickey. All rights reserved.
//

import UIKit
import RealmSwift

class ListTableViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    var lists: Results<List>?

    override func viewDidLoad() {
        super.viewDidLoad()
        loadLists()
        print(Realm.Configuration.defaultConfiguration.fileURL!)
    }
    override func viewDidAppear(_ animated: Bool) {
        loadLists()
    }
    
    //MARK: - TableView Datasource Methods (Code that tells each cell what to load)
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let list = lists?[indexPath.row] {
            cell.textLabel?.text = list.name
        }
        return cell
    }

    //MARK: - TableView Delegate Methods (Code that says what happens when we select a cell)
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ListItemsTableViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedList = lists?[indexPath.row]
        }
    }

    //MARK: - Data Manipulation Methods (Save and Load)

    func save(list: List) {
        do {
            try realm.write {
                realm.add(list)
            }
        } catch {
            print("Error saving list \(error)")
        }
        tableView.reloadData()
    }
    
    func loadLists () {
        lists = realm.objects(List.self)
        tableView.reloadData()
    }
    
    //MARK: - Delete Data From Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        
        if let listForDeletion = self.lists?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(listForDeletion)
                }
            } catch {
                print("Error deleting list, \(error)")
            }
        }
    }
    
    //MARK: - Add Button Pressed
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New List", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newList = List()
            newList.name = textField.text!
            self.save(list: newList)
            
        }
        
        alert.addAction(action)
        
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add a new list"
        }
        
        present(alert, animated: true, completion: nil)
        
    }
}
