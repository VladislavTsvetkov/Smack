//
//  RightViewController.swift
//  Smack
//
//  Created by Владислав Цветков on 13/09/2018.
//  Copyright © 2018 Владислав Цветков. All rights reserved.
//

import UIKit

class RightViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.revealViewController().rightViewRevealWidth = self.view.frame.width - 60
        
    }
}
