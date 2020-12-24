//
//  AvailablePhotosRequest.swift
//  VeggieBook
//
//  Created by Daniel DiPasquo on 6/15/17.
//  Copyright © 2017 DiPasquo Consulting. All rights reserved.
//  Copyright © 2020 Quick Help For Meals, LLC. All rights reserved.
//  Software developed at the University of Southern California.
//
//  This file is part of VeggieBook.
//
//  VeggieBook is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, version 3 of the license only.
//
//  VeggieBook is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or fitness for a particular purpose. See the
//  GNU General Public License for more details.
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
