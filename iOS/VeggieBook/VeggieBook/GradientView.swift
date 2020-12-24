//
//  GradientView.swift
//  VeggieBook
//
//  Created by Matthew Flickner on 9/8/17.
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

class GradientView: UIView {
    
    var gradient = CAGradientLayer()
    
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildGradient(frame: self.bounds)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        buildGradient(frame: self.bounds)
    }
    
    private func buildGradient(frame: CGRect){
        self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = frame
        gradientLayer.colors = [UIColor.darkGray.withAlphaComponent(0.0).cgColor, UIColor.black.cgColor]
        self.gradient = gradientLayer
        self.layer.insertSublayer(self.gradient, at: 0)
    }
}
