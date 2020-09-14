//
//  PopupViewController.swift
//  VeggieBook
//
//  Created by Matthew Flickner on 10/18/17.
//  Copyright © 2017 Technical Empowerment Inc. All rights reserved.
//

import UIKit

import UIKit

class PopupViewController: UIViewController {
    @IBOutlet weak var buttonViewController: UIView!
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    
    @IBOutlet weak var languageButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var buttonViewHeightContrainst: NSLayoutConstraint!
    
    var effect:UIVisualEffect!
    var settingsButton: UIBarButtonItem!
    var redrawInNewLanguage: (() -> ())!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    languageButton.setTitle(LanguageCode.appLanguage.isSpanish() ? "Cambiar a Inglés" : "Change To Spanish", for: .normal)
    cancelButton.setTitle(LanguageCode.appLanguage.isSpanish() ? "Cancelar" : "Cancel", for: .normal)
        
        buttonViewController.layer.cornerRadius = 5
        buttonViewController.layer.borderColor = UIColor.lightGray.cgColor
        buttonViewController.layer.borderWidth = 1
        buttonViewController.layer.masksToBounds = false
        buttonViewController.layer.shadowColor = UIColor.gray.cgColor
        buttonViewController.layer.shadowRadius = 3
        buttonViewController.layer.shadowOpacity = 0.5
        buttonViewController.layer.shadowOffset.width = -1
        buttonViewController.layer.shadowOffset.height = 1
        buttonViewController.layer.shadowPath = UIBezierPath(rect: buttonViewController.bounds).cgPath
        buttonViewController.layer.shouldRasterize = true
        buttonViewController.layer.rasterizationScale = UIScreen.main.scale
        
        effect = visualEffectView.effect
        visualEffectView.effect = nil
        visualEffectView.isUserInteractionEnabled = false
//        animateIn()
    }
    
    @IBAction func languageButtonClicked(_ sender: Any) {
        LanguageCode.appLanguage.changeAppLanguage()
        redrawInNewLanguage()
        closePopup(self)
    }
    
    @IBAction func logoutButtonClicked(_ sender: Any) {
        let title = LanguageCode.appLanguage.isSpanish() ? "Logout?" : "Logout?"
        let fullName = UserDefaults.standard.string(forKey: "fullName")
        let message = LanguageCode.appLanguage.isSpanish() ? "Has iniciado sesión como \(fullName ?? "")" : "Currently logged in as \(fullName ?? "")"
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let confirmLogout = UIAlertAction(title: "Logout", style: .destructive) { Void in
            GIDSignIn.sharedInstance().signOut()
            UserDefaults.standard.removeObject(forKey: "profileId")
            UserDefaults.standard.removeObject(forKey: "fullName")
            self.performSegue(withIdentifier: "logoutSegue", sender: self)
            self.settingsButton.isEnabled = true
        }
        let cancelTitle = LanguageCode.appLanguage.isSpanish() ? "Cancelar" : "Cancel"
        let cancelLogout = UIAlertAction(title: cancelTitle, style: .default) { Void in
            
        }
        alert.addAction(cancelLogout)
        alert.addAction(confirmLogout)
        self.present(alert, animated: true, completion: nil)
    }
    
    func animateIn() {
        self.view.addSubview(buttonViewController)
        buttonViewController.alpha = 0
        visualEffectView.isUserInteractionEnabled = true


        UIView.animate(withDuration: 0.4) {
            self.visualEffectView.effect = self.effect
            self.buttonViewController.alpha = 1
        }
    }

    func animateOut() {
        UIView.animate(withDuration: 0.3, animations: {
            self.buttonViewController.alpha = 0
            self.visualEffectView.effect = nil
            self.visualEffectView.isUserInteractionEnabled = false


        }) { (success:Bool) in
            self.buttonViewController.removeFromSuperview()

        }
    }

    
//    @IBAction func dismissPrintView(_ sender: Any) {
//        animateOut()
//    }
//
    
    @IBAction func closePopup(_ sender: Any) {
        settingsButton.isEnabled = true
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backgroundTapped(_ sender: Any) {
        settingsButton.isEnabled = true
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    
}
