//
//  Error.swift
//  On The Map
//
//  Created by Nikhil on 08/12/16.
//  Copyright © 2016 Nikhil. All rights reserved.
//

import UIKit

class Error: UIAlertController {
    
    static let sharedInstance = Error()
    func showError(controller: UIViewController, title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        controller.present(alert, animated: true, completion: nil)
    }
}
