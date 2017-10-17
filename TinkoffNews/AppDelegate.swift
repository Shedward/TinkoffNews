//
//  AppDelegate.swift
//  TinkoffNews
//
//  Created by Vladislav Maltsev on 10.10.17.
//  Copyright © 2017 Shedward. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        let _ = Application.shared
        
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        Application.shared.saveAllChanges()
    }
}

