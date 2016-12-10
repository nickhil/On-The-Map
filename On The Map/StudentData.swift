//
//  StudentData.swift
//  On The Map
//
//  Created by Nikhil on 08/12/16.
//  Copyright © 2016 Nikhil. All rights reserved.
//

import Foundation
class StudentData: NSData {
    static let sharedInstance = StudentData()
    var mapPins = [StudentInformation]()
}
