//
//  LoginByDeviceIdRequest.swift
//  VeggieBook
//
//  Created by Brittany Mazza on 2/6/18.
//  Copyright © 2018 Technical Empowerment Inc. All rights reserved.
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
