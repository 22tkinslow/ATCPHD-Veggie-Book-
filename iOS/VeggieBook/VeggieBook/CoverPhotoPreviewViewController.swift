//
//  CoverPhotoPreviewViewController.swift
//  VeggieBook
//
//  Created by Matt Flickner on 7/5/17.
//  Copyright © 2017 Technical Empowerment Inc. All rights reserved.
//

import UIKit
import RealmSwift

class CoverPhotoPreviewViewController: UIViewController {
    
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var changeImageButton: UIButton!
    @IBOutlet weak var coverPhotoImageView: UIImageView!
    @IBOutlet weak var outlineView: UIView!
    var photo: UIImage?
    var bookBuilder: BookBuilder?
    var chosenPhotoUrl = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        coverPhotoImageView.image = photo
        let image = bookBuilder?.availableBook.bookType == "RECIPE_BOOK" ? Logo.getNegativeLogo() : Logo.getSecretsLogo()
        navigationItem.titleView = UIImageView(image: image)
        self.navigationController?.navigationBar.topItem?.title = ""
        
        changeImageButton.setTitle(LanguageCode.appLanguage.isSpanish() ? "Cambiar La Portada" : "Change Image", for: .normal)
        submitButton.setTitle(LanguageCode.appLanguage.isSpanish() ? "OPRIMA AQUI" : "SUBMIT", for: .normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        outlineView.layer.masksToBounds = false
        outlineView.layer.shadowColor = UIColor.darkGray.cgColor
        outlineView.layer.shadowRadius = 6
        outlineView.layer.shadowOpacity = 0.7
        outlineView.layer.shadowOffset.width = -1
        outlineView.layer.shadowOffset.height = 1
        outlineView.layer.shadowPath = UIBezierPath(rect: outlineView.bounds).cgPath
        outlineView.layer.shouldRasterize = true
        outlineView.layer.rasterizationScale = UIScreen.main.scale
    }
    
    @IBAction func changeImageTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func submitButtonTapped(_ sender: Any) {
        var request = URLRequest(url: RestEndPoint.CreateVeggieBook.url!)
        let data = CreateBookRequest(bookBuilder: bookBuilder!).data
        request.httpBody = data
        request.httpMethod = "POST"
            
        let task = URLSession.shared.dataTask(with: request){ data, response, error in
            guard let data = data, error == nil else{
                print("error=\(String(describing: error))")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                print("error=\(String(describing: error))")
                return
            }
            
            do {
                guard let createdBookJson = try JSONSerialization.jsonObject(with: data, options: [])
                    as? [String: Any] else {
                        print("error trying to convert data to JSON")
                        return
                }
                DispatchQueue.main.async {
                    let book = CreatedBook.initFromJson(bookObject: createdBookJson, availableBookId: (self.bookBuilder?.availableBook.id)!, selectables: (self.bookBuilder?.selectables)!, url: self.chosenPhotoUrl)
                    let realm = try! Realm()
                    let filterPredicate = NSPredicate(format: "availableBookId == %@", book.availableBookId)
                    let theBooks = realm.objects(CreatedBook.self).filter(filterPredicate)
                    try! realm.write {
                        if theBooks.count > 0 {
                            realm.delete(theBooks)
                        }
                        realm.add(book)
                    }
                    self.performSegue(withIdentifier: "unwindToViewController1", sender: self)
                }
            } catch  {
                print("error trying to convert data to JSON")
                print("\(data)")
                return
            }
        }
        task.resume()
    }
}
