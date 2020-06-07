//
//  Route.swift
//  ChessMovement
//
//  Created by Vassilis Alexandrof on 7/6/20.
//  Copyright © 2020 VA. All rights reserved.
//

import UIKit

enum Route: RouteProtocol {
    case start
    
    var viewController: UIViewController {
        switch self {
        case .start:
            return StartViewController.instantiate(fromAppStoryboard: .main)
        }
    }
}
