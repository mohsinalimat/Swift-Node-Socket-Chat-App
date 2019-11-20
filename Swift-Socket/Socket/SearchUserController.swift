//
//  File.swift
//  Socket
//
//  Created by Matt on 2019/11/11.
//  Copyright © 2019 Matt. All rights reserved.
//

import UIKit
import SocketIO

class SearchUserController: UIViewController {
    
    let manager = SocketManager(socketURL: URL(string: "https://mantalktalk.herokuapp.com")!, config: [ .compress])
    lazy var socket = manager.defaultSocket
    var tablemessagecontroller : TableMesssageController?
    var User = user()
    
    lazy var stackview : UIStackView = {
        let stack = UIStackView(arrangedSubviews: [Icon,name,Join])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 12
        return stack
    }()
    
    lazy var seacherBar : UISearchController = {
       let search = UISearchController()
        search.searchBar.placeholder = "搜尋..."
        search.searchResultsUpdater = self
        search.searchBar.delegate = self
        search.searchBar.setValue("取消", forKey: "cancelButtonText")
        return search
    }()
    
    let Icon : UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 80 / 2
        image.layer.masksToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "user")
        image.isHidden = true
        return image
    }()
    
    let name : UILabel = {
       let lab = UILabel()
        lab.font = UIFont.boldSystemFont(ofSize: 18)
        lab.textAlignment = .center
        lab.text = "輸入 Email 搜尋猛漢"
        lab.textColor = UIColor.black
        return lab
    }()
    
    let Join : UIButton = {
        let but = UIButton(type: .system)
        but.setTitle("加入", for: .normal)
        but.backgroundColor = UIColor(red: 20/255, green: 167/255, blue: 82/255, alpha: 1)
        but.translatesAutoresizingMaskIntoConstraints = false
        but.setTitleColor(UIColor.white, for: .normal)
        but.titleEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
        but.layer.cornerRadius = 3
        but.layer.masksToBounds = true
        but.layer.borderWidth = 0.2
        but.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        but.layer.borderColor = UIColor.black.cgColor
        but.translatesAutoresizingMaskIntoConstraints = false
        but.addTarget(self, action: #selector(join), for: .touchUpInside)
        but.isHidden = true
        return but
    }()
    
    @objc func join() {
        let json = ["fromName":adminData.name!,"fromUid":adminData._id!,"toUid":User._id!,"message":"Hello~~","username":User.name!,"time":dateString(Date())] as [String : Any]
        socket.emit("new_msg", json) {
            self.navigationController?.popViewController(animated: true)
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.3) {
                self.tablemessagecontroller?.featchServer()
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        navigationItem.title = "搜尋猛漢"
        if #available(iOS 11.0, *) {
            navigationItem.searchController = seacherBar
            navigationItem.hidesSearchBarWhenScrolling = false
        } else {
            // Fallback on earlier versions
        }
        
        Icon.heightAnchor.constraint(equalToConstant: 80).isActive = true
        Icon.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        Join.widthAnchor.constraint(equalToConstant: 100).isActive = true
        Join.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        view.addSubview(stackview)
        stackview.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
        stackview.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        connectSocket()
    }
    func connectSocket() {
        socket.connect()
    }
}


extension SearchUserController : UISearchResultsUpdating,UISearchBarDelegate{
    func updateSearchResults(for searchController: UISearchController) {
        //print(searchController.searchBar.text)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        Server.Account({ (res, error) in
            if error {
                DispatchQueue.main.async {
                    self.name.text = (res as! String)
                    self.Icon.isHidden = true
                    self.Join.isHidden = true
                }
            }else{
                DispatchQueue.main.async {
                    if let user = res as? [String] {
                        self.name.text = user[1]
                        self.User._id = user[0]
                        self.User.name = user[1]
                        self.Icon.isHidden = false
                        self.Join.isHidden = false
                    }
                }
            }
        }, parameters: ["email" : searchBar.text!], url: .search)
        dismiss(animated: true, completion: nil)
    }
    
}
