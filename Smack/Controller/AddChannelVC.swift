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
    @IBOutlet weak var bgView: UIVisualEffectView!
    @IBOutlet weak var createChannelView: UIView!
    
    // Constraints
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        channelNameTextField.delegate = self
        channelDescTextField.delegate = self
        
        topConstraint.constant = UIScreen.main.bounds.height
        ChatVC.isSensetivityToKeyboard = false
        setupView()
    }
    
    deinit {
        ChatVC.isSensetivityToKeyboard = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            self?.topConstraint.constant = 80
            UIView.animate(withDuration: CATransaction.animationDuration()) {
                self?.view.layoutSubviews()
            }
        }
    }
    
    @IBAction func createChannelBtnPressed(_ sender: Any) {
        guard let channelName = channelNameTextField.text, channelNameTextField.text != "" else {return}
        guard let channelDescription = channelDescTextField.text else {return}
        SocketService.instance.addChannel(channelName: channelName, channelDescription: channelDescription) { (success) in
            if success {
                self.closeView()
            }
        }
    }
    
    @IBAction func closeModalPressed(_ sender: Any) {
       closeView()
    }
    
    @objc func closeView() {
        view.endEditing(true)
        topConstraint.constant = UIScreen.main.bounds.height
        
        UIView.animate(withDuration: CATransaction.animationDuration(),
                       animations:
            { [weak self] in
                self?.view.layoutSubviews()
        }) { [weak self] (finish) in
            if finish {
                
                UIView.animate(withDuration: CATransaction.animationDuration(),
                               animations:
                    {
                        self?.bgView.alpha = 0
                },
                               completion:
                    { (finish) in
                        if finish {
                            self?.dismiss(animated: false, completion: nil)
                        }
                })
                
            }
        }
    }
    
    @objc func closeKeyboard() {
        view.endEditing(true)
    }
    
    func setupView() {
        channelNameTextField.attributedPlaceholder = NSAttributedString(string: "channel's name", attributes: [NSAttributedStringKey.foregroundColor: smackPurplePlaceholder])
        channelDescTextField.attributedPlaceholder = NSAttributedString(string: "description", attributes: [NSAttributedStringKey.foregroundColor: smackPurplePlaceholder])
        
        let closeTouch = UITapGestureRecognizer(target: self, action: #selector(AddChannelVC.closeView))
        bgView.addGestureRecognizer(closeTouch)
        let closeKeyboardTap = UITapGestureRecognizer(target: self, action: #selector(AddChannelVC.closeKeyboard))
        createChannelView.addGestureRecognizer(closeKeyboardTap)
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
