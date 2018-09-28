//
//  Item.swift
//  Todoey
//
//  Created by Yero on 9/27/18.
//  Copyright © 2018 Yero. All rights reserved.
//

import Foundation

class Item {
    
    var title : String = ""
    var done : Bool
    
    init(aTitle : String) {
        self.title = aTitle
        self.done = false
    }
}