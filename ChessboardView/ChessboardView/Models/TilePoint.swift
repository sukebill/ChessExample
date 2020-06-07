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


extension TilePoint {
    /// Calculates an 'L' shaped path for the knight to take
    /// Each path between 2 points could have 2 different 'L' shaped paths
    /// - Parameter point: Point destination
    /// - Returns: an array of tiles.
    fileprivate func buildKnightPathNormal(to point: Self) -> [Self] {
        let xDifference = x - point.x
        var path: [TilePoint] = []
        let firstMove = TilePoint(x: x, y: point.y)
        path.append(firstMove)
        for xIndex in 1...abs(xDifference) {
            if xDifference < 0 {
                path.append(TilePoint(x: x + xIndex, y: point.y))
            } else {
                path.append(TilePoint(x: x - xIndex, y: point.y))
            }
        }
        path.insert(self, at: 0)
        return path
    }
    
    /// Calculates an 'L' shaped path for the knight to take (Mirrored)
    /// Each path between 2 points could have 2 different 'L' shaped paths
    /// - Parameter point: Point destination
    /// - Returns: an array of tiles.
    fileprivate func buildKnightPathMirrored(to point: Self) -> [Self] {
        let yDifference = y - point.y
        var path: [TilePoint] = []
        let firstMove = TilePoint(x: point.x, y: y)
        path.append(firstMove)
        for yIndex in 1...abs(yDifference) {
            if yDifference < 0 {
                path.append(TilePoint(x: point.x, y: y + yIndex))
            } else {
                path.append(TilePoint(x: point.x, y: y - yIndex))
            }
        }
        path.insert(self, at: 0)
        return path
    }
}

extension Array where Element == TilePoint {
    func buildKnightPath(mirrored: Bool) -> [Element] {
        var completedPath: [Element] = []
        for index in 0..<count {
            guard index + 1 < count else { continue }
            var knightMove: [Element]
            if mirrored {
                knightMove = self[index].buildKnightPathMirrored(to: self[index + 1])
            } else {
                knightMove = self[index].buildKnightPathNormal(to: self[index + 1])
            }
            completedPath.append(contentsOf: knightMove)
        }
        return completedPath
    }
}
