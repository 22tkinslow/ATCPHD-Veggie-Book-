//
//  GradientView.swift
//  VeggieBook
//
//  Created by Matthew Flickner on 9/8/17.
//  Copyright © 2017 Technical Empowerment, Inc. All rights reserved.
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
