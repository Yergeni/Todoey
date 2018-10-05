//
//  Item.swift
//  Todoey
//
//  Created by Testing on 10/2/18.
//  Copyright © 2018 Yero. All rights reserved.
//

import Foundation
import RealmSwift

// Subclassing a class with 'Object' class to make it a realm instance
class Item: Object {
    
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated: Date?
    
    // Relationship
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")

    
//    func getCurrentDate() -> String {
//        // get the current date and time
//        let currentDate = Date()
//
//        // get the format
//        let formatter = DateFormatter()
//        formatter.dateStyle = .short
//
//        // current Date string
//        let todayStr = formatter.string(from: currentDate)
//
//        return todayStr
//    }
}
