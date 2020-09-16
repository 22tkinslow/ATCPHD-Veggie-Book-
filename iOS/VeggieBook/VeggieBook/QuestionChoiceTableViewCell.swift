//
//  QuestionChoiceTableViewCell.swift
//  VeggieBook
//
//  Created by Daniel DiPasquo on 6/14/17.
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
import DLRadioButton

class QuestionChoiceTableViewCell: UITableViewCell {

    
    @IBOutlet weak var radioButton: DLRadioButton!
    
    var choice : Choice? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        radioButton.iconSize = 25
        radioButton.icon = #imageLiteral(resourceName: "btn_check_off_holo_light1")
        radioButton.iconSelected = #imageLiteral(resourceName: "btn_check_on_holo_light1")
        radioButton.isIconSquare = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setChoice(choice: Choice){
        radioButton.setTitle(choice.content, for: UIControlState())
        if choice.response == nil {
            choice.response = choice.defaultChoice
        }
        self.choice = choice
        radioButton.isSelected = choice.response!
        radioButton.isMultipleSelectionEnabled = true
    }
    
    @IBAction func toggleButton(_ radioButton: DLRadioButton) {
        choice!.response = radioButton.isSelected
        
    }
    
}
