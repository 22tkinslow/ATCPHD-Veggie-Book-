//
//  RegisterRequest.swift
//  VeggieBook
//
//  Created by Daniel DiPasquo on 6/19/17.
//  Copyright © 2017 DiPasquo Consulting. All rights reserved.
//

import Foundation

class RegisterRequest{
    var data : Data
    var json: [String: Any]
    
    init(token:String, firstName:String, lastName:String){
        let requestObject : [String:Any] = [
            "at": token,
            "firstName": firstName,
            "lastName": lastName
        ]
        json = requestObject
        data = try! JSONSerialization.data(withJSONObject:requestObject)

    }
}
