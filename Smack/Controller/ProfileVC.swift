//
//  ProfileVC.swift
//  Smack
//
//  Created by Владислав Цветков on 20/09/2018.
//  Copyright © 2018 Владислав Цветков. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController {

    // Outlets
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var infoView: UIView!
    
    // Constraints
    @IBOutlet weak var centerConstaraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
           self?.centerConstaraint.constant = 0 //UIScreen.main.bounds.size.height / 2
            UIView.animate(withDuration: CATransaction.animationDuration()) {
                self?.view.layoutSubviews()
            }
        }
    }
    
    @IBAction func logoutBtnPressed(_ sender: Any) {
        UserDataService.instance.logoutUser()
        NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        closeView()
    }
    
    @IBAction func closeBtnModalPressed(_ sender: Any) {
        closeView()
    }
    
    @objc func closeView() {
        centerConstaraint.constant = UIScreen.main.bounds.height
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
    
    func setupView() {
        centerConstaraint.constant = UIScreen.main.bounds.height
        usernameLbl.text = UserDataService.instance.name
        emailLbl.text = UserDataService.instance.email
        profileImg.image = UIImage(named: UserDataService.instance.avatarName)
        profileImg.backgroundColor = UserDataService.instance.returnUIColor(components: UserDataService.instance.avatarColor)
        
        let closeTouch = UITapGestureRecognizer(target: self, action: #selector(ProfileVC.closeView))
        bgView.addGestureRecognizer(closeTouch)
    }
    
    @objc func closeTap(_ recognizer: UITapGestureRecognizer) {
        dismiss(animated: false, completion: nil)
    }
}
