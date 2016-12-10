//
//  BarButtons.swift
//  On The Map
//
//  Created by Nikhil on 10/12/16.
//  Copyright © 2016 Nikhil. All rights reserved.
//

import UIKit

class BarButtons: UIViewController{

    static let sharedInstance = BarButtons()
    func refresh(completionHandler: @escaping(_ refresh: Bool, _ error: String?)-> Void) {
            StudentLocation.sharedInstance.gettingStudentLocations { (sucess,error) in
            if error != nil {
                completionHandler(false, error)
            }
            else {
                completionHandler(true,nil)
            }
        }
    }

    func logout(completionHandler: @escaping(_ logout: Bool, _ error: String?)-> Void) {
        Login.sharedInstance.logout { (sucess,error) in
            if sucess {
                completionHandler(true, nil)
            }
            else {
                completionHandler(false, error)
            }
        }
    }

}
