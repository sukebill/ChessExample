//
//  UIChessboardView.swift
//  ChessboardView
//
//  Created by Vassilis Alexandrof on 7/6/20.
//  Copyright © 2020 VA. All rights reserved.
//

import UIKit

public class UIChessboardView: UIView {
    @IBInspectable var numberOfTiles: Int = 8
    private var verticalStack: UIStackView!
   
    public init(frame: CGRect, withNumberOfTiles numberOfTiles: Int, knightIcon: UIImage?) {
        super.init(frame: frame)
        self.numberOfTiles = numberOfTiles
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        setUpVerticalStack()
        setUpTiles()
    }
}

// MARK: Set Up

extension UIChessboardView {
    func setUpVerticalStack() {
        guard verticalStack == nil else { return }
        verticalStack = UIStackView()
        verticalStack.alignment = .fill
        verticalStack.distribution = .fillEqually
        verticalStack.axis = .vertical
        verticalStack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(verticalStack)
        verticalStack.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        verticalStack.topAnchor.constraint(equalTo: topAnchor).isActive = true
        verticalStack.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        verticalStack.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
    
    func setUpTiles() {
        guard numberOfTiles > 0 else {
            fatalError("Size can't be less than or equal to 0")
        }
        for _ in 0..<numberOfTiles {
            addChessboardHorizontalRow()
        }
    }
    
    /// Creates and Adds horizontal row of black & white rectangles
    /// - Parameters:
    ///   - row: the row (Index) to be build
    ///   - rule: Rule for starting with light or dark colour of rectangle
    func addChessboardHorizontalRow() {
        let horizontalStack = UIStackView()
        horizontalStack.alignment = .fill
        horizontalStack.distribution = .fillEqually
        horizontalStack.axis = .horizontal
        for index in 0..<numberOfTiles {
            let tile = UIButton()
            tile.backgroundColor = index % 2 == 0 ? .white : .black
            horizontalStack.addArrangedSubview(tile)
        }
        verticalStack.addArrangedSubview(horizontalStack)
    }
}
