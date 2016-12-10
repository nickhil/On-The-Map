//
//  UdacityAPI.swift
//  On The Map
//
//  Created by Nikhil on 08/12/16.
//  Copyright © 2016 Nikhil. All rights reserved.
//

import Foundation

class Login{

            static let sharedInstance = Login()
            var name = ""
            var lastName = ""
            var firstName = ""
            var key = ""
    
    //Login Function- Authenticating user request for Udacity API
       func loginWithUdacity(username: String, password: String, completionHandler: @escaping(_ sucess:Bool,_ errorString:String?)-> Void) {
        
        // GETing Session ID
        let request = NSMutableURLRequest(url:NSURL(string: "https://www.udacity.com/api/session")! as URL)
        
        // POSTing session
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: String.Encoding.utf8)
        
        let session = URLSession.shared
        
        // setting task
        let task = session.dataTask(with: request as URLRequest) { (data,response,error) in
            if error != nil {
                completionHandler(false, error!.localizedDescription)
                return
                }
            //Skipping first 5 Udacity security characters
            let newData = data!.subdata(in: 5..<(data!.count))
            let parseResult = (try! JSONSerialization.jsonObject(with: newData, options: .allowFragments)) as! NSDictionary
            
            //GETing key
            if let key = (parseResult["account"] as? [String:Any])? ["key"] as? String {
                self.key = key
                completionHandler(true,nil)
            }
            else {
                    completionHandler(false, "Username or Password entered is wrong.")
             }
        }
        //Starting the task
         task.resume()
    }

    //GETing public user data
    func setName(completionHandler: @escaping(_ sucess: Bool, _ errorString: String?)-> Void) {
        let request = NSMutableURLRequest(url:NSURL(string:"https://www.udacity.com/api/users/\(self.key)")! as URL)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { (data,response,error) in
            if error != nil {
                completionHandler(false, error!.localizedDescription)
                return
                }
            let newData = data!.subdata(in: 5..<(data!.count))
            let parseResult = (try! JSONSerialization.jsonObject(with: newData, options: .allowFragments)) as! NSDictionary
            guard let user = (parseResult["user"] as? [String:Any]) else {
                completionHandler(false, "Could not retrieve User Info from Udacity.")
                return
            }
            
            if let firstName = user["first_name"] as? String, let lastName = user["last_name"] as? String {
                self.name = firstName + " " + lastName
                self.firstName = firstName
                self.lastName = lastName
            }
            
            completionHandler(true, nil)
        }
        task.resume()
    }
    // Logout function - Deleting Udacity session
    func logout(completionHandler: @escaping (_ sucess: Bool, _ errorString: String?)-> Void) {
        let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) {  (data, response, error) in
            if error != nil {
                completionHandler(false, error!.localizedDescription)
                return
            }
            let newData = data!.subdata(in: 5..<(data!.count))
            print(NSString(data: newData, encoding: String.Encoding.utf8.rawValue)!)
            completionHandler(true, nil)
        }
        
        task.resume()
    }
}
