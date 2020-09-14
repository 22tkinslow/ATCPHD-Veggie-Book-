//
//  AvailableBook.swift
//  VeggieBook
//
//  Created by Daniel DiPasquo on 1/11/17.
//  Copyright © 2017 DiPasquo Consulting. All rights reserved.
//

import Foundation
import RealmSwift


class AvailableBook : Object {
    dynamic var id : String = ""
    dynamic var titleEn : String = ""
    dynamic var titleEs : String = ""
    //small image of the book
    dynamic var url : String = ""
    //large image of the book
    dynamic var largeUrl : String = ""
    dynamic var bookType : String = ""
    dynamic var hasSelectables : Bool = true
    dynamic var loadingUrlEn : String = ""
    dynamic var loadingUrlEs : String = ""
    
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func title() -> String {
        return LanguageCode.appLanguage.isSpanish() ? titleEs : titleEn
    }
    
    //because you can't have custom init for Swift at present
    class func initFromJson(bookObject:[String:Any]) -> AvailableBook {
        let availableBook = self.init()
        availableBook.id = bookObject["id"] as! String
        
        let titleObject = bookObject["title"] as! [String:Any]
        availableBook.titleEn = titleObject["en"] as! String
        availableBook.titleEs = titleObject["es"] as! String
    
        let imageObject = bookObject["image"] as! [String:Any]
        availableBook.url = imageObject["img100"] as! String
        availableBook.largeUrl = imageObject["img500"] as! String
        
        availableBook.bookType = bookObject["type"] as! String
        availableBook.hasSelectables = bookObject["hasSelectables"] as! Bool
        
        availableBook.loadingUrlEn = bookObject["loadingUrl_en"] as! String
        availableBook.loadingUrlEs = bookObject["loadingUrl_es"] as! String
        
        let realm = try! Realm()
        
        try! realm.write() {
            realm.add(availableBook, update: true)
        }
        return availableBook
    }
    
    class func parseLibraryObject(libraryObject:[String:Any]) -> [AvailableBook] {
        let availableBooksList = libraryObject["booksAvailable"] as! [[String:Any]]
        var books:[AvailableBook] = []
        
        for bookObject in availableBooksList{
            let availableBook = self.initFromJson(bookObject: bookObject)
            books.append(availableBook)
        }
        return books
    }
    
}


