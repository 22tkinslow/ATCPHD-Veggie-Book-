//
//  KeepDropViewController.swift
//  VeggieBook
//
//  Created by Matt Flickner on 6/26/17.
//  Copyright © 2017 Technical Empowerment Inc. All rights reserved.
//

import UIKit

class SelectableViewController: UIViewController {
    
    @IBOutlet weak var keepButton: UIButton!
    @IBOutlet weak var dropButton: UIButton!
    @IBOutlet weak var keepDropWebPage: UIWebView!
    @IBOutlet weak var pageLabel: UILabel!
    
    var webPage : String? = nil
    var pageLabelString = ""
    
    var pageViewController : SelectablePageViewController? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        keepDropWebPage.delegate = self
        pageLabel.text = pageLabelString
        webPage = webPage!.contains("?") ? webPage! + "&selection" : webPage! + "?selection"
        let url = URL(string: webPage!)
        keepDropWebPage.loadRequest(URLRequest(url: url!))
        
        keepButton.setTitle(LanguageCode.appLanguage.isSpanish() ? "LA QUIERO" : "KEEP", for: .normal)
        dropButton.setTitle(LanguageCode.appLanguage.isSpanish() ? "NO LA QUIERO" : "DROP", for: .normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func keepButtonPressed(_ sender: Any) {
        removeBlur(){ Void in
            self.pageViewController?.bookBuilder?.selectables[(self.pageViewController?.controllerCount)!].selected = true
            self.pageViewController?.goToNextPage()
        }
    }
    
    @IBAction func dropButtonPressed(_ sender: Any) {
        addBlur()
        pageViewController?.bookBuilder?.selectables[(pageViewController?.controllerCount)!].selected = false
        pageViewController?.goToNextPage()
    }
    
    private func addBlur(){
        // Only add if no blur
        if keepDropWebPage.viewWithTag(69) == nil {
            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.extraLight)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = keepDropWebPage.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            blurEffectView.alpha = 0.6
            blurEffectView.tag = 69
            keepDropWebPage.addSubview(blurEffectView)
            return
        }
    }
    
    private func removeBlur(done: @escaping () -> ()){
        // Remove if there is a blur
        if let blurView = keepDropWebPage.viewWithTag(69){
            UIView.animate(withDuration: 0.2,
                           animations: {blurView.alpha = 0.0},
                           completion: {
                            (value: Bool) in
                                blurView.removeFromSuperview()
                                done()
                           })
            return
        }
        done()
    }
}

extension SelectableViewController: UIWebViewDelegate {
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        switch navigationType {
        case .linkClicked:
            // Open links in Safari
            guard let url = request.url else { return true }
            
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                // openURL(_:) is deprecated in iOS 10+.
                UIApplication.shared.openURL(url)
            }
            return false
        default:
            // Handle other navigation types...
            return true
        }
    }
}
