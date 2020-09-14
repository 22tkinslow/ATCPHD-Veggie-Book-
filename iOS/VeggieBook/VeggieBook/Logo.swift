//
//  Logo.swift
//  VeggieBook
//
//  Created by Daniel DiPasquo on 2/10/17.
//  Copyright © 2017 DiPasquo Consulting. All rights reserved.
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
