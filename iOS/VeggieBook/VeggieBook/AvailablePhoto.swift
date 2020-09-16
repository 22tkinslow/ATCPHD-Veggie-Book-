//
//  AvailablePhotos.swift
//  VeggieBook
//
//  Created by Daniel DiPasquo on 6/15/17.
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

class AvailablePhoto {
    var id : Int
    var url : String
    var mine : Bool
    
    init(fromJson: [String:Any]){
        self.id = fromJson["id"] as! Int
        self.url = fromJson["url"] as! String
        self.mine = fromJson["mine"] as! Bool
    }
    
    init(fromSelectable: Selectable){
        self.id = fromSelectable.coverPhotoId ?? fromSelectable.coverPhotoIdEn!
        self.url = fromSelectable.photoUrl
        self.mine = false
    }

    
    class func initFromJsonList(fromJson: [[String:Any]]) -> [AvailablePhoto]{
        var availablePhotos : [AvailablePhoto] = []
        for photoJson in fromJson{
            let availablePhoto = AvailablePhoto(fromJson: photoJson)
            availablePhotos.append(availablePhoto)
        }
        return availablePhotos
    }
    
    class func initFromSecretsSelectablesList(fromSelectables: [Selectable]) -> [AvailablePhoto]{
        var availablePhotos : [AvailablePhoto] = []
        for selectable in fromSelectables{
            let availablePhoto = AvailablePhoto(fromSelectable: selectable)
            availablePhotos.append(availablePhoto)
        }
        return availablePhotos
    }
}
