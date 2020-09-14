//
//  RecipeOrSecrectsCollectionViewCell.swift
//  VeggieBook
//
//  Created by Matt Flickner on 7/25/17.
//  Copyright © 2017 Technical Empowerment Inc All rights reserved.
//

import UIKit

class RecipeOrSecrectsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var coverPhoto: UIImageView!
    var contentUrl = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        label.backgroundColor = UIColor(rgb: UIColor.veggieBookGreenHex, a: 0.6)
    }
}
