//
//  LanguageCode.swift
//  VeggieBook
//
//  Created by Daniel DiPasquo on 2/10/17.
//  Copyright © 2017 DiPasquo Consulting. All rights reserved.
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
