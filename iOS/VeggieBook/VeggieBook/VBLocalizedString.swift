//
//  LocalizedString.swift
//  VeggieBook
//
//  Created by Daniel DiPasquo on 1/13/17.
//  Copyright © 2017 DiPasquo Consulting. All rights reserved.
//

import Foundation
import RealmSwift

class VBLocalizedString : Object {
    dynamic var id = 0
    dynamic var en = ""
    dynamic var es = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
