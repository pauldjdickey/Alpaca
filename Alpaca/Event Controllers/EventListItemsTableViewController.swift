//
//  EventListItemsTableViewController.swift
//  Alpaca
//
//  Created by Paul Dickey2 on 7/29/18.
//  Copyright © 2018 Paul Dickey. All rights reserved.
//

import UIKit
import RealmSwift

class EventListItemsTableViewController: SwipeTableViewController {
    
    var listItems: Results<Item>?
    let realm = try! Realm()
    
    
    
    var selectedList : List? {
        didSet{
            loadItems()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
        loadItems()
    }
    override func viewWillAppear(_ animated: Bool) {
        title = selectedList?.name
    }
    
    //MARK: - Tableview Datasource Methods (What to load into cells)
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listItems?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = listItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.added ? .checkmark : .none
            if item.added == true {
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
            if let item = listItems?[indexPath.row] {
                do {
                    try realm.write {
                        if item.id == "" {
                            item.id = "\(userSelection!.name)"
                            item.added = true
                        } else {
                            item.id = ""
                            item.added = false
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
    func loadItems() {
        listItems = selectedList?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
    //MARK: - Delete Data From Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        
        if let itemForDeletion = self.listItems?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(itemForDeletion)
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
