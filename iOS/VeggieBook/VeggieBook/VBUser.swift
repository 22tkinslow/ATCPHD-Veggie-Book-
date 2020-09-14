//
//  VBUser.swift
//  VeggieBook
//
//  Created by Daniel DiPasquo on 2/12/17.
//  Copyright © 2017 DiPasquo Consulting. All rights reserved.
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
