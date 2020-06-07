//
//  UIButtonExtensions.swift
//  ChessboardView
//
//  Created by Vassilis Alexandrof on 7/6/20.
//  Copyright © 2020 VA. All rights reserved.
//

import UIKit

extension UIButton {
    static var rectangle: UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addConstraint(NSLayoutConstraint(item: button,
                                                attribute: .height,
                                                relatedBy: .equal,
                                                toItem: button,
                                                attribute: .width,
                                                multiplier: 1,
                                                constant: 0))
        return button
    }
}
