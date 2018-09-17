//
//  CreateAccountVC.swift
//  Smack
//
//  Created by Владислав Цветков on 02.07.2018.
//  Copyright © 2018 Владислав Цветков. All rights reserved.
//

import UIKit

class CreateAccountVC: UIViewController {

    // Outlets
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var userImage: UIImageView!
    
    // Variables
    var avararName = "profileDefault"
    var avararColor = "[0.5,0.5,0.5,1]"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if UserDataService.instance.avatarName != "" {
            userImage.image = UIImage(named: UserDataService.instance.avatarName)
            avararName = UserDataService.instance.avatarName
        }
    }

    @IBAction func createAccoutPressed(_ sender: Any) {
        guard let name = usernameTextField.text, usernameTextField.text != "" else { return }
        guard let email = emailTextField.text, emailTextField.text != "" else { return }
        guard let password = passwordTextField.text, passwordTextField.text != "" else { return }
        
        print(email)
        print(password)
        
        AuthService.instance.registerUser(email: email, password: password) { (success) in
            if success {
                AuthService.instance.loginUser(email: email, password: password, completion: { (success) in
                    if success {
                        AuthService.instance.createUser(name: name, email: email, avatarName: self.avararName, avatarColor: self.avararColor, completion: { (success) in
                            if success {
                                print(UserDataService.instance.name, UserDataService.instance.avatarName)
                                self.performSegue(withIdentifier: UNWIND, sender: nil)
                            }
                        })
                    }
                })
                
            }
        }
        
    }
    
    @IBAction func pickAvatarPressed(_ sender: Any) {
        performSegue(withIdentifier: TO_AVATAR_PICKER, sender: nil)
    }
    
    @IBAction func pickBGColorPressed(_ sender: Any) {
        
    }

    @IBAction func closePressed(_ sender: Any) {
        performSegue(withIdentifier: UNWIND, sender: nil)
    }
    
}
