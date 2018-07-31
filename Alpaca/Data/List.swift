//
//  Lists.swift
//  Alpaca
//
//  Created by Paul Dickey2 on 7/27/18.
//  Copyright © 2018 Paul Dickey. All rights reserved.
//

import Foundation
import RealmSwift

class List: Object {
    @objc dynamic var name: String = ""
    let tasks = RealmSwift.List<Task>()
}
