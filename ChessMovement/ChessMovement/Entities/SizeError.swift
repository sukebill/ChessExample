//
//  SizeError.swift
//  ChessMovement
//
//  Created by Vassilis Alexandrof on 7/6/20.
//  Copyright © 2020 VA. All rights reserved.
//

import Foundation

enum SizeError: Error {
    case tooSmall(size: Int, bottomRule: Int)
    case tooBig(size: Int, upperRule: Int)
    
    var localizedDescription: String {
        switch self {
        case .tooSmall(let size, let bottomRule):
            return "Selected size of \(size) is too small. Chessboard should size should be greater than or equal to \(bottomRule)"
        case .tooBig(let size, let upperRule):
            return "Selected size of \(size) is too big. Chessboard should size should be less than or equal to \(upperRule)"
        }
    }
}
