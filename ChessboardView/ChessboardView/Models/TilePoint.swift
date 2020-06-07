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

extension TilePoint {
    static let possibleKnighMoves: [TilePoint] = [
        TilePoint(x: 2, y: 1),
        TilePoint(x: 1, y: 2),
        TilePoint(x: -1, y: 2),
        TilePoint(x: -2, y: 1),
        TilePoint(x: -2, y: -1),
        TilePoint(x: -1, y: -2),
        TilePoint(x: 1, y: -2),
        TilePoint(x: 2, y: -1)
    ]
}

extension TilePoint: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
    
    static func + (lhs: Self, rhs: Self) -> Self {
        return TilePoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
}
