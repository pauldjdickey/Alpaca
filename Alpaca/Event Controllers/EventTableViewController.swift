//
//  EventTableViewController.swift
//  Alpaca
//
//  Created by Paul Dickey2 on 7/23/18.
//  Copyright © 2018 Paul Dickey. All rights reserved.
//

import UIKit
import RealmSwift

class EventTableViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    var items: Results<Item>?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadLists()
    }

    //MARK: - TableView Datasource Methods (Code that tells each cell what to load)
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = items?[indexPath.row] {
            cell.textLabel?.text = item.title
        }
        return cell
    }
    
    //MARK: - TableView Delegate Methods (Code that says what happens when we select a cell)
    
    //MARK: - Data Manipulation Methods
    
    func loadLists () {
        items = realm.objects(Item.self)
        tableView.reloadData()
    }
    
}
