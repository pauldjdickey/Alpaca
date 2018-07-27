//
//  ListItemsTableViewController.swift
//  Alpaca
//
//  Created by Paul Dickey2 on 7/27/18.
//  Copyright © 2018 Paul Dickey. All rights reserved.
//

import UIKit
import RealmSwift

class ListItemsTableViewController: SwipeTableViewController, UISearchBarDelegate {
    
    var listItems: Results<Item>?
    let realm = try! Realm()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    var selectedList : List? {
        didSet{
           // loadItems()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        title = selectedList?.name
    }
    
}
