//
//  UIChessTile.swift
//  ChessboardView
//
//  Created by Vassilis Alexandrof on 7/6/20.
//  Copyright © 2020 VA. All rights reserved.
//

import UIKit

public class UIChessTile: UIView {
    var button: UIButton!
    var onSelection: ((TilePoint) -> Void)?
    var coordinates: TilePoint!
    var isSelected: Bool = false
    
    init(coordintates: TilePoint) {
        super.init(frame: .zero)
        self.coordinates = coordintates
        commonInit()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        coordinates = TilePoint(x: 0, y: 0)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        coordinates = TilePoint(x: 0, y: 0)
        commonInit()
    }
    
    func commonInit() {
        button = UIButton.rectangle
        addSubview(button)
        button.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        button.topAnchor.constraint(equalTo: topAnchor).isActive = true
        button.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        button.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        button.addTarget(self, action: #selector(onTap), for: .touchUpInside)
    }
}

// MARK: Actions

private extension UIChessTile {
    @objc func onTap() {
        onSelection?(coordinates)
    }
}

// MARK: Mutations

extension UIChessTile {
    func select() {
        isSelected = true
        button.backgroundColor = UIColor.green.withAlphaComponent(0.4)
    }
    
    func deselect() {
        isSelected = false
        button.backgroundColor = .clear
    }
}

// MARK: Array Extension

extension Array where Element == UIChessTile {
    func deselect() {
        forEach {
            $0.deselect()
        }
    }
}
