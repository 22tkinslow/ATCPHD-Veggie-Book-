//
//  ExtraCopyCollectionViewCell.swift
//  VeggieBook
//
//  Created by Matt Flickner on 7/25/17.
//  Copyright © 2017 Technical Empowerment Inc All rights reserved.
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
