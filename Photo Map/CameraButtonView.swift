//
//  CameraButtonView.swift
//  Photo Map
//
//  Created by Nick McDonald on 4/18/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

class CameraButtonView: UIView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = self.frame.width/2
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 2.0
        self.clipsToBounds = true
    }

}
