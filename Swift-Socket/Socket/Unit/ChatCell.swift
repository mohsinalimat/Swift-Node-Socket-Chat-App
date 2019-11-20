//
//  ChatCell.swift
//  Socket
//
//  Created by Matt on 2019/11/7.
//  Copyright © 2019 Matt. All rights reserved.
//

import UIKit

class ChatCell: UITableViewCell {
    
    var Chat : chat? {
        didSet{
            if let message = Chat?.message {
                messageText.text = message
            }
            if Chat?.toUid == adminData._id {
                messageText.backgroundColor = UIColor.darkGray
                messageText.textColor = UIColor.white
                messageAnchorToLeft?.isActive = true
                messageAnchorToRight?.isActive = false
                fromIcon.isHidden = false
            }else{
                messageText.backgroundColor = UIColor.white
                messageText.textColor = UIColor.black
                messageAnchorToLeft?.isActive = false
                messageAnchorToRight?.isActive = true
                fromIcon.isHidden = true
            }
        }
    }
    
    var messageAnchorToLeft : NSLayoutConstraint?
    var messageAnchorToRight : NSLayoutConstraint?
    
    let fromIcon : UIImageView = {
       let image = UIImageView()
        image.image = UIImage(named: "wolf")
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 32 / 2
        image.layer.masksToBounds = true
        return image
    }()
    
    let messageText : Label = {
       let text = Label()
        text.backgroundColor = UIColor.darkGray.withAlphaComponent(0.1)
        text.layer.cornerRadius = 6
        text.translatesAutoresizingMaskIntoConstraints = false
        text.layer.masksToBounds = true
        text.numberOfLines = 0
        text.adjustsFontSizeToFitWidth = true
        return text
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        addSubview(fromIcon)
        fromIcon.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        fromIcon.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        fromIcon.heightAnchor.constraint(equalToConstant: 32).isActive = true
        fromIcon.widthAnchor.constraint(equalToConstant: 32).isActive = true
        addSubview(messageText)
        
        messageAnchorToLeft = messageText.leftAnchor.constraint(equalTo: fromIcon.rightAnchor, constant: 8)
        messageAnchorToLeft?.isActive = true
        messageAnchorToRight = messageText.rightAnchor.constraint(equalTo: rightAnchor, constant: -12)
        messageAnchorToRight?.isActive = false
        
        messageText.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        messageText.widthAnchor.constraint(lessThanOrEqualToConstant: 200).isActive = true
        messageText.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

class Label: UILabel {
    let padding = UIEdgeInsets(top: 6, left: 8, bottom: 6, right: 8)
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }

    override var intrinsicContentSize : CGSize {
        let superContentSize = super.intrinsicContentSize
        let width = superContentSize.width + padding.left + padding.right
        let heigth = superContentSize.height + padding.top + padding.bottom
        return CGSize(width: width, height: heigth )
    }
}
