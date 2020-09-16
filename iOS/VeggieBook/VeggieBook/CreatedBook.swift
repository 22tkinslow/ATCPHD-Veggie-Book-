//
//  CreatedBook.swift
//  VeggieBook
//
//  Created by Daniel DiPasquo on 6/19/17.
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

class CreatedBook : Object{
    var id: Int = -1
    var availableBookId = ""
    var selectables = List<Selectable>()
    var tipsUrlEn = ""
    var tipsUrlEs = ""
    var coverUrlEn = ""
    var coverUrlEs = ""
    var chosenPhotoUrl = ""
    var availableBook: AvailableBook{
        get{
            let realm = try! Realm()
            let ab = realm.object(ofType: AvailableBook.self, forPrimaryKey: self.availableBookId)!
            return ab
        }
    }
    var tipsUrl : String {
        get {
            return (LanguageCode.appLanguage.isSpanish()) ? self.tipsUrlEs : self.tipsUrlEn
        }
    }
    
    var coverUrl: String {
        get {
            return (LanguageCode.appLanguage.isSpanish()) ? self.coverUrlEs : self.coverUrlEn
        }
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }

    //because you can't have custom init for Swift at present
    class func initFromJson(bookObject:[String:Any], availableBookId:String, selectables:[Selectable], url:String) -> CreatedBook {
        let createdBook =  self.init()
        createdBook.id = bookObject["id"] as! Int
        if let tipsUrl_en = bookObject["tipsUrl_en"] as? String {
            createdBook.tipsUrlEn = tipsUrl_en
        }
        
        if let tipsUrl_es = bookObject["tipsUrl_es"] as? String {
            createdBook.tipsUrlEs = tipsUrl_es
        }

        createdBook.coverUrlEn = bookObject["coverUrl_en"] as! String
        createdBook.coverUrlEs = bookObject["coverUrl_es"] as! String
        createdBook.availableBookId = availableBookId
        createdBook.selectables = List<Selectable>(selectables)
        createdBook.chosenPhotoUrl = url
        return createdBook
    }
}
