//
//  chat.swift
//  Socket
//
//  Created by Matt on 2019/11/7.
//  Copyright © 2019 Matt. All rights reserved.
//

import Foundation

struct chat : Decodable {
    var fromName : String
    var fromUid : String
    var toUid : String
    var message : String
    var time : String
    var username : String
    
    init(Dic: [String : Any]) {
        self.fromName = Dic["fromName"] as! String
        self.fromUid = Dic["fromUid"] as! String
        self.toUid = Dic["toUid"] as! String
        self.message = Dic["message"] as! String
        self.time = Dic["time"] as! String
        self.username = Dic["username"] as! String
    }
}


struct ChatMessage : Decodable {
    var UserID : String
    var _id : String
    var allMessage : [chat]
    
    
}

