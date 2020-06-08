//
//  ColourRule.swift
//  ChessboardView
//
//  Created by Vassilis Alexandrof on 7/6/20.
//  Copyright © 2020 VA. All rights reserved.
//

import Foundation
import UIKit

enum ColourRule {
    case lightFirst
    case darkFirst
    
    func getColour(byIndex index: Int) -> UIColor {
        let isEven = index % 2 == 0
        switch self {
        case .lightFirst:
            return isEven ? .white : .black
        case .darkFirst:
            return isEven ? .black : .white
        }
    }
}
