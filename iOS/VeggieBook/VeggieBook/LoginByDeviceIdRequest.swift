//
//  LoginByDeviceIdRequest.swift
//  VeggieBook
//
//  Created by Brittany Mazza on 2/6/18.
//  Copyright © 2020 Quick Help For Meals, LLC. All rights reserved.
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

class LoginByDeviceIdRequest {
    var data : Data

    init(deviceId : String) {
        let requestObject : [String: String] = [
            "deviceId": deviceId
        ]
        data = try! JSONSerialization.data(withJSONObject:requestObject)
    }
}
