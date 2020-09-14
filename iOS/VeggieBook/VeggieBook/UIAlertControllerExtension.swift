//
//  UIAlertControllerExtension.swift
//  VeggieBook
//
//  Created by Matthew Flickner on 10/19/17.
//  Copyright © 2017 Technical Empowerment Inc. All rights reserved.
//

import UIKit

extension UIAlertController {
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    open override var shouldAutorotate: Bool {
        return false
    }
}
