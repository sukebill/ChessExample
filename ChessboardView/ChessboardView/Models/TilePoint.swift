//
//  TilePoint.swift
//  ChessboardView
//
//  Created by Vassilis Alexandrof on 7/6/20.
//  Copyright © 2020 VA. All rights reserved.
//

import Foundation

struct TilePoint {
    var x: Int
    var y: Int
}

extension TilePoint: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
}
