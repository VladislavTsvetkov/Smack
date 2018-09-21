//
//  AddChannelVC.swift
//  Smack
//
//  Created by Владислав Цветков on 21/09/2018.
//  Copyright © 2018 Владислав Цветков. All rights reserved.
//

import UIKit

class AddChannelVC: UIViewController {

    // Outlets
    @IBOutlet weak var channelNameTextField: UITextField!
    @IBOutlet weak var channelDescTextField: UITextField!
    @IBOutlet weak var bgView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    @IBAction func createChannelBtnPressed(_ sender: Any) {
    
    }
    
    @IBAction func closeModalPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func setupView() {
        channelNameTextField.attributedPlaceholder = NSAttributedString(string: "channel's name", attributes: [NSAttributedStringKey.foregroundColor: smackPurplePlaceholder])
        channelDescTextField.attributedPlaceholder = NSAttributedString(string: "description", attributes: [NSAttributedStringKey.foregroundColor: smackPurplePlaceholder])
        
        let closeTouch = UITapGestureRecognizer(target: self, action: #selector(AddChannelVC.closeTap(_:)))
        bgView.addGestureRecognizer(closeTouch)
    }
    
    @objc func closeTap(_ recognizer: UIGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
}
