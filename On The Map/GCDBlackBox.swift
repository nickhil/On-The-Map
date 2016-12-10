//
//  GCDBlackBox.swift
//  On The Map
//
//  Created by Nikhil on 08/12/16.
//  Copyright © 2016 Nikhil. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(updates: @escaping ()-> Void ) {
    DispatchQueue.main.async {
        updates()
    }
}
