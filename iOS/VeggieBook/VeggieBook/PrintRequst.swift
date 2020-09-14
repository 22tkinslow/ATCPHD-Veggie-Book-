//
//  PrintRequst.swift
//  VeggieBook
//
//  Created by Daniel DiPasquo on 6/19/17.
//  Copyright © 2017 DiPasquo Consulting. All rights reserved.
//

import Foundation

class PrintRequest {
    var data : Data
    
    init(createdBookId : Int, pantryId: Int, bookType : String){
        let requestObject : [String:Any] = [
            "language": (LanguageCode.appLanguage.isSpanish()) ? "es" : "en",
            "id": createdBookId,
            "pantry": pantryId,
            "type": bookType
        ]
        data = try! JSONSerialization.data(withJSONObject:requestObject)
    }
}
