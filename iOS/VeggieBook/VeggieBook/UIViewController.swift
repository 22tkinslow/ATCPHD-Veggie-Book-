//
//  UIViewController.swift
//  VeggieBook
//
//  Created by Brittany Mazza on 2/7/18.
//  Copyright © 2018 Technical Empowerment Inc. All rights reserved.
//

import UIKit

extension UIViewController {
    /**
      Display a generic alert message to the user with a simple "OK" button and no action.
        - parameter message: The message that will be displayed to the user.
        - parameter title: The title fpr the alert message box. Defaults to no title.
        - parameter completion: An action to perform when the "OK" button is selected.
     */
    func alert(message: String, title: String = "", completion: (() -> Void)? = nil) {
        let okActionText = "OK"
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: okActionText, style: .default, handler: nil)

        alert.addAction(okAction)
        self.present(alert, animated: true, completion: completion)
    }
}
