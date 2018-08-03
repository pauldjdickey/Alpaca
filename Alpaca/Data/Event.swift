//
//  Event.swift
//  Alpaca
//
//  Created by Paul Dickey2 on 7/28/18.
//  Copyright © 2018 Paul Dickey. All rights reserved.
//

import Foundation
import RealmSwift

class Event: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var time: String = ""
    @objc dynamic var eventID = UUID().uuidString
    let eventTasks = RealmSwift.List<Task>()


    
    override class func primaryKey() -> String? {
        return "eventID"
    }
}
