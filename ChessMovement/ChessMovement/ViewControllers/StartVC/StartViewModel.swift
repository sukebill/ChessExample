//
//  StartViewModel.swift
//  ChessMovement
//
//  Created by Vassilis Alexandrof on 7/6/20.
//  Copyright © 2020 VA. All rights reserved.
//

import Foundation

struct StartViewModel {
    private (set) var numberOfTiles: Int
    let requiredMoves: Int
    private let bottomRule: Int
    private let upperRule: Int
    
    init() {
        numberOfTiles = 8
        requiredMoves = 3
        bottomRule = 6
        upperRule = 16
    }
}

// MARK: Mutations

extension StartViewModel {
    /// Tries to mutates Chessboard size data.
    /// Returns with error if it fails
    /// - Parameter size: Int describing the new size
    /// - Throws: SizeError Model. Either returns tooSmall or tooBig Error
    mutating func resizeChessboard(_ size: Int) throws {
        guard size >= bottomRule else {
            throw SizeError.tooSmall(size: size, bottomRule: bottomRule)
        }
        guard size <= upperRule else {
            throw SizeError.tooBig(size: size, upperRule: upperRule)
        }
        numberOfTiles = size
    }
}
