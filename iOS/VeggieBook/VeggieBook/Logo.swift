//
//  Logo.swift
//  VeggieBook
//
//  Created by Daniel DiPasquo on 2/10/17.
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

class Logo {
    class func getNegativeLogo() -> UIImage{
        return LanguageCode.appLanguage.isSpanish() ? #imageLiteral(resourceName: "logo-negative-es") : #imageLiteral(resourceName: "logo-negative-en")
    }
    class func getPositiveLogo() -> UIImage{
        return LanguageCode.appLanguage.isSpanish() ? #imageLiteral(resourceName: "logo-positive-es") : #imageLiteral(resourceName: "logo-negative-en")
    }
    
    class func getSecretsLogo() -> UIImage{
        return LanguageCode.appLanguage.isSpanish() ? #imageLiteral(resourceName: "secrets_logo_reversed_small_es") : #imageLiteral(resourceName: "secrets_logo_reversed_small_en")
    }
}
