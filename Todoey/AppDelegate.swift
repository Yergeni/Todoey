//
//  AppDelegate.swift
//  Todoey
//
//  Created by Testing on 9/24/18.
//  Copyright © 2018 Yero. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // print(Realm.Configuration.defaultConfiguration.fileURL)
        
        // Initializing RealmSwift
        do {
            let _ = try Realm()
        } catch {
            print("Error initializing new realm \(error)")
        }
        
        return true
    }
    
}

