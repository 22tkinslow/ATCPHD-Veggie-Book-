//
//  PhotosViewController.swift
//  VeggieBook
//
//  Created by Matt Flickner on 6/29/17.
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
import TOCropViewController

class PhotosViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var chooseCoverLabel: UILabel!
    @IBOutlet weak var takePhotoButton: UIButton!
    @IBOutlet weak var photoLibButton: UIButton!
    
    var bookBuilder : BookBuilder? = nil
    var photos : [AvailablePhoto] = []
    var selectableImages = [Int: UIImage]()
    var imageUrls = [Int: String]()
    var wantedSelectables = [Selectable]()
    let itemsPerRow: CGFloat = 2
    let sectionInsets = UIEdgeInsets(top: 4.0, left: 4.0, bottom: 4.0, right: 4.0)
    var imagePicked : UIImage? = nil
    var imagePickedUrl = ""
    typealias ImageCompletion = ([String:Any]) -> Void
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let image = bookBuilder?.availableBook.bookType == "RECIPE_BOOK" ? Logo.getNegativeLogo() : Logo.getSecretsLogo()
        navigationItem.titleView = UIImageView(image: image)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let bookTypeString = bookBuilder?.availableBook.bookType == "SECRETS_BOOK" ? "SecretsBook" : "VeggieBook"
        
        chooseCoverLabel.text = LanguageCode.appLanguage.isSpanish() ? "Ahora, escoja la portada para su \(bookTypeString)" : "Now, choose the cover for your \(bookTypeString)"
        takePhotoButton.setTitle(LanguageCode.appLanguage.isSpanish() ? "Use una foto ya archivada en su telefono" : "Take a photo now", for: .normal)
        photoLibButton.setTitle(LanguageCode.appLanguage.isSpanish() ? "O escoja una de las fotos abajo" : "Use a photo from my phone", for: .normal)
        
        if bookBuilder?.availableBook.bookType == "SECRETS_BOOK" {
            takePhotoButton.removeFromSuperview()
            photoLibButton.removeFromSuperview()
        }
        
        loadData()
        loadCellPhotos()
        
        self.navigationController?.navigationBar.topItem?.title = ""
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadData() {
        let selectables = self.bookBuilder!.selectables
        for selectable in selectables {
            if selectable.selected {
                self.wantedSelectables.append(selectable)
            }
        }
    }
    
    func loadCellPhotos() {
        bookBuilder?.availableBook.bookType == "SECRETS_BOOK" ?
            loadSecretsPhotos() : loadVeggiePhotos()
    }
    
    private func loadVeggiePhotos(){
        let group = DispatchGroup()
        for (index, photo) in photos.enumerated() {
            group.enter()
            let imageUrl = photo.url
            let url = URL(string: imageUrl)
            Alamofire.request(url!).responseImage { response in
                guard let image = response.result.value else {
                    group.leave()
                    return
                }
                self.selectableImages[index] = image
                self.imageUrls[index] = imageUrl
                group.leave()
            }
        }
        group.notify(queue: .main){
            self.collectionView.reloadData()
        }
    }
    
    private func loadSecretsPhotos(){
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
                self.selectableImages[index] = image
                self.imageUrls[index] = imageUrl
                group.leave()
            }
        }
        group.notify(queue: .main){
            self.collectionView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        if segue.identifier == "photoPreview" {
            guard let coverPhotoViewController = segue.destination as? CoverPhotoPreviewViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            coverPhotoViewController.bookBuilder = bookBuilder
            coverPhotoViewController.photo = imagePicked
            coverPhotoViewController.chosenPhotoUrl = imagePickedUrl
        }
        
    }
    
    func uploadPhoto(image: UIImage, completion: @escaping ImageCompletion) {
        
        var r  = URLRequest(url: RestEndPoint.UploadImage.url!)
        r.httpMethod = "POST"
        let boundary = "Boundary-\(UUID().uuidString)"
        r.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        r.setValue("Keep-Alive", forHTTPHeaderField: "Connection")
        
        let fileName = "userPhoto/" + boundary
                
        r.httpBody = createBody(parameters: ["owner": UserDefaults.standard.integer(forKey: "profileId")],
                                boundary: boundary,
                                data: UIImageJPEGRepresentation(image, 0.2)!,
                                mimeType: "image/jpg",
                                filename: fileName)
        
        let task = URLSession.shared.dataTask(with: r){ data, response, error in
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
                guard let createImage = try JSONSerialization.jsonObject(with: data, options: [])
                    as? [String: Any] else {
                        print("error trying to convert data to JSON")
                        return
                }
                DispatchQueue.main.async {
                    completion(createImage)
                }
            } catch  {
                print("error trying to convert data to JSON")
                print("\(data)")
                return
            }
        }
        task.resume()   
    }
    
    func createBody(parameters: [String: Int],
                    boundary: String,
                    data: Data,
                    mimeType: String,
                    filename: String) -> Data {
        let body = NSMutableData()
        
        let boundaryPrefix = "--\(boundary)\r\n"
        
        for (key, value) in parameters {
            body.appendString(boundaryPrefix)
            body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.appendString("\(value)\r\n")
        }
        
        body.appendString(boundaryPrefix)
        body.appendString("Content-Disposition: form-data; name=\"img\"; filename=\"\(filename)\"\r\n")
        body.appendString("Content-Type: \(mimeType)\r\n\r\n")
        body.append(data)
        body.appendString("\r\n")
        body.appendString("--".appending(boundary.appending("--")))
        
        return body as Data
    }
}

extension NSMutableData {
    func appendString(_ string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
        append(data!)
    }
}

extension PhotosViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! PhotoCollectionViewCell
        self.bookBuilder?.coverPhoto = photos[indexPath.row].id
        imagePicked = cell.photoImage.image
        imagePickedUrl = cell.imagePickedUrl
        self.performSegue(withIdentifier: "photoPreview", sender: collectionView.cellForItem(at: indexPath))
    }
}

extension PhotosViewController : UICollectionViewDataSource {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = selectableImages.count
        if APP_VERSION == "CHI" && bookBuilder?.availableBook.bookType != "SECRETS_BOOK" {
            return photos.count > 1 ? 2 : 1
        }
        return count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! PhotoCollectionViewCell
        // Configure the cell
        cell.photoImage.image = selectableImages[indexPath.row]
        cell.imagePickedUrl = imageUrls[indexPath.row] ?? ""
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "photosHeaderView", for: indexPath) as! PhotosHeaderView
            headerView.label.text = LanguageCode.appLanguage.isSpanish() ?
                "O escoja una de las fotos abajo" : "Or, choose a picture from below"
            return headerView
        default:
            fatalError("Unexpect Supplemental View")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return bookBuilder?.availableBook.bookType == "SECRETS_BOOK" ? CGSize.zero : CGSize(width: collectionView.frame.width, height: 50)
    }
}

extension PhotosViewController : UICollectionViewDelegateFlowLayout {
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

extension PhotosViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBAction func openCameraButton(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true)
        }
    }
    
    @IBAction func openPhotoLibraryButton(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let cropController = TOCropViewController(image: image)
            cropController.aspectRatioPreset = .presetSquare
            cropController.aspectRatioLockEnabled = true
            cropController.aspectRatioPickerButtonHidden = true
            cropController.delegate = self
            DispatchQueue.main.async {
                self.present(cropController, animated: true, completion: nil)
            }
        }
        picker.dismiss(animated: true, completion: nil);
    }
}

extension PhotosViewController: TOCropViewControllerDelegate {
    func cropViewController(_ cropViewController: TOCropViewController, didFinishCancelled cancelled: Bool) {
        cropViewController.dismiss(animated: true, completion: nil)
    }
    
    func cropViewController(_ cropViewController: TOCropViewController, didCropToImage image: UIImage, rect cropRect: CGRect, angle: Int) {
        // image is now cropped
        uploadPhoto(image: image) { response in
            self.imagePicked = image
            self.imagePickedUrl = response["url"] as! String
            self.bookBuilder?.coverPhoto = response["id"] as! Int
            cropViewController.dismiss(animated: true){ Void in
                self.performSegue(withIdentifier: "photoPreview", sender: self)
            }
        }
    }
}

class PhotosHeaderView: UICollectionReusableView {
    @IBOutlet weak var label: UILabel!
}
