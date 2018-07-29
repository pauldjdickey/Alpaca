//
//  EventItemsTableViewController.swift
//  Alpaca
//
//  Created by Paul Dickey2 on 7/28/18.
//  Copyright © 2018 Paul Dickey. All rights reserved.
//

import UIKit
import RealmSwift

class EventItemsTableViewController: SwipeTableViewController {
    
    var eventItems: Results<Item>?
    let realm = try! Realm()
    
    var selectedEvent : Event? {
        didSet{
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
    }
    override func viewDidAppear(_ animated: Bool) {
        loadItems()
    }
    override func viewWillAppear(_ animated: Bool) {
        title = selectedEvent?.name
        loadItems()
    }
    
    //MARK: - Tableview Datasource Methods (What to load into cells)
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventItems?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = eventItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No items added"
        }
        return cell
    }
    
    //MARK: - TableView Delegate Methods (What happens when a cell is selected)
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = eventItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
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
        eventItems = realm.objects(Item.self).filter("id = 'hello'")
        tableView.reloadData()
    }
    
}
