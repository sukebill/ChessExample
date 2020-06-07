//
//  UIViewControllerExtensions.swift
//  ChessMovement
//
//  Created by Vassilis Alexandrof on 7/6/20.
//  Copyright © 2020 VA. All rights reserved.
//

import UIKit

extension UIViewController {
    class var storyboardID: String { "\(self)" }

    class func instantiate(fromAppStoryboard appStoryboard: AppStoryboard) -> Self {
        return appStoryboard.viewController(viewControllerClass: self)
    }
}
