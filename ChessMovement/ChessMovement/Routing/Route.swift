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
    case settings(currentTileAmount: Int, onNewTileSelection: (Int) -> Void)
    
    var viewController: UIViewController {
        switch self {
        case .start:
            return StartViewController.instantiate(fromAppStoryboard: .main)
        case .settings(let currentTileAmount, let onNewTileSelection):
            let destination = SettingsViewController.instantiate(fromAppStoryboard: .main)
            destination.viewModel = SettingsViewModel(tiles: currentTileAmount)
            destination.onNewTileSelection = onNewTileSelection
            return destination
        }
    }
}
