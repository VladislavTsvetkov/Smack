//
//  CreateAccountVC.swift
//  Smack
//
//  Created by Владислав Цветков on 02.07.2018.
//  Copyright © 2018 Владислав Цветков. All rights reserved.
//

import UIKit

class CreateAccountVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func closePressed(_ sender: Any) {
        performSegue(withIdentifier: UNWIND, sender: nil)
    }
    
}
