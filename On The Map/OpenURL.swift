//
//  OpenURL.swift
//  On The Map
//
//  Created by Nikhil on 09/12/16.
//  Copyright © 2016 Nikhil. All rights reserved.
//

import UIKit

class OpenURL: UIViewController {
    
    static let sharedInstance = OpenURL()
    func openBrowser(Link: String) {
        let finalLink = "https://"+Link
        if let url = URL(string: finalLink) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: { (sucess) in
                    print("Open \(url):\(sucess)")
                })
            }
            else {
                let sucess = UIApplication.shared.openURL(url)
                print("Open \(url):\(sucess)")
            }
        }
    }
}

