//
//  Pantry.swift
//  VeggieBook
//
//  Created by Daniel DiPasquo on 6/19/17.
//  Copyright © 2017 DiPasquo Consulting. All rights reserved.
//

import Foundation

class Pantry {
    var name : String
    var id : Int
    
    init(fromJson:[String:Any]){
        name = fromJson["name"] as! String
        id = fromJson["id"] as! Int
    }
}
