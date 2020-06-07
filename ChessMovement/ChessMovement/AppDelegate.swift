//
//  AppDelegate.swift
//  ChessMovement
//
//  Created by Vassilis Alexandrof on 7/6/20.
//  Copyright © 2020 VA. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let navCtrl = UINavigationController(rootViewController: Route.start.viewController)
        navCtrl.setNavigationBarHidden(true, animated: false)
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navCtrl
        window?.makeKeyAndVisible()
        return true
    }
}

