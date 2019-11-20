//
//  TableMessageCell.swift
//  Socket
//
//  Created by Matt on 2019/11/12.
//  Copyright © 2019 Matt. All rights reserved.
//

import UIKit


class TableMessageCell: UITableViewCell {
    
    var chat : [chat]? {
        didSet{
            if chat?.last?.fromUid == adminData._id {
                name.text = chat?.last?.username
            }else{
                name.text = chat?.last?.fromName
            }
            subText.text = chat?.last?.message
            timer.text = chat?.last?.time
        }
    }
    
    let Icon : UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 60 / 2
        image.layer.masksToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "user")
        return image
    }()
    
    let name : UILabel = {
       let lab = UILabel()
        lab.textColor = UIColor.black
        lab.translatesAutoresizingMaskIntoConstraints = false
        return lab
    }()
    
    let subText : UILabel = {
       let lab = UILabel()
        lab.textColor = UIColor.black.withAlphaComponent(0.3)
        lab.translatesAutoresizingMaskIntoConstraints = false
        return lab
    }()
    
    let timer : UILabel = {
       let lab = UILabel()
        lab.textColor = UIColor.black.withAlphaComponent(0.3)
        lab.font = UIFont.boldSystemFont(ofSize: 10)
        lab.translatesAutoresizingMaskIntoConstraints = false
        return lab
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(Icon)
        Icon.widthAnchor.constraint(equalToConstant: 60).isActive = true
        Icon.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
        Icon.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        Icon.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
        
        addSubview(name)
        name.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        name.leftAnchor.constraint(equalTo: Icon.rightAnchor, constant: 12).isActive = true
        
        addSubview(subText)
        subText.leftAnchor.constraint(equalTo: Icon.rightAnchor, constant: 12).isActive = true
        subText.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
        
        addSubview(timer)
        timer.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true
        timer.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
