//
//  ChatVC.swift
//  Smack
//
//  Created by Владислав Цветков on 01.07.2018.
//  Copyright © 2018 Владислав Цветков. All rights reserved.
//

import UIKit

class ChatVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    static var isSensetivityToKeyboard : Bool = true
    
    // Outlets
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var channelNameLbl: UILabel!
    @IBOutlet weak var messageTxtBoxTextField: TextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var typingUsersLbl: UILabel!
    @IBOutlet weak var typingUsersView: UIView!
    
    // Variables
    var isTyping = false
    var isKeyboardShow = false
    
    // Constraints
    @IBOutlet weak var messageTxtFldConstrBottom: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sendBtn.isEnabled = false
        
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.transform = CGAffineTransform(scaleX: 1, y: -1)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(ChatVC.handleTap))
        view.addGestureRecognizer(tap)
        menuBtn.addTarget(self.revealViewController(),
                          action: #selector(SWRevealViewController.revealToggle(_:)),
                          for: .touchUpInside)
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.userDataDidChange(_:)), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.channelSelected(_:)), name: NOTIF_CHANNEL_SELECTED, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        SocketService.instance.getChatMessage { (newMessage) in
            if newMessage.channelId == MessageService.instance.selectedChannel?.id && AuthService.instance.isLogedIn {
                MessageService.instance.messages.insert(newMessage, at: 0)
                self.tableView.reloadData()
                if MessageService.instance.messages.count > 0 {
                    let endIndex = IndexPath(row: 0, section: 0)
                    self.tableView.scrollToRow(at: endIndex, at: .top, animated: true)
                }
            }
        }
                
        SocketService.instance.getTypingUsers { (typingUsers) in
            guard let channelId = MessageService.instance.selectedChannel?.id else {return}
            var names = ""
            var numberOfTypes = 0
            
            for (typingUser, channel) in typingUsers {
                if typingUser != UserDataService.instance.name && channel == channelId {
                    if names == "" {
                        names = typingUser
                    } else {
                        names = "\(names), \(typingUser)"
                    }
                    numberOfTypes += 1
                }
            }
            if numberOfTypes > 0 && AuthService.instance.isLogedIn == true {
                var verb = "is"
                if numberOfTypes > 1 {
                    verb = "are"
                }
                self.typingUsersLbl.text = "\(names) \(verb) typing a message"
                self.typingUsersView.isHidden = false
            } else {
                self.typingUsersLbl.text = ""
                self.typingUsersView.isHidden = true
            }
        }
        
        if AuthService.instance.isLogedIn { // check for user login the app, and we try to find info in db and send the notification
            // it's need to show info in profile VC
            AuthService.instance.findUserByEmail { (success) in
                NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
            }
        }
    }
    
    // Keyboard
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue, ChatVC.isSensetivityToKeyboard {
            if !isKeyboardShow {
                let insets = UIEdgeInsets(top: keyboardSize.height , left: 0, bottom: 0, right: 0)
                tableView.contentInset = insets
                tableView.scrollIndicatorInsets = insets
                let endIndex = IndexPath(row: 0, section: 0)
                tableView.scrollToRow(at: endIndex, at: .top, animated: true)
                messageTxtFldConstrBottom.constant = keyboardSize.height + 4
                UIView.animate(withDuration: CATransaction.animationDuration()) {
                    self.view.layoutSubviews()
                }
                isKeyboardShow = !isKeyboardShow
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if let _ = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue, ChatVC.isSensetivityToKeyboard {
            if isKeyboardShow {
                let insets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                tableView.contentInset = insets
                tableView.scrollIndicatorInsets = insets
                messageTxtFldConstrBottom.constant = 4
                UIView.animate(withDuration: CATransaction.animationDuration()) {
                  self.view.layoutSubviews()
                }
                isKeyboardShow = !isKeyboardShow
            }
        }
    }
    // Keyboard end
    
    @objc func userDataDidChange(_ notif: Notification) {
        if AuthService.instance.isLogedIn {
            onLoginGetMessages()
        } else {
            channelNameLbl.text = "Please Log In"
            tableView.reloadData()
        }
    }
    
    @objc func channelSelected(_ notif: Notification) {
        updateWithChannel()
    }
    
    @objc func handleTap() {
        view.endEditing(true)
    }
    
    func updateWithChannel() {
        let channelName = MessageService.instance.selectedChannel?.channelTitle ?? ""
        channelNameLbl.text = "#\(channelName)"
        getMessages()
    }
    
    func onLoginGetMessages() {
        MessageService.instance.findAllChannel { (success) in
            if success {
                if MessageService.instance.channels.count > 0 {
                    MessageService.instance.selectedChannel = MessageService.instance.channels[0]
                    self.updateWithChannel()
                } else {
                    self.channelNameLbl.text = "No channels yet!"
                }
            }
        }
    }
    
    func getMessages() {
        guard let channelId = MessageService.instance.selectedChannel?.id else {return}
        MessageService.instance.findAllMessagesForChannel(channelId: channelId) { (success) in
            if success {
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func sendMessageBtnPressed(_ sender: Any) {
        if AuthService.instance.isLogedIn {
            guard let channelId = MessageService.instance.selectedChannel?.id else {return}
            guard let message = messageTxtBoxTextField.text else {return}
            
            SocketService.instance.addMessage(messageBody: message, userId: UserDataService.instance.id, channelId: channelId) { (success) in
                if success {
                    self.messageTxtBoxTextField.text = ""
                    self.messageTxtBoxTextField.resignFirstResponder()
                    SocketService.instance.socket.emit("stopType", UserDataService.instance.name, channelId)
                }
            }
        }
    }
    @IBAction func messageTextFieldEditing(_ sender: Any) {
        guard let channelId = MessageService.instance.selectedChannel?.id else {return}
        if messageTxtBoxTextField.text == "" {
            isTyping = false
            sendBtn.isEnabled = false
            SocketService.instance.socket.emit("stopType", UserDataService.instance.name, channelId)
        } else {
            if isTyping == false {
                isTyping = true
                sendBtn.isEnabled = true
                SocketService.instance.socket.emit("startType", UserDataService.instance.name, channelId)
            }
            isTyping = true
        }
    }
    
    // TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessageService.instance.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as? MessageCell {
           let message = MessageService.instance.messages[indexPath.row]
            cell.configureCell(message: message)
            cell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
            return cell
        } else {
            return UITableViewCell()
        }
    }

}
