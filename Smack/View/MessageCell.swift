//
//  MessageCell.swift
//  Smack
//
//  Created by Владислав Цветков on 24/09/2018.
//  Copyright © 2018 Владислав Цветков. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

    // Outlets
    @IBOutlet weak var usernameImg: CircleImage!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var timeStampLbl: UILabel!
    @IBOutlet weak var messageBodyLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(message: Message) {
        messageBodyLbl.text = message.message
        usernameLbl.text = message.userName
        usernameImg.image = UIImage(named: message.userAvatar)
        usernameImg.backgroundColor = UserDataService.instance.returnUIColor(components: message.userAvatarColor)
//        timeStampLbl.text = message.timeStamp
    }

}
