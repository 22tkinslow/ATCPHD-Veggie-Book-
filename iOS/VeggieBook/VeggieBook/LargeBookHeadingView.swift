//
//  LargeBookHeadingView.swift
//  VeggieBook
//
//  Created by Daniel DiPasquo on 1/17/17.
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

@IBDesignable class LargeBookHeadingView: UIImageView {
    
    let myGradientLayer: CAGradientLayer
    private var titleLabel:UILabel
    
    var title : String? {
        get {
            return titleLabel.text
        }
        set(newText){
            titleLabel.text = newText
        }
    }
    
    override init(frame: CGRect)
    {
        myGradientLayer = CAGradientLayer()
        titleLabel = UILabel()
        super.init(frame: frame)
        self.setup()
    }
    
    required init(coder aDecoder: NSCoder)
    {
        myGradientLayer = CAGradientLayer()
        titleLabel = UILabel()
        super.init(coder: aDecoder)!
        self.setup()
    }
    
    func setup()
    {
        // Add Label at bottom of the
        titleLabel.textColor = UIColor.white
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.font = UIFont.systemFont(ofSize: 28)
        self.addSubview(titleLabel)
        
        // Add Gradient
        let colors: [CGColor] = [
            UIColor.clear.cgColor,
            UIColor(red: 0, green: 0, blue: 0, alpha: 0.3).cgColor,
            UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor,
        ]
        myGradientLayer.colors = colors
        myGradientLayer.isOpaque = false
        myGradientLayer.locations = [0, 0.6, 1.0]
        self.layer.insertSublayer(myGradientLayer, below: titleLabel.layer)
        
    }
    
    override func layoutSubviews()
    {
        myGradientLayer.frame = self.layer.bounds
        titleLabel.frame = CGRect(x: CGFloat(10), y: self.bounds.size.height - CGFloat(45), width: self.bounds.width - CGFloat(20), height: CGFloat(35.0))
    }
}
