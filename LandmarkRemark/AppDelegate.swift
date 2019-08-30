//
//  AppDelegate.swift
//  LandmarkRemark
//
//  Created by Yu Sun on 30/8/19.
//  Copyright © 2019 Yu Sun. All rights reserved.
//

import Firebase
import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let homeViewController = HomeViewController()
        window?.rootViewController = UINavigationController(rootViewController: homeViewController)
        window?.makeKeyAndVisible()
        
        return true
    }
}

