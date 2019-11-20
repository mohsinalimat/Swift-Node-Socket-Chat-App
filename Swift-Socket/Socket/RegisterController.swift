//
//  RegisterController.swift
//  Socket
//
//  Created by Matt on 2019/11/8.
//  Copyright © 2019 Matt. All rights reserved.
//

import UIKit

class RegisterController: UIViewController {
    
    lazy var stackview : UIStackView = {
        let stack = UIStackView(arrangedSubviews: [toUserMessage,titleSignUp,EmailAddress,Password,Name])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 42
        return stack
    }()
    
    let toUserMessage : ULabel = {
        let mes = ULabel()
        mes.textColor = UIColor.red
        return mes
    }()
    
    let titleSignUp : UILabel = {
       let lab = UILabel()
        lab.text = "Sign Up"
        lab.font = UIFont.boldSystemFont(ofSize: 32)
        return lab
    }()
    
    let EmailAddress : TextField = {
       let field = TextField()
        field.Title = "Email Address"
        field.borderStyle = .roundedRect
        field.keyboardType = .emailAddress
        return field
    }()
    
    let Password : TextField = {
       let field = TextField()
        field.Title = "Password"
        field.borderStyle = .roundedRect
        field.isSecureTextEntry = true
        return field
    }()
    
    let Name : TextField = {
       let field = TextField()
        field.Title = "Name"
        field.borderStyle = .roundedRect
        return field
    }()
    
    let Continue : UIButton = {
        let but = UIButton(type:.system)
        but.setTitle("Continue", for: .normal)
        but.backgroundColor = UIColor(red: 20/255, green: 167/255, blue: 82/255, alpha: 1)
        but.translatesAutoresizingMaskIntoConstraints = false
        but.setTitleColor(UIColor.white, for: .normal)
        but.titleEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
        but.layer.borderWidth = 0.2
        but.layer.borderColor = UIColor.black.cgColor
        but.layer.cornerRadius = 3
        but.layer.masksToBounds = true
        but.addTarget(self, action: #selector(createAccount), for: .touchUpInside)
        return but
    }()
    
    @objc func createAccount() {
        guard EmailAddress.text != "" else {
            toUserMessage.text = "請輸入Email"
            return
        }
        guard Password.text != "" else {
            toUserMessage.text = "請輸入密碼"
            return
        }
        guard Name.text != "" else {
            toUserMessage.text = "請輸入名稱"
            return
        }
        let data = ["email":EmailAddress.text!,"password":Password.text!,"name":Name.text!]
        Server.Account({ (res, error) in
            if error{
                DispatchQueue.main.async {
                    self.toUserMessage.text = res as? String
                }
            }else{
                DispatchQueue.main.async {
                    let toVc = LoginController()
                    toVc.modalPresentationStyle = .fullScreen
                    toVc.modalTransitionStyle = .crossDissolve
                    self.present(toVc, animated: false, completion: nil)
                }
            }
        }, parameters: data, url: .register)
    }
    
    let Login : UIButton = {
        let but = UIButton(type:.system)
        but.setTitle("Login", for: .normal)
        but.translatesAutoresizingMaskIntoConstraints = false
        but.addTarget(self, action: #selector(toLoginController), for: .touchUpInside)
        return but
    }()
    
    @objc func toLoginController() {
        let toVc = LoginController()
        toVc.modalPresentationStyle = .fullScreen
        toVc.modalTransitionStyle = .crossDissolve
        present(toVc, animated: false, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        view.addSubview(stackview)
        stackview.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -60).isActive = true
        stackview.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        stackview.widthAnchor.constraint(equalToConstant: 300).isActive = true
        view.addSubview(Continue)
        Continue.topAnchor.constraint(equalTo: stackview.bottomAnchor, constant: 22).isActive = true
        Continue.rightAnchor.constraint(equalTo: stackview.rightAnchor, constant: 0).isActive = true
        Continue.widthAnchor.constraint(equalToConstant: 80).isActive = true
        view.addSubview(Login)
        Login.topAnchor.constraint(equalTo: stackview.bottomAnchor, constant: 22).isActive = true
        Login.leftAnchor.constraint(equalTo: stackview.leftAnchor, constant: 0).isActive = true
    }
    
}


class TextField: UITextField {
    var Title : String? {
        didSet{
            if let title = Title {
                TitleLabel.text = title
            }
        }
    }
    
    let TitleLabel : UILabel = {
       let lab = UILabel()
        lab.font = UIFont.boldSystemFont(ofSize: 16)
        lab.translatesAutoresizingMaskIntoConstraints = false
        return lab
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        addSubview(TitleLabel)
        TitleLabel.bottomAnchor.constraint(equalTo: topAnchor, constant: -6).isActive = true
        TitleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
