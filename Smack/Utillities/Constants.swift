//
//  Constants.swift
//  Smack
//
//  Created by Владислав Цветков on 01.07.2018.
//  Copyright © 2018 Владислав Цветков. All rights reserved.
//

import Foundation

typealias CompletionHandler = (_ Success: Bool) -> ()

// URL Constants

let BASE_URL = "https://smack-application.herokuapp.com/"
let URL_REGISTER = "\(BASE_URL)account/register"


// Segues
let TO_LOGIN = "toLogin"
let TO_CREATE_ACCOUNT = "toCreateAccount"
let UNWIND = "unwindToChannel"

// UserDefaults
let TOKEN_KEY = "token"
let LOGGED_IN_KEY = "loggedIn"
let USER_EMAIL = "userEmail"
