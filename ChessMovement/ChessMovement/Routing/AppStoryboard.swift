//
//  AppStoryboard.swift
//  ChessMovement
//
//  Created by Vassilis Alexandrof on 7/6/20.
//  Copyright © 2020 VA. All rights reserved.
//

import UIKit

enum AppStoryboard: String {
    case main = "Main"
    
    var instance: UIStoryboard {
        return UIStoryboard(name: rawValue, bundle: Bundle.main)
    }

    func viewController<T: UIViewController>(viewControllerClass: T.Type) -> T {
        let storyboardId = (viewControllerClass as UIViewController.Type).storyboardID
        return instance.instantiateViewController(withIdentifier: storyboardId) as! T
    }

    func initialViewController() -> UIViewController? {
        return instance.instantiateInitialViewController()
    }
}
