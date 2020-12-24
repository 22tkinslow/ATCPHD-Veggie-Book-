//
//  WhoSaysViewController.swift
//  VeggieBook
//
//  Created by Matt Flickner on 6/26/17.
//  Copyright © 2020 Quick Help For Meals, LLC. All rights reserved.
//  Software developed at the University of Southern California.
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

import UIKit
import RealmSwift

class WhoSaysViewController: UIViewController {
    @IBOutlet weak var whoSaysWebPage: UIWebView!

    var availableBook : AvailableBook?
    var contentUrl = (LanguageCode.appLanguage.isSpanish()) ? "https://www.veggiebook.mobi/static/whosaysso_es.html?v=3" : "https://www.veggiebook.mobi/static/whosaysso_en.html?v=3"
    var createdBookId = 0
    var createdBook: CreatedBook?
    var recipe: Selectable?
    let realm = try! Realm()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.titleView = UIImageView(image: Logo.getNegativeLogo())
        self.navigationController?.navigationBar.topItem?.title = ""
        whoSaysWebPage.delegate = self
        whoSaysWebPage.loadRequest(URLRequest(url: URL(string: contentUrl)!))

        // Remove export and more options buttons when there isn't an available book to edit or manipulate.
        //
        // This is necessary for the "Who Says So" page that's accessed when the user is in the view to create a
        // VeggieBook. In this view, there isn't a VeggieBook to edit or export. However, this view is also used to
        // display recipes and tips. In those views, the user is able to edit and export the associated VeggieBook.
        if self.availableBook == nil {
            self.navigationItem.setRightBarButtonItems(nil, animated: false)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func shareUrlButton(_ sender: Any) {
        let book = realm.object(ofType: AvailableBook.self, forPrimaryKey: createdBook?["availableBookId"])
        let activityItem = VeggieBookShare(contentUrl: self.contentUrl, book: book!, recipe: self.recipe)
        let activityViewController = UIActivityViewController(activityItems: [activityItem], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MoreButtonClicked" {
            guard let moreViewController = segue.destination as? MoreViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            moreViewController.availableBook = availableBook
            moreViewController.createdBookId = self.createdBookId
        }
    }
}

extension WhoSaysViewController: UIWebViewDelegate {
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

class VeggieBookShare: NSObject, UIActivityItemSource {
    var contentUrl: String
    var book: AvailableBook
    var recipe: Selectable?
    
    init(contentUrl: String, book: AvailableBook, recipe: Selectable? = nil) {
        self.contentUrl = contentUrl
        self.book = book
        self.recipe = recipe
    }
    
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return contentUrl
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivityType) -> Any? {
        switch activityType {
        case UIActivityType.message,
             UIActivityType.mail,
             UIActivityType.copyToPasteboard:
            return buildShareString()
        default:
            return contentUrl
        }
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, subjectForActivityType activityType: UIActivityType?) -> String {
        switch activityType! {
        case UIActivityType.mail:
            return buildSubjectString()
        case UIActivityType.message:
            return ""
        case UIActivityType.copyToPasteboard:
            return ""
        default:
            return ""
        }
    }
    
    private func buildShareString() -> String {
        var shareString = ""
        if let recipe = self.recipe {
            if book["bookType"] as? String == "SECRETS_BOOK" {
                let shareStringEn = "I found some great \(book["titleEn"]!), and thought you would find these ideas helpful.\n\nCheck them out here:\n\(recipe["shareUrlEn"]!)"
                let shareStringEs = "Encontré unos Secretros para \(book["titleEs"]!), y pensé que tu encontrarías estas ideas útiles\n\nÉchale un vistazo aquí:\n\(recipe["shareUrlEs"]!)"
                shareString = LanguageCode.appLanguage.isSpanish() ? shareStringEs : shareStringEn
            } else {
                let shareStringEn = "I created a \(book["titleEn"]!) VeggieBook, and it has some great recipes and tips. I thought you would like this recipe for \(recipe["titleEn"]!).\n\nCheck it out here:\n\(recipe["shareUrlEn"]!)"
                let shareStringEs = "He creado un VeggieBook de \(book["titleEs"]!) que tiene unas recetas y consejos excelentes, y pensé que a ti te gustaría esta receta de \(recipe["titleEs"]!).\n\nÉchale un vistazo en:\n\(recipe["shareUrlEs"]!)"
                shareString = LanguageCode.appLanguage.isSpanish() ? shareStringEs : shareStringEn
            }
        } else {
            // sharing a tip
            let shareStringEn = "I created a \(book["titleEn"]!) VeggieBook, and it has some great recipes and tips. I thought you would like this tip for \(book["titleEn"]!).\n\nCheck it out here:\n\(contentUrl)"
            let shareStringEs = "He creado un VeggieBook de \(book["titleEs"]!) que tiene unas recetas y consejos excelentes, y pensé que tu encontrarías estos consejos muy útiles.\n\nÉchale un vistazo aquí:\n\(contentUrl)"
            shareString = LanguageCode.appLanguage.isSpanish() ? shareStringEs : shareStringEn
        }
        print(shareString)
        //        á, é, í, ó, ú
        return shareString
    }
    
    private func buildSubjectString() -> String {
        var subjectString = ""
        if let recipe = self.recipe {
            let recipeTitleEn = recipe["titleEn"] as? String
            let recipeTitleEs = recipe["titleEs"] as? String
            if book["bookType"] as? String == "SECRETS_BOOK" {
                let subjectStringEn = "Secrets to Better Eating: \(recipeTitleEn!)"
                let subjectStringEs = "Secretos: \(recipeTitleEs!)"
                subjectString = LanguageCode.appLanguage.isSpanish() ? subjectStringEs : subjectStringEn
            } else {
                let subjectStringEn = "VeggieBook: \(book["titleEn"]!), \(recipeTitleEn!)"
                let subjectStringEs = "VeggieBook: Una Combinación de \(book["titleEs"]!), \(recipeTitleEs!))"
                subjectString = LanguageCode.appLanguage.isSpanish() ? subjectStringEs : subjectStringEn
            }
        } else {
            // sharing a tip
            let subjectStringEn = "VeggieBook: \(book["titleEn"]!) Tips"
            let subjectStringEs = ""
            subjectString = LanguageCode.appLanguage.isSpanish() ? subjectStringEs : subjectStringEn
        }
        print(subjectString)
        return subjectString
    }
}
