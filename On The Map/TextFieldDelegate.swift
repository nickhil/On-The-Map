//
//  TextFieldDelegate.swift
//  On The Map
//
//  Created by Nikhil on 08/12/16.
//  Copyright © 2016 Nikhil. All rights reserved.
//

import Foundation
import UIKit

class TextFieldDelegate: NSObject, UITextFieldDelegate {
   
    func textFieldShouldReturn(_ textField: UITextField)-> Bool {
         textField.endEditing(true)
         return true
    }
}
