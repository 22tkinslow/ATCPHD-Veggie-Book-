//
//  UIColorExtension.swift
//  VeggieBook
//
//  Created by Matthew Flickner on 10/16/17.
//  Copyright © 2017 DiPasquo Consulting. All rights reserved.
//

import UIKit

extension UIColor {
    static let veggieBookGreenHex = 0x0FB022
    static let oldVeggieBookGreen = UIColor(rgb: 0x80C664)
    static let veggieBookGreen = UIColor(rgb: 0x0FB022)
    
    convenience init(red: Int, green: Int, blue: Int, a: CGFloat = 1.0) {
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: a
        )
    }
    
    convenience init(rgb: Int, a: CGFloat = 1.0) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF,
            a: a
        )
    }
}
