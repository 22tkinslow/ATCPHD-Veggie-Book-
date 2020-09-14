//
//  AvailablePhotos.swift
//  VeggieBook
//
//  Created by Daniel DiPasquo on 6/15/17.
//  Copyright © 2017 DiPasquo Consulting. All rights reserved.
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
