//
//  Load all Items.swift
//  Alpaca
//
//  Created by Paul Dickey2 on 7/29/18.
//  Copyright © 2018 Paul Dickey. All rights reserved.
//

//import UIKit
//import RealmSwift
//
//class EventListTableViewController: SwipeTableViewController {
//    //  All of this code brings up every item from every list
//
//    let realm = try! Realm()
//    var items: Results<Item>?
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        loadLists()
//    }
//
//    override func viewDidAppear(_ animated: Bool) {
//        loadLists()
//    }
//
//    //MARK: - TableView Datasource Methods (Code that tells each cell what to load)
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return items?.count ?? 1
//    }
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = super.tableView(tableView, cellForRowAt: indexPath)
//
//        if let item = items?[indexPath.row] {
//            cell.textLabel?.text = item.title
//            cell.accessoryType = item.addedToEvent ? .checkmark : .none
//            if item.added == true {
//                cell.backgroundColor = UIColor.green
//            } else {
//                cell.backgroundColor = UIColor.clear
//            }
//        }
//        return cell
//    }
//
//    //MARK: - TableView Delegate Methods (What happens when a cell is selected)
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if let item = items?[indexPath.row] {
//            do {
//                try realm.write {
//                    if item.id == "" {
//                        item.id = "hello"
//                        item.added = true
//                    } else {
//                        item.id = ""
//                        item.added = false
//                    }
//                }
//            } catch {
//                print("Error saving the done status \(error)")
//            }
//        }
//        tableView.reloadData()
//        tableView.deselectRow(at: indexPath, animated: true)
//    }
//
//    //MARK: - Data Manipulation Methods
//
//    func loadLists () {
//        items = realm.objects(Item.self)
//        tableView.reloadData()
//    }
//
//    //MARK: - Delete Data From Swipe
//
//    override func updateModel(at indexPath: IndexPath) {
//
//        if let itemForDeletion = self.items?[indexPath.row] {
//            do {
//                try self.realm.write {
//                    self.realm.delete(itemForDeletion)
//                }
//            } catch {
//                print("Error deleting item, \(error)")
//            }
//        }
//    }
//
//}
