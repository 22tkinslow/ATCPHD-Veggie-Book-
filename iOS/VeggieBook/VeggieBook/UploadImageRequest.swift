//
//  UploadImageRequest.swift
//  VeggieBook
//
//  Created by Matt Flickner on 7/10/17.
//  Copyright © 2017 Technical Empowerment Inc. All rights reserved.
//

import Foundation

class UploadImageRequest {
    var data : Data
    
    init(image : UIImage){
        data =  UIImageJPEGRepresentation(image, 0.7)!
    }
}
