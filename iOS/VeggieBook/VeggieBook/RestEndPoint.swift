//
//  RestClient.swift
//  VeggieBook
//
//  Created by Daniel DiPasquo on 1/15/17.
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

