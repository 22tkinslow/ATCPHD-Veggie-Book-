//
//  CreateBookRequest.swift
//  VeggieBook
//
//  Created by Daniel DiPasquo on 6/16/17.
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

class SelectableRequest {
    var requestObject : [String:Any]
    
    init(selectable: Selectable){
        requestObject = [
            "recipeId": selectable.id!,
            "selected": selectable.selected,
            "extras": selectable.extras,
            "scrolled": selectable.scrolled
        ]
    }
}

class CreateBookRequest {
    var data : Data
    init(bookBuilder: BookBuilder){
        var selectables : [[String:Any]] = []
        for selectable in bookBuilder.selectables{
            let sr = SelectableRequest(selectable: selectable)
            selectables.append(sr.requestObject)
        }
        
        let requestObject: [String:Any] = [
            "selectables": selectables,
            "language": (LanguageCode.appLanguage.isSpanish()) ? "es" : "en",
            "bookType": bookBuilder.availableBook.bookType,
            "bookId": bookBuilder.availableBook.id,
            "attributes": Array(bookBuilder.attributeSet),
            "coverPhoto": bookBuilder.coverPhoto,
            "profileId": UserDefaults.standard.integer(forKey: "profileId"),
            "latitude": 0,
            "longitude": 0
        ]
        data = try! JSONSerialization.data(withJSONObject:requestObject)
    }
}
