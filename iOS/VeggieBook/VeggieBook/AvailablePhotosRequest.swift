//
//  AvailablePhotosRequest.swift
//  VeggieBook
//
//  Created by Daniel DiPasquo on 6/15/17.
//  Copyright © 2017 DiPasquo Consulting. All rights reserved.
//

import Foundation

class AvailablePhotosRequest {
    var data : Data

    init(bookId : String){
        let requestObject : [String:Any] = [
            "profileId": UserDefaults.standard.integer(forKey: "profileId"),
            "bookId": bookId
        ]
        data = try! JSONSerialization.data(withJSONObject:requestObject)
    }
}
