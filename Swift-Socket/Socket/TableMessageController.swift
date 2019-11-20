//
//  TableMessageController.swift
//  Socket
//
//  Created by Matt on 2019/11/11.
//  Copyright © 2019 Matt. All rights reserved.
//

import UIKit
import SocketIO

class TableMesssageController: UITableViewController {
    
    let tableCell = "TableCell"
    var groupUsers = [[chat]]()
    let manager = SocketManager(socketURL: URL(string: "https://mantalktalk.herokuapp.com")!, config: [ .compress])
    lazy var socket = manager.defaultSocket
    
    lazy var noUserView : UIView = {
        let vi = UIView(frame: view.frame)
        vi.backgroundColor = UIColor.white
        let label = UILabel()
        label.text = "還沒有跟猛漢聊過天的記錄！！"
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        vi.addSubview(label)
        label.centerXAnchor.constraint(equalTo: vi.centerXAnchor, constant: 0).isActive = true
        label.centerYAnchor.constraint(equalTo: vi.centerYAnchor, constant: 0).isActive = true
        return vi
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        tableView.backgroundView = noUserView
        navigationItem.title = "猛漢聊聊"
        let rightBut = UIBarButtonItem(image: UIImage(named: "add"), style: .plain, target: self, action: #selector(navigationRightButton))
        navigationItem.rightBarButtonItem = rightBut
        tableView.register(TableMessageCell.self, forCellReuseIdentifier: tableCell)
        featchServer()
        connectSocket()
    }
    func featchServer() {
        groupUsers = [[chat]]()
        tableView.reloadData()
        Server.Account({ (res, error) in
                 if error{
                     return
                 }
                 
                 let data = res as? ChatMessage
                 
                 let grouped = Dictionary(grouping: data!.allMessage) { (element) -> String in
                     if element.fromUid == adminData._id {
                         return element.toUid
                     }else {
                         return element.fromUid
                     }
                     
                 }
                 let sortedKeys = grouped.keys.sorted(by:<)
        
                 sortedKeys.forEach{ (key) in
                   let values = grouped[key]
                     self.groupUsers.append(values ?? [])
                 }
                 DispatchQueue.main.async {
                    if self.groupUsers.count == 0 {
                        self.noUserView.isHidden = false
                    }else{
                        self.noUserView.isHidden = true
                    }
                     self.tableView.reloadData()
                 }
             }, parameters: ["uid":adminData._id!], url: .getMessageGroup)
    }
    
    func connectSocket() {
        socket.connect()

        if let id = adminData._id {
            socket.on(id) {data, ack in
                self.featchServer()
            }
        }
    }
    
    @objc func navigationRightButton() {
        let toVc = SearchUserController()
        toVc.modalPresentationStyle = .fullScreen
        toVc.modalTransitionStyle = .crossDissolve
        toVc.tablemessagecontroller = self
        
        navigationController?.pushViewController(toVc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupUsers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableCell, for: indexPath) as! TableMessageCell
        cell.chat = groupUsers[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let toVc = ChatViewController()
        toVc.chatlist = groupUsers[indexPath.row]
        toVc.tableMessageController = self
        navigationController?.pushViewController(toVc, animated: true)
    }
}
