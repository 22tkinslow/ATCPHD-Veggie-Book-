//
//  CreateBookTableViewCell.swift
//  VeggieBook
//
//  Created by Daniel DiPasquo on 1/11/17.
//  Copyright © 2017 DiPasquo Consulting. All rights reserved.
//

import UIKit

class CreateBookTableViewCell: UITableViewCell {

    @IBOutlet weak var bookLabel: UILabel!
    @IBOutlet weak var bookImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
