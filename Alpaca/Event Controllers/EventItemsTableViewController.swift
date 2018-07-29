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
    
    var selectedEvent : Event? {
        didSet{
            // loadItems()
        }
    }
}
