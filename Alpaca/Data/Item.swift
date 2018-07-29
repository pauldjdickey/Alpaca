//
//  Item.swift
//  Alpaca
//
//  Created by Paul Dickey2 on 7/27/18.
//  Copyright © 2018 Paul Dickey. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var added: Bool = false
    @objc dynamic var dateCreated: Date?
    @objc dynamic var id: String = ""
    var parentCategory = LinkingObjects(fromType: List.self, property: "items")
    var eventParentCategory = LinkingObjects(fromType: Event.self, property: "eventItems")

}
