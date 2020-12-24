//
//  ExtraCopyCollectionViewCell.swift
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
import DLRadioButton

class ExtraCopyCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var radioButton: DLRadioButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        label.backgroundColor = UIColor(rgb: UIColor.veggieBookGreenHex, a: 0.65)
        radioButton.iconSize = 30
        radioButton.iconSelected = #imageLiteral(resourceName: "btn_check_on_focused_holo_light1")
        radioButton.icon = #imageLiteral(resourceName: "btn_check_off_focused_holo_light1")
        radioButton.isMultipleSelectionEnabled = true
    }
}
