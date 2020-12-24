//
//  ExtraCopyViewController.swift
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
import Alamofire
import AlamofireImage
import DLRadioButton

class ExtraCopyViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var youCanPrintLabel: UILabel!
    @IBOutlet weak var justTouchLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    
    var bookBuilder : BookBuilder!
    var photos : [AvailablePhoto]!
    let sectionInsets = UIEdgeInsets(top: 4.0, left: 4.0, bottom: 4.0, right: 4.0)
    let itemsPerRow: CGFloat = 2
    var wantedSelectables : [Selectable] = []
    var selectablesImage = [Int:UIImage]()
    var bookBuilderIndex = [Int]()
    typealias ImageCompletion = () -> Void

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        loadData()
        loadCellPhotos()
        
        
        self.navigationController?.navigationBar.topItem?.title = ""
        
        let itemTypePlural = bookBuilder.availableBook.bookType == "SECRETS_BOOK" ? "Secrets" : "recipes"
        let itemType = itemTypePlural.substring(to: itemTypePlural.index(before: itemTypePlural.endIndex))
        youCanPrintLabel.text = LanguageCode.appLanguage.isSpanish() ? "Usted puede imprimir una COPIA EXTRA de cualquier recetas para dar a una familia o amigos"
            : "You can print an EXTRA COPY of any \(itemType) to give to family or friends."
        justTouchLabel.text = LanguageCode.appLanguage.isSpanish() ? "Solo seleccione las recetas de las que quiera una COPIA EXTRA"
                                                                        : "Just touch a \(itemType) for an EXTRA COPY"
        let image = bookBuilder.availableBook.bookType == "RECIPE_BOOK" ? Logo.getNegativeLogo() : Logo.getSecretsLogo()
        nextButton.setTitle(LanguageCode.appLanguage.isSpanish() ? "SIGUIENTE" : "NEXT", for: .normal)
        navigationItem.titleView = UIImageView(image: image)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ChoosePhotoView" {
            let photoController = segue.destination as! PhotosViewController
            photoController.bookBuilder = self.bookBuilder
            photoController.photos = (self.bookBuilder?.photos)!
        }
    }
    
    func loadData() {
        let selectables = self.bookBuilder.selectables
        for (index, selectable) in selectables.enumerated() {
            if selectable.selected {
                self.wantedSelectables.append(selectable)
                self.bookBuilderIndex.append(index)
            }
        }
    }
    
    func loadCellPhotos() {
        let group = DispatchGroup()
        for (index, selectable) in wantedSelectables.enumerated() {
            group.enter()
            let imageUrl = selectable["photoUrlEn"] as! String
            let url = URL(string: imageUrl)
            Alamofire.request(url!).responseImage { response in
                guard let image = response.result.value else {
                    group.leave()
                    return
                }
                self.selectablesImage[index] = image
                group.leave()
            }
        }
        group.notify(queue: .main){
            self.collectionView.reloadData()
        }
    }
}

extension ExtraCopyViewController : UICollectionViewDataSource {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return wantedSelectables.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "extraCopy", for: indexPath) as! ExtraCopyCollectionViewCell
        cell.label.text = wantedSelectables[indexPath[1]].title
        cell.imageView.image = selectablesImage[indexPath[1]]
        cell.radioButton.tag = indexPath.row
        cell.radioButton.addTarget(self, action: #selector(handleButtonClick), for: .touchUpInside)
        return cell
    }
    
    func handleButtonClick(sender: DLRadioButton){
        if sender.isSelected {
            bookBuilder.selectables[bookBuilderIndex[sender.tag]].extras = 1
        } else {
            bookBuilder.selectables[bookBuilderIndex[sender.tag]].extras = 0
        }
    }
}

extension ExtraCopyViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let availableWidth = collectionView.bounds.width - sectionInsets.left * 2 - sectionInsets.right
        let itemWidth = availableWidth/itemsPerRow
        return CGSize(width: itemWidth, height: itemWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.top
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}
