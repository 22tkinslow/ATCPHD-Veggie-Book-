//
//  RecipeOrSecrectsViewController.swift
//  VeggieBook
//
//  Created by Matt Flickner on 7/25/17.
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
import Alamofire
import AlamofireImage

class RecipeOrSecrectsViewController: UIViewController {
    let sectionInsets = UIEdgeInsets(top: 8.0, left: 4.0, bottom: 8.0, right: 4.0)
    let itemsPerRow: CGFloat = 2
    var createdBook : CreatedBook! = nil
    var photos = [Int:UIImage]()
    typealias ImageCompletion = () -> Void
    let realm = try! Realm()
    var keptRecipes = [Selectable]()

    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        let image = Logo.getNegativeLogo()
        navigationItem.titleView = UIImageView(image: image)
        
        print(createdBook.selectables.count)
        for selectable in createdBook.selectables {
            if selectable.selected {
                keptRecipes.append(selectable)
            }
        }
        print(keptRecipes.count)
        loadCellPhotos(){
            self.collectionView.reloadData()
        }

        // Do any additional setup after loading the view.
    }
    
    func loadCellPhotos(completion: @escaping ImageCompletion) {
        let group = DispatchGroup()
        for (index, selectable) in keptRecipes.enumerated() {
            group.enter()
            let imageUrl = selectable["photoUrlEn"] as! String
            let url = URL(string: imageUrl)
            Alamofire.request(url!).responseImage { response in
                guard let image = response.result.value else {
                    group.leave()
                    return
                }
                self.photos[index] = image
                group.leave();
            }
        }
        group.notify(queue: .main){
            completion()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let id = self.createdBook["id"]
        let ab = realm.object(ofType: AvailableBook.self, forPrimaryKey: createdBook["availableBookId"])!
        if segue.identifier == "TipClicked" {
            guard let recipeTipController = segue.destination as? WhoSaysViewController,
                let tipUrl = ((LanguageCode.appLanguage.isSpanish()) ?
                    createdBook["tipsUrlEs"] : createdBook["tipsUrlEn"]) as? String
            else {
                fatalError()
            }
            recipeTipController.contentUrl = tipUrl
            recipeTipController.createdBook = createdBook
            recipeTipController.availableBook = ab // to edit a book from the tip page
        
//            let recipeTipController = segue.destination as? WhoSaysViewController
//            let cell = sender as? RecipeOrSecrectsCollectionViewCell
//            recipeTipController?.contentUrl = (cell?.contentUrl)!
//            recipeTipController?.availableBook = ab
//            recipeTipController?.createdBookId = id as! Int
//            if let indexPath = self.collectionView.indexPathsForSelectedItems?[0],
//                indexPath.item != 0 {
//                recipeTipController?.recipe = keptRecipes[indexPath.item]
//            }
        }
        if segue.identifier == "RecipeClicked" {
            guard let recipe = sender as? Selectable,
                let recipeTipController = segue.destination as? WhoSaysViewController
            else {
                fatalError()
            }
            recipeTipController.createdBook = createdBook
            recipeTipController.recipe = recipe
            recipeTipController.contentUrl = (LanguageCode.appLanguage.isSpanish() ? recipe["urlEs"] : recipe["urlEn"])! as! String
            recipeTipController.createdBookId = id as! Int
            recipeTipController.availableBook = ab // to edit a book from the recipe page
        }
        
        if segue.identifier == "MoreButtonClicked" {
            guard let moreViewController = segue.destination as? MoreViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            moreViewController.availableBook = ab
            moreViewController.createdBookId = id as! Int
        }
    }

}

extension RecipeOrSecrectsViewController : UICollectionViewDataSource {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if createdBook?["tipsUrlEn"] as! String == "" {
            return keptRecipes.count
        }
        return keptRecipes.count + 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecipeCell", for: indexPath) as! RecipeOrSecrectsCollectionViewCell
        let test = createdBook?["tipsUrlEn"] as! String
        var selectableIndex = indexPath.item
        if test != "" {
            if indexPath.item == 0 {
                let ab = realm.object(ofType: AvailableBook.self, forPrimaryKey: createdBook["availableBookId"])!
                let title = LanguageCode.appLanguage.isSpanish() ? "Sugerencias/Consejos para \(ab.title())" : "Tips for " + ab.title()
                cell.label.text = title
                let tipUrl = (LanguageCode.appLanguage.isSpanish()) ? createdBook["tipsUrlEs"] : createdBook["tipsUrlEn"]
                cell.contentUrl = tipUrl as! String
                cell.coverPhoto.image = #imageLiteral(resourceName: "light_bulb")
                return cell
            }
            
            selectableIndex = indexPath.item - 1
        }

        let selectable = keptRecipes[selectableIndex]
        let title = (LanguageCode.appLanguage.isSpanish() ? selectable["titleEs"] : selectable["titleEn"]) as! String
        cell.label.text = title
        cell.coverPhoto.image = self.photos[selectableIndex]
        cell.contentUrl = (LanguageCode.appLanguage.isSpanish() ? selectable["urlEs"] : selectable["urlEn"])! as! String
        
        return cell
    }
}

extension RecipeOrSecrectsViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (createdBook?["tipsUrlEn"] as? String != "") && indexPath.item == 0 {
            // tip selected
            self.performSegue(withIdentifier: "TipClicked", sender: self)
        } else {
            // recipe selected
            var path = indexPath.item
            if (createdBook?["tipsUrlEn"] as? String) != "" {
                path = indexPath.item - 1
            }
            self.performSegue(withIdentifier: "RecipeClicked", sender: keptRecipes[path])
        }
    }
}

extension RecipeOrSecrectsViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.bounds.width - sectionInsets.left * 2 - sectionInsets.right
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.top / 2
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}
