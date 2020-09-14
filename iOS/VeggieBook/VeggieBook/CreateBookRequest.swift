//
//  CreateBookRequest.swift
//  VeggieBook
//
//  Created by Daniel DiPasquo on 6/16/17.
//  Copyright © 2017 DiPasquo Consulting. All rights reserved.
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
