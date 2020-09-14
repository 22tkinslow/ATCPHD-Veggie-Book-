//
//  InterviewRequest.swift
//  VeggieBook
//
//  Created by Daniel DiPasquo on 2/7/17.
//  Copyright © 2017 DiPasquo Consulting. All rights reserved.
//

import Foundation


class InterviewRequest {
    var data : Data
    
    init(bookType: String, bookId: String) {
        let requestObject : [String: Any] = [
            "bookType": bookType,
            "bookId": bookId,
            "language": (LanguageCode.appLanguage.isSpanish()) ? "es" : "en",
            "lat": 0,
            "lon": 0,
            "profileId": UserDefaults.standard.integer(forKey: "profileId")
        ]
        
        data = try! JSONSerialization.data(withJSONObject:requestObject)
    }
    
}
