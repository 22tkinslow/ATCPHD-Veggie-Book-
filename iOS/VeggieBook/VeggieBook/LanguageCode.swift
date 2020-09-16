//
//  LanguageCode.swift
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

class LanguageCode {
    var languageCode: String

    class var appLanguage: LanguageCode {
        struct Static {
            static let instance = LanguageCode()
        }
        return Static.instance
    }

    init() {
        let systemLanguageCode = Locale.current.languageCode ?? "en"
        self.languageCode = systemLanguageCode.hasPrefix("es") ? "es" : "en"
    }

    func changeAppLanguage() {
        self.languageCode = self.languageCode == "es" ? "en" : "es"
    }

    func isSpanish() -> Bool {
        return self.languageCode == "es"
    }
}
