//
//  QuestionChoiceTableViewCell.swift
//  VeggieBook
//
//  Created by Daniel DiPasquo on 6/14/17.
//  Copyright © 2017 DiPasquo Consulting. All rights reserved.
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
