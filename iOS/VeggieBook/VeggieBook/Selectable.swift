//
//  Selectable.swift
//  VeggieBook
//
//  Created by Daniel DiPasquo on 6/14/17.
//  Copyright © 2017 DiPasquo Consulting. All rights reserved.
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
