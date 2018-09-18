//
//  CircleImage.swift
//  Smack
//
//  Created by Владислав Цветков on 18/09/2018.
//  Copyright © 2018 Владислав Цветков. All rights reserved.
//

import UIKit

@IBDesignable
class CircleImage: UIImageView {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupView()
    }

    
    func setupView() {
        self.layer.cornerRadius = self.frame.width / 2
        self.clipsToBounds = true
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupView()
    }
}
