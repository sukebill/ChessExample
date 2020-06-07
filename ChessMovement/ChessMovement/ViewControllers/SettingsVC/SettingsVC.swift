//
//  SettingsVC.swift
//  ChessMovement
//
//  Created by Vassilis Alexandrof on 7/6/20.
//  Copyright © 2020 VA. All rights reserved.
//

import Foundation

struct SettingsViewModel {
    let currentTileAmount: Int
    private (set) var newTileAmount: Int?
    
    init(tiles: Int) {
        currentTileAmount = tiles
    }
}

// MARK: Mutations

extension SettingsViewModel {
    mutating func set(tileAmount: Int?) {
        newTileAmount = tileAmount
    }
}
