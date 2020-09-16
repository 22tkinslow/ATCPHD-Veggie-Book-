//
//  VBUser.swift
//  VeggieBook
//
//  Created by Daniel DiPasquo on 2/12/17.
//  Copyright © 2017 DiPasquo Consulting. All rights reserved.
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

class VBUser {
    var profileId : Int
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("VBSettings")
    static let UserProfileProperty = "profileId"
    
    init(profileId: Int){
        self.profileId = profileId
    }
    
    init(fromJson:[String:Any]){
        profileId = fromJson["profileId"] as! Int
    }
    
    class func getCurrent() -> VBUser? {
        
        return nil
    }
}
