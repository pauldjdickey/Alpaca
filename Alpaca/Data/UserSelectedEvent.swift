//
//  UserSelectedEvent.swift
//  Alpaca
//
//  Created by Paul Dickey2 on 7/29/18.
//  Copyright © 2018 Paul Dickey. All rights reserved.
//

import Foundation
import RealmSwift

class UserSelectedEvent: Object {
    @objc dynamic var name: String = ""
}
