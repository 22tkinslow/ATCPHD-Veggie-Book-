//
//  UIFontExtension.swift
//  VeggieBook
//
//  Created by Matthew Flickner on 10/23/17.
//  Copyright © 2017 DiPasquo Consulting. All rights reserved.
//

import UIKit

extension UIFont {
    
    func withTraits(traits:UIFontDescriptorSymbolicTraits...) -> UIFont {
        let descriptor = self.fontDescriptor
            .withSymbolicTraits(UIFontDescriptorSymbolicTraits(traits))
        return UIFont(descriptor: descriptor!, size: 0)
    }
    
    func boldItalic() -> UIFont {
        return withTraits(traits: .traitBold, .traitItalic)
    }
    
    func italic() -> UIFont {
        return withTraits(traits: .traitItalic)
    }
}
