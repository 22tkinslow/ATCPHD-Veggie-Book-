//
//  KeepDropPageViewController.swift
//  VeggieBook
//
//  Created by Matt Flickner on 6/26/17.
//  Copyright © 2020 Quick Help For Meals, LLC. All rights reserved.
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

class SelectablePageViewController: UIPageViewController {
    
    var bookBuilder : BookBuilder? = nil
    var availablePhotos : AvailablePhoto? = nil
    private(set) lazy var selectablesController = [SelectableViewController]()
    var controllerCount = -1
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // var webSiteBuilder : WebSiteBuilder? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func goToNextPage() {
        // initialize next next page
        // called after keep or drop action
        
        if controllerCount + 1 < selectablesController.count {
            if (controllerCount >= 0){
                let currentPage = selectablesController[controllerCount]
                currentPage.keepButton.isEnabled = false
                currentPage.dropButton.isEnabled = false
            }
            controllerCount += 1
            let nextPage = selectablesController[controllerCount]
            nextPage.pageLabelString = "( " + String(controllerCount + 1) + " / " + String(selectablesController.count) + " )"
            nextPage.viewDidLoad()
            nextPage.keepButton.isEnabled = false
            nextPage.dropButton.isEnabled = false
            setViewControllers([nextPage],
                               direction: .forward,
                               animated: true){ finished in
                nextPage.keepButton.isEnabled = true
                nextPage.dropButton.isEnabled = true
            }
        } else {
            let selectableUrl = self.bookBuilder?.selectables[0].urlEn ?? ""
            let isSecretsBook = selectableUrl.contains("mobileSecret")
            isSecretsBook ? getSecretsPhotos() : getPhotos()
        }
        
    }
    
    func goToPreviousPage() {
        // initialize previous page
        // only called when the back button is hit
        
        if controllerCount - 1 >= 0 {
            let currentPage = selectablesController[controllerCount]
            currentPage.keepButton.isEnabled = false
            currentPage.dropButton.isEnabled = false
            controllerCount -= 1
            let previousPage = selectablesController[controllerCount]
            previousPage.pageLabelString = "( " + String(controllerCount + 1) + " of " + String(selectablesController.count) + " )"
            previousPage.keepButton.isEnabled = false
            previousPage.dropButton.isEnabled = false
            setViewControllers([previousPage],
                               direction: .reverse,
                               animated: true){ finished in
                previousPage.keepButton.isEnabled = true
                previousPage.dropButton.isEnabled = true
            }
            
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    public func webPagesReady() {
        for selectable in (bookBuilder?.selectables)! {
            let controller = storyboard?.instantiateViewController(withIdentifier: "keepDrop") as! SelectableViewController
            controller.webPage = selectable.url
            controller.pageViewController = self
            let _ = controller.view
            selectablesController.append(controller)
        }
        goToNextPage()
    }
    
    
    private func getPhotos(){
        let url = RestEndPoint.AvailablePhotos.url!
        var request = URLRequest(url: url)
        let data = bookBuilder?.photosRequest.data
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
            
            // parse the result as JSON, since that's what the API provides
            do {
                guard let photosJson = try JSONSerialization.jsonObject(with: data, options: [])
                    as? [[String: Any]] else {
                        print("error trying to convert data to JSON")
                        return
                }
                self.bookBuilder?.initalizePhotos(fromJson: photosJson)
                self.setUpPhotoController()
            } catch  {
                print("error trying to convert data to JSON")
                return
            }
        }
        task.resume()
        
    }
    
    private func getSecretsPhotos(){
        self.bookBuilder?.initializeSecretsPhotos(fromSelectables: self.bookBuilder?.selectables ?? [])
        self.setUpPhotoController()
    }
    
    private func setUpPhotoController(){
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if APP_VERSION == "MFF" {
                if let photoController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "choosePhoto") as? PhotosViewController {
                    photoController.bookBuilder = self.bookBuilder
                    photoController.photos = (self.bookBuilder?.photos)!
                    
                    self.navigationController?.pushViewController(photoController, animated: true)
                }
            } else {
                let extraCopyController = storyboard.instantiateViewController(withIdentifier: "ExtraCopyView") as! ExtraCopyViewController
                extraCopyController.bookBuilder = self.bookBuilder
                extraCopyController.photos = (self.bookBuilder?.photos)!
                self.navigationController?.pushViewController(extraCopyController, animated: true)
            }
        }
    }
}
