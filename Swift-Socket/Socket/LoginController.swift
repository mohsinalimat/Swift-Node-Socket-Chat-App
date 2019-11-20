//
//  LoginController.swift
//  Socket
//
//  Created by Matt on 2019/11/8.
//  Copyright © 2019 Matt. All rights reserved.
//

import UIKit

class LoginController: UIViewController {
    
    lazy var stackview : UIStackView = {
        let stack = UIStackView(arrangedSubviews: [toUserMessage,titleLogin,UsernameField,PasswordField])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 18
       return stack
    }()
    
    let toUserMessage : ULabel = {
        let mes = ULabel()
        mes.textColor = UIColor.red
        return mes
    }()
    
    let titleLogin : UILabel = {
       let lab = UILabel()
        lab.text = "Login"
        lab.font = UIFont.boldSystemFont(ofSize: 32)
        return lab
    }()
    
    let UsernameField : UITextField = {
       let field = UITextField()
        field.placeholder = "Email"
        field.borderStyle = .roundedRect
        field.keyboardType = .emailAddress
        return field
    }()
    
    let PasswordField : UITextField = {
       let field = UITextField()
        field.placeholder = "Password"
        field.borderStyle = .roundedRect
        field.isSecureTextEntry = true
        return field
    }()
    
    let Login : UIButton = {
        let but = UIButton(type:.system)
        but.setTitle("Login", for: .normal)
        but.backgroundColor = UIColor(red: 20/255, green: 167/255, blue: 82/255, alpha: 1)
        but.translatesAutoresizingMaskIntoConstraints = false
        but.setTitleColor(UIColor.white, for: .normal)
        but.titleEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
        but.layer.cornerRadius = 3
        but.layer.masksToBounds = true
        but.layer.borderWidth = 0.2
        but.layer.borderColor = UIColor.black.cgColor
        but.addTarget(self, action: #selector(login), for: .touchUpInside)
        return but
    }()
    
    @objc func login() {
        guard UsernameField.text != "" else {
            toUserMessage.text = "請輸入Email"
            return
        }
        guard PasswordField.text != "" else {
            toUserMessage.text = "請輸入密碼"
            return
        }
        let data = ["email":UsernameField.text!,"password":PasswordField.text!]
        Server.Account({ (res, error) in
            if error{
                DispatchQueue.main.async {
                    self.toUserMessage.text = res as? String
                }
            }else{
                DispatchQueue.main.async {
                    if let admin = res as? [String] {
                        adminData._id = admin[0]
                        adminData.name = admin[1]
                    }
                    let toVc = UINavigationController(rootViewController: TableMesssageController())
                    toVc.modalPresentationStyle = .fullScreen
                    toVc.modalTransitionStyle = .crossDissolve
                    self.present(toVc, animated: false, completion: nil)
                }
            }
        }, parameters: data, url: .login)
    }
    
    let Register : UIButton = {
        let but = UIButton(type:.system)
        but.setTitle("Register for a new account", for: .normal)
        but.translatesAutoresizingMaskIntoConstraints = false
        but.addTarget(self, action: #selector(toRegisterController), for: .touchUpInside)
        return but
    }()
    
    @objc func toRegisterController() {
        let toVc = RegisterController()
        toVc.modalPresentationStyle = .fullScreen
        toVc.modalTransitionStyle = .crossDissolve
        present(toVc, animated: false, completion: nil)
    }
    
    let ForgotPassword : UIButton = {
        let but = UIButton(type: .system)
        but.setTitle("Forgot password?", for: .normal)
        but.contentHorizontalAlignment = .right
        but.translatesAutoresizingMaskIntoConstraints = false
        return but
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        view.addSubview(stackview)
        stackview.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        stackview.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100).isActive = true
        stackview.widthAnchor.constraint(equalToConstant: 300).isActive = true
        view.addSubview(ForgotPassword)
        ForgotPassword.rightAnchor.constraint(equalTo: stackview.rightAnchor, constant: 0).isActive = true
        ForgotPassword.topAnchor.constraint(equalTo: stackview.bottomAnchor, constant: 18).isActive = true
        view.addSubview(Login)
        Login.topAnchor.constraint(equalTo: ForgotPassword.bottomAnchor, constant: 22).isActive = true
        Login.leftAnchor.constraint(equalTo: stackview.leftAnchor, constant: 0).isActive = true
        Login.widthAnchor.constraint(equalToConstant: 60).isActive = true
        view.addSubview(Register)
        Register.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        Register.topAnchor.constraint(equalTo: Login.bottomAnchor, constant: 32).isActive = true
    }
    
}
