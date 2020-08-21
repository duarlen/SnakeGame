//
//  AppDelegate.swift
//  SnakeGame
//
//  Created by top on 2020/8/21.
//  Copyright © 2020 top. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow()
        window?.backgroundColor = .white
        window?.frame = UIScreen.main.bounds
        window?.makeKeyAndVisible()
        
        window?.rootViewController = HomeController()
        
        return true
    }
}

