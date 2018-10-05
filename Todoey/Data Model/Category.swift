//
//  Category.swift
//  Todoey
//
//  Created by Testing on 10/2/18.
//  Copyright © 2018 Yero. All rights reserved.
//

import Foundation
import RealmSwift

// Subclassing a class with 'Object' class to make it a realm instance
class Category: Object {
    
    @objc dynamic var name: String = ""
    
    // Relationship between Item and Category (one Category has many Items)
    let items = List<Item>()
}
