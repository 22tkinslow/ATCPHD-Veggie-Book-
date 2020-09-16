//
//  Selectable.swift
//  VeggieBook
//
//  Created by Daniel DiPasquo on 6/14/17.
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
import RealmSwift

class Selectable : Object{
    var id : Int?
    var titleEn : String?
    var titleEs : String?
    var urlEn : String?
    var urlEs : String?
    var photoUrlEn : String?
    var photoUrlEs : String?
    var shareUrlEn : String?
    var shareUrlEs : String?
    var coverPhotoIdEn : Int?
    var coverPhotoIdEs : Int?
    dynamic var selected: Bool = false
    var extras: Int = 0
    var scrolled: Bool = false
    
    var coverPhotoId : Int?
    {
        get {
            return LanguageCode.appLanguage.isSpanish() && coverPhotoIdEs != nil ? coverPhotoIdEs : coverPhotoIdEn
        }
    }
    
    var photoUrl : String
    {
        get {
            return LanguageCode.appLanguage.isSpanish() && photoUrlEs != nil ? photoUrlEs! : photoUrlEn!
        }
    }
    
    var title : String
    {
        get {
            return (LanguageCode.appLanguage.isSpanish() ? titleEs : titleEn)!
        }
    }
    
    var url : String
    {
        get {
            return (LanguageCode.appLanguage.isSpanish() ? urlEs : urlEn)!
        }
    }
    
    var shareUrl : String
    {
        get {
            return (LanguageCode.appLanguage.isSpanish() ? shareUrlEs : shareUrlEn)!
        }
    }
    
    class func initFromJson(fromJson: [String:Any]) -> Selectable{
        let selectable = self.init()
        selectable.id = fromJson["id"] as? Int
        selectable.titleEn = fromJson["title_en"] as? String
        selectable.titleEs = fromJson["title_es"] as? String
        selectable.urlEn = fromJson["url_en"] as? String
        selectable.urlEs = fromJson["url_es"] as? String
        selectable.photoUrlEn = fromJson["photoUrl"] as? String
        selectable.photoUrlEs = fromJson["photoUrl_es"] as? String
        selectable.shareUrlEn = fromJson["shareUrl_en"] as? String
        selectable.shareUrlEs = fromJson["shareUrl_es"] as? String
        
        let cpi = fromJson["coverPhotoId"] ?? nil
        selectable.coverPhotoIdEn = cpi as! Int?
        let cpies = fromJson["coverPhotoId_es"] ?? nil
        selectable.coverPhotoIdEs = cpies as? Int
        return selectable
     }
    
    class func initSelectables(fromJson: [[String:Any]]) -> [Selectable]{
        var selectables : [Selectable] = []
        for json in fromJson{
            let selectable = self.initFromJson(fromJson: json)
            selectables.append(selectable)
        }
        return selectables
    }
    
    
}
