//
//  QuestionChoiceTableViewController.swift
//  VeggieBook
//
//  Created by Daniel DiPasquo on 6/14/17.
//  Copyright © 2017 DiPasquo Consulting. All rights reserved.
//

import UIKit

class QuestionChoiceTableViewController: UITableViewController {

    var question : Question? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.titleView = UIImageView(image: Logo.getNegativeLogo())

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (question?.choices.count)!
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let headerView = view as! UITableViewHeaderFooterView
        headerView.tintColor = UIColor.white
        headerView.textLabel?.textColor = UIColor(rgb: 0x00BC16)
        headerView.textLabel?.font = headerView.textLabel?.font.withSize(14).italic()
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return LanguageCode.appLanguage.isSpanish() ? "MARQUE/ESCOJA TODO LO QUE APLIQUE" : "CHECK ALL THAT APPLY"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "QuestionChoiceTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? QuestionChoiceTableViewCell  else {
            fatalError("The dequeued cell is not an instance of QuestionChoiceTableViewCell.")
        }
        let choice = (question?.choices[indexPath.row])!
        cell.setChoice(choice: choice)

        return cell
    }

}
