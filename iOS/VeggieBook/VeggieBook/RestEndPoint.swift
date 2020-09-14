//
//  RestClient.swift
//  VeggieBook
//
//  Created by Daniel DiPasquo on 1/15/17.
//  Copyright © 2017 DiPasquo Consulting. All rights reserved.
//

import Foundation


let baseUrl = Bundle.main.infoDictionary!["BASE_URL"] as! String

enum RestEndPoint {
    case LibraryInfo
    case GetInterview
    case GetSelectables
    case AvailablePhotos
    case UploadImage
    case Register
    case LoginByDeviceId
    case CreateVeggieBook
    case PrintVeggieBook
    case Pantries
    case RecordEvent
    
    var path : String {
        switch self {
        case .LibraryInfo: return "/qhmobile/libraryInfo"
        case .GetInterview: return "/qhmobile/getInterview"
        case .GetSelectables: return "/qhmobile/getSelectables"
        case .AvailablePhotos: return "/qhmobile/availableCoverPhotos/"
        case .UploadImage: return "/qhmobile/uploadCoverPhoto/"
        case .Register: return "/qhmobile/register/"
        case .LoginByDeviceId: return "/qhmobile/loginByDeviceId/"
        case .CreateVeggieBook: return "/qhmobile/createVeggieBook/"
        case .PrintVeggieBook: return "/qhmobile/printVeggieBook/"
        case .Pantries: return "/qhmobile/pantries/"
        case .RecordEvent: return "/qhmobile/recordEvent/"
        }
    }
    
    var url : URL? {
        var myUrl = URL(string: baseUrl)
        myUrl?.appendPathComponent(self.path)
        return myUrl
    }
}

