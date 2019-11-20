//
//  ChatViewController.swift
//  Socket
//
//  Created by Matt on 2019/11/7.
//  Copyright © 2019 Matt. All rights reserved.
//

import UIKit
import SocketIO

class ChatViewController : UIViewController {
    
    var tableMessageController : TableMesssageController?
    let msgCellid = "msgCellid"
    let manager = SocketManager(socketURL: URL(string: "https://mantalktalk.herokuapp.com")!, config: [ .compress])
    lazy var socket = manager.defaultSocket
    var chatlist = [chat]()
    var User = user()
    
    lazy var msgTableView : UITableView = {
        let tb = UITableView()
        tb.delegate = self
        tb.dataSource = self
        tb.translatesAutoresizingMaskIntoConstraints = false
        tb.backgroundColor = UIColor(white: 0.95, alpha: 1)
        tb.separatorStyle = .none
        return tb
    }()
    
    let enterFieldText : UITextField = {
       let text = UITextField()
        text.placeholder = "輸入內容..."
        text.borderStyle = .roundedRect
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    let send : UIButton = {
        let but = UIButton(type:.system)
        but.setTitle("發送", for: .normal)
        but.translatesAutoresizingMaskIntoConstraints = false
        but.addTarget(self, action: #selector(Send), for: .touchUpInside)
        return but
    }()
    
    @objc func Send() {
        guard enterFieldText.text != "" else {
            return
        }
        
        let json = ["fromName":adminData.name!,"fromUid":adminData._id!,"toUid":User._id!,"message":enterFieldText.text!,"username":User.name!,"time":dateString(Date())] as [String : Any]
        socket.emit("new_msg", json) {
            self.chatlist.append(chat.init(Dic: json))
            self.reloadMessage()
            self.enterFieldText.text = ""
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        msgTableView.register(ChatCell.self, forCellReuseIdentifier: msgCellid)
        view.backgroundColor = UIColor(white: 0.95, alpha: 1)
        view.addSubview(enterFieldText)
        enterFieldText.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        enterFieldText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12).isActive = true
        //enterFieldText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12).isActive = true
        enterFieldText.heightAnchor.constraint(equalToConstant: 50).isActive = true
        view.addSubview(send)
        send.centerYAnchor.constraint(equalTo: enterFieldText.centerYAnchor, constant: 0).isActive = true
        send.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12).isActive = true
        send.leftAnchor.constraint(equalTo: enterFieldText.rightAnchor, constant: 0).isActive = true
        send.widthAnchor.constraint(equalToConstant: 60).isActive = true
        view.addSubview(msgTableView)
        msgTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        msgTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        msgTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        msgTableView.bottomAnchor.constraint(equalTo: enterFieldText.topAnchor, constant: -10).isActive = true
        connectSocket()
        
        
            if chatlist.first?.fromUid == adminData._id{
                User._id = chatlist.first?.toUid
                User.name = chatlist.first?.username
            }else{
                User._id = chatlist.first?.fromUid
                User.name = chatlist.first?.fromName
            }
        
        navigationItem.title = User.name
        
        reloadMessage()
    }
    
    func connectSocket() {
        socket.connect()
        
        if let id = adminData._id {
            socket.on(id) {data, ack in
                if let dic = data[0] as? [String:Any]{
                    self.chatlist.append(chat.init(Dic: dic))
                    self.reloadMessage()
                }
            }
        }
    }
    
    func dateString(_ date:Date, dateFormat:String = "yyyy-MM-dd HH:mm:ss") -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.init(identifier: "zh_CN")
        formatter.dateFormat = dateFormat
        let date = formatter.string(from: date)
        return date
    }
    
    func reloadMessage() {
        msgTableView.reloadData()
        guard chatlist.count > 0 else {
            return
        }
  
        DispatchQueue.main.async{
            self.msgTableView.scrollToRow(at: IndexPath(row: self.chatlist.count - 1, section: 0), at: .bottom, animated: false)
        }

        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        tableMessageController?.featchServer()
    }
}

extension ChatViewController : UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatlist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = msgTableView.dequeueReusableCell(withIdentifier: msgCellid, for: indexPath) as! ChatCell
        cell.Chat = chatlist[indexPath.row]
        return cell
    }
}
