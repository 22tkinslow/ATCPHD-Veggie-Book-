//
//  CreateBookViewController.swift
//  VeggieBook
//
//  Created by Matt Flickner on 7/10/17.
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

class CreateBookViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var whoSaysSoButton: UIButton!
    @IBOutlet weak var stackViewBottomConstraint: NSLayoutConstraint!
    
    var bookType: String?
    var booksAvailable = [AvailableBook]()
    var bookImages = [String: UIImage?]()

    //MARK: Private Methods
    
    private func loadAvailableBooks(){
        let realm = try! Realm()
        
        let filterPredicate = NSPredicate(format: "bookType == %@", bookType!)
        var sortby = LanguageCode.appLanguage.isSpanish() ? "titleEs" : "titleEn"
        if bookType != "RECIPE_BOOK" {
            sortby = "id"
        }
        let results = realm.objects(AvailableBook.self).filter(filterPredicate).sorted(byKeyPath: sortby, ascending: true)
        booksAvailable = Array(results)
        getImagesForBooks()
    }
    
    private func getImagesForBooks(){
        let group = DispatchGroup()
        for book in booksAvailable {
            group.enter()
            let imageUrl = URL(string: book.url)
            Alamofire.request(imageUrl!).responseImage { response in
                guard let image = response.result.value else {
                    group.leave()
                    return
                }
                self.bookImages[book.id] = image
                group.leave()
            }
        }

        group.notify(queue: .main){
            self.tableView.reloadData()
        }
    }
    
    @IBAction func whoSaysSoButtonClicked(_ sender: Any) {
        self.performSegue(withIdentifier: "whoSaysSegue", sender: self)
    }
    
    // MARK: Overridden Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        if bookType! == "RECIPE_BOOK" {
            whoSaysSoButton.removeFromSuperview()
            stackViewBottomConstraint.constant = 0
        }
        if LanguageCode.appLanguage.isSpanish() {
            whoSaysSoButton.setTitle("¿Quién lo dice?", for: .normal)
        }
        let image = bookType == "RECIPE_BOOK" ?
            Logo.getNegativeLogo() : Logo.getSecretsLogo()
        navigationItem.titleView = UIImageView(image: image)
        let backButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButton
        self.tableView.tableFooterView = UIView()
        loadAvailableBooks()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        if segue.identifier == "StartCreation" {
            guard let interviewViewController = segue.destination as? InterviewViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedCell = sender as? CreateBookTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedBook = booksAvailable[indexPath.row]
            selectedCell.isSelected = false
            interviewViewController.bookBuilder = BookBuilder(book: selectedBook)
            
        }
        
        if segue.identifier == "SecretSelectables" {
            guard let fetchingVC = segue.destination as? FetchingViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedCell = sender as? CreateBookTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedBook = booksAvailable[indexPath.row]
            selectedCell.isSelected = false
            fetchingVC.bookBuilder = BookBuilder(book: selectedBook)
            
        }
        
    }
}

extension CreateBookViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellIdentifier = ""
        if (bookType == "RECIPE_BOOK") {
            cellIdentifier = "CreateBookTableViewCell"
        } else if (bookType == "SECRETS_BOOK"){
            cellIdentifier = "CreateSecretTableViewCell"
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CreateBookTableViewCell  else {
            fatalError("The dequeued cell is not an instance of CreateBookTableViewCell.")
        }
        let book = booksAvailable[indexPath.row]
        cell.bookLabel.text = book.title()
        if let image = bookImages[book.id] {
            cell.bookImageView.image = image
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return booksAvailable.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if LanguageCode.appLanguage.isSpanish() {
            return bookType == "RECIPE_BOOK" ? "Seleccione una Verdura" : "Elegir una clase de Secretos"
        }
        return bookType == "RECIPE_BOOK" ? "Select VeggieBook" : "Choose the Secrets You Want"
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.contentView.backgroundColor = UIColor.veggieBookGreen
        
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.contentView.backgroundColor = UIColor.white
    }
}
