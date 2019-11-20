//
//  CRUD.swift
//  CRUD
//
//  Created by Matt on 2019/11/1.
//  Copyright © 2019 Matt. All rights reserved.
//

import Foundation

enum urlType {
    case register
    case login
    case search
    case getMessageGroup
}

struct Server {

    static func Account(_ com : @escaping(_ response: Any, _ error : Bool) -> (),parameters: [String:String],url:urlType) {
        
        let Url = NSURL(string: "https://mantalktalk.herokuapp.com/\(url)")
        
        var request = URLRequest(url: Url! as URL)
 
        request.httpMethod = "POST"

        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions.prettyPrinted) else {
            return
        }

        request.httpBody = httpBody
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            //connect
            if error != nil{
                com("error timer", true)
                return
            }
            //isOK
            if let httpResponse = response as? HTTPURLResponse {
                let responseString = String(data: data!, encoding: .utf8)
                if httpResponse.statusCode  == 404 {
                    com(responseString!,true)
                }else{
                    let responseData = try? JSONSerialization.jsonObject(with: data!)
                    switch url {
                    case .getMessageGroup:
                        do{
                            let json = try JSONDecoder().decode(ChatMessage.self , from:data!)
                            com(json,false)
                        }catch{
                            print("error")
                        }
                    case .login:
                        com(responseData!,false)
                    case .register:
                        com(responseString!,false)
                    case .search:
                        com(responseData!,false)
                    }
                }
            }
        }.resume()
    }
//
//    static func Delete(_ com : @escaping(_ error : Bool) -> (),id: String) {
//
//        let url = NSURL(string: "https://mongodbtest4.herokuapp.com/\(id)")
//
//        var request = URLRequest(url: url! as URL)
//
//        request.httpMethod = "DELETE"
//
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.addValue("application/json", forHTTPHeaderField: "Accept")
//
//        let session = URLSession.shared
//        session.dataTask(with: request) { (data, response, error) in
//            if error != nil{
//                com(true)
//                return
//            }
//            com(false)
//        }.resume()
//    }
}
