//
//  VeggieBookTableViewCell.swift
//  VeggieBook
//
//  Created by Daniel DiPasquo on 1/11/17.
//  Copyright © 2017 DiPasquo Consulting. All rights reserved.
//

import UIKit

class VeggieBookTableViewCell: UITableViewCell {
    @IBOutlet weak var coverPhoto: UIImageView!
    @IBOutlet weak var gradientView: GradientView!
    @IBOutlet weak var bookLabel: UILabel!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var chosenPhoto: UIImageView!
    
    var createdBook : CreatedBook? = nil

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        chosenPhoto.layer.borderColor = UIColor.lightGray.cgColor
//        chosenPhoto.layer.borderWidth = 1
        self.applyPhotoShadow()
        self.gradientView.layoutSubviews()
    }

    func applyPhotoShadow(){
//        shadowView.layer.borderColor = UIColor.lightGray.cgColor
//        shadowView.layer.borderWidth = 1
        shadowView.layer.masksToBounds = false
        shadowView.layer.shadowColor = UIColor.lightGray.cgColor
        shadowView.layer.shadowOpacity = 1
        shadowView.layer.shadowOffset = CGSize(width: -1, height: 1)
        shadowView.layer.shadowRadius = 5
        shadowView.layer.shadowPath = UIBezierPath(rect: shadowView.bounds).cgPath
        shadowView.layer.shouldRasterize = true
        shadowView.layer.rasterizationScale = UIScreen.main.scale
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
