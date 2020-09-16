//
//  VeggieBooksViewController.swift
//  VeggieBook
//
//  Created by Daniel DiPasquo on 1/10/17.
//  Copyright © 2017 DiPasquo Consulting. All rights reserved.
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
import RealmSwift
import Alamofire
import AlamofireImage

class VeggieBooksViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, GIDSignInUIDelegate {

    @IBOutlet weak var tableView: UITableView!
    var createdBooks : [CreatedBook] = []
    var chosenImages = [Int: UIImage]()
    var editBook : BookBuilder!
    var fromEdit = false
    @IBOutlet weak var CreateVeggieBookButton: UIButton!
    @IBOutlet weak var CreateSecretBookButton: UIButton!
    @IBOutlet weak var settingsButton: UIBarButtonItem!
    
    func redrawTableView() -> () {
        tableView.reloadData()
        self.viewDidLoad()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        definesPresentationContext = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 200
        loadCreatedBooks()
        navigationItem.titleView = UIImageView(image: Logo.getNegativeLogo())
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        CreateVeggieBookButton.setTitle(LanguageCode.appLanguage.isSpanish() ? "Crear VeggieBook Nuevo" : "Create New VeggieBook", for: .normal)
        CreateSecretBookButton.setTitle(LanguageCode.appLanguage.isSpanish() ? "Crear un Libro de Secretos" : "Create New SecretsBook", for: .normal)
    }

    /**
     Log the user out of Google and direct them to the login screen.
       - parameter segue: The segue one is coming from.
       - important: This method has been deprecated since Google Sign In is not currently supported.
     */
    @available(iOS, deprecated, message: "Google Sign In is no longer the default sign in method.")
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue){
        if UserDefaults.standard.integer(forKey: "profileId") == 0 {
            GIDSignIn.sharedInstance().signOut()
            performSegue(withIdentifier: "LoginSegue", sender: self)
            return
        }
        loadCreatedBooks()
        self.tableView.reloadData()
    }

    /**
     Set this controller as the Google Sign In UI delegate and if the user is not already signed in, log them out of
     Google and direct them to to the login screen.
       - important: This method has been deprecated since Google Sign In is not currently supported.
     */
    @available(iOS, deprecated, message: "Google Sign In is no longer the default sign in method.")
    private func directUserToGoogleLoginIfNotLoggedIn() {
        GIDSignIn.sharedInstance().uiDelegate = self
        if UserDefaults.standard.integer(forKey: "profileId") == 0 {
            GIDSignIn.sharedInstance().signOut()
            performSegue(withIdentifier: "LoginSegue", sender: self)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if fromEdit {
            if editBook.availableBook.bookType == "SECRETS_BOOK" {
                self.performSegue(withIdentifier: "EditSelectedSecret", sender: self)
            } else {
                self.performSegue(withIdentifier: "EditSelectedBook", sender: self)
            }
        }
    }
    
    func loadCreatedBooks() {
        let realm = try! Realm()
        let books = realm.objects(CreatedBook.self)
        createdBooks = Array(books)
    }
    
//    func loadChosenCovers() {
//        let group = DispatchGroup()
//        for (index, book) in createdBooks.enumerated() {
//            group.enter()
//            guard let photoUrl = book["chosenPhotoUrl"] as? String else {
//                fatalError("CreatedBook has no value for key")
//            }
//            Alamofire.request(photoUrl).responseImage { response in
//                guard let image = response.result.value else {
//                    group.leave()
//                    return
//                }
//                self.chosenImages[index] = image
//                group.leave()
//            }
//        }
//        group.notify(queue: .main){
//            self.tableView.reloadData()
//        }
//    }
    
    // MARK: UITableViewDelegate
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return createdBooks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "VeggieBookTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? VeggieBookTableViewCell  else {
            fatalError("The dequeued cell is not an instance of QuestionChoiceTableViewCell.")
        }
        
        let realm = try! Realm()
        
        let createdBook = createdBooks[indexPath.row]
        
        guard let id = createdBook["availableBookId"] as? String,
            let photoUrl = createdBook["chosenPhotoUrl"] as? String else {
                fatalError("CreatedBook has no value for key")
        }
            
        let book = realm.object(ofType: AvailableBook.self, forPrimaryKey: id)
        let imageUrl = URL(string: (book?.largeUrl)!)
        cell.coverPhoto?.sd_setImage(with: imageUrl, placeholderImage: #imageLiteral(resourceName: "placeholder"))
        let chosenImage = URL(string: (photoUrl))
        cell.chosenPhoto.clipsToBounds = true
        cell.chosenPhoto.sd_setImage(with: chosenImage)
        cell.createdBook = createdBook
        cell.bookLabel.text = book?.title()
        cell.gradientView.gradient.frame = CGRect(x: 0, y: 0, width: cell.bounds.width, height: cell.gradientView.gradient.frame.height)
        return cell
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let bookType = segue.identifier == "CreateSecretBook" ? "SECRETS_BOOK" : "RECIPE_BOOK"
        let createBookController = segue.destination as? CreateBookViewController
        createBookController?.bookType = bookType
        
        if segue.identifier == "createdBookClicked" {
            let recipeTipController = segue.destination as? RecipeOrSecrectsViewController
            let cell = sender as! VeggieBookTableViewCell
            recipeTipController?.createdBook = cell.createdBook
        }
        
        if segue.identifier == "EditSelectedBook" {
            self.fromEdit = false
            let interviewPageView = segue.destination as? InterviewViewController
            interviewPageView?.bookBuilder = editBook
        }
        
        if segue.identifier == "EditSelectedSecret" {
            self.fromEdit = false
            let recipePageView = segue.destination as? RecipeViewController
            recipePageView?.bookBuilder = editBook
        }
        
        if segue.identifier == "settingsSegue" {
            settingsButton.isEnabled = false
            let popupView = segue.destination as? PopupViewController
            popupView?.settingsButton = self.settingsButton
            popupView?.redrawInNewLanguage = self.redrawTableView
        }
    }
}
