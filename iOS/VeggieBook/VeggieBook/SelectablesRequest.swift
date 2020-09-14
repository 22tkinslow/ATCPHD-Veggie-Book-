//
//  Selectables Request.swift
//  VeggieBook
//
//  Created by Daniel DiPasquo on 2/26/17.
//  Copyright © 2017 DiPasquo Consulting. All rights reserved.
//

import Foundation

class SelectablesRequest {
    var data : Data
    
    init(bookType : String, bookId : String, attributes : [String]){
        let requestObject : [String : Any] = [
            "bookType": bookType,
            "bookId": bookId,
            "attributes": attributes
        ]
        data = try! JSONSerialization.data(withJSONObject:requestObject)
    }
}
