//
//  AddChannelVC.swift
//  Smack
//
//  Created by Владислав Цветков on 21/09/2018.
//  Copyright © 2018 Владислав Цветков. All rights reserved.
//

import UIKit

class AddChannelVC: UIViewController, UITextFieldDelegate {

    // Outlets
    @IBOutlet weak var channelNameTextField: UITextField!
    @IBOutlet weak var channelDescTextField: UITextField!
    @IBOutlet weak var bgView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        channelNameTextField.delegate = self
        channelDescTextField.delegate = self
        
        setupView()
    }
    
    @IBAction func createChannelBtnPressed(_ sender: Any) {
        guard let channelName = channelNameTextField.text, channelNameTextField.text != "" else {return}
        guard let channelDescription = channelDescTextField.text else {return}
        SocketService.instance.addChannel(channelName: channelName, channelDescription: channelDescription) { (success) in
            if success {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func closeModalPressed(_ sender: Any) {
        view.endEditing(true)
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == channelNameTextField {
            channelDescTextField.becomeFirstResponder()
        } else {
            channelDescTextField.resignFirstResponder()
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool { // return NO to not change text
        
        let nsString = NSString(string: textField.text!)
        let newText = nsString.replacingCharacters(in: range, with: string)
        return  newText.count <= 32
    }
    
}
