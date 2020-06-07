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
    private var imageView: UIImageView?
    private var knightIcon: UIImage?
    private var tiles: [[UIChessTile]] = []
    var startingPoint: TilePoint?
    var endingPoint: TilePoint?
   
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
        for row in 0..<numberOfTiles {
            let rule: ColourRule = row % 2 == 0 ? .lightFirst : .darkFirst
            addChessboardHorizontalRow(row: row, rule: rule)
        }
    }
    
    /// Creates and Adds horizontal row of black & white rectangles
    /// - Parameters:
    ///   - row: the row (Index) to be build
    ///   - rule: Rule for starting with light or dark colour of rectangle
    func addChessboardHorizontalRow(row: Int, rule: ColourRule) {
        let horizontalStack = UIStackView()
        horizontalStack.alignment = .fill
        horizontalStack.distribution = .fillEqually
        horizontalStack.axis = .horizontal
        var tileRow: [UIChessTile] = []
        for column in 0..<numberOfTiles {
            let tile = UIChessTile(coordintates: TilePoint(x: column, y: row))
            tile.onSelection = { [weak self] coordinates in
                self?.onTileSelected(coordinates)
            }
            tile.backgroundColor = rule.getColour(byIndex: column)
            horizontalStack.addArrangedSubview(tile)
            tileRow.append(tile)
        }
        verticalStack.addArrangedSubview(horizontalStack)
        tiles.append(tileRow)
    }
    
    func clearTiles() {
        verticalStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        clear()
    }
}

// MARK: UI Chess Tile Callback

extension UIChessboardView {
    func onTileSelected(_ coordinate: TilePoint) {
        switch (startingPoint, endingPoint) {
        case (nil, nil):
            setStartingPoint(coordinate)
        case (.some(_), nil):
            setEndingPoint(coordinate)
        default:
            return
        }
    }
    
    private func setStartingPoint(_ coordinates: TilePoint) {
        startingPoint = coordinates
        setIcon(coordinates)
    }
    
    private func setEndingPoint(_ coordinates: TilePoint) {
        endingPoint = coordinates
        tiles[coordinates.y][coordinates.x].select()
        guard let startingPoint = startingPoint  else {
            debugPrint("SOMETHING REALLY WRONG HAPPENED!!")
            return
        }
    }
}

// MARK: Icon Generation

extension UIChessboardView {
    func setIcon(_ coordinates: TilePoint) {
        let tile = tiles[coordinates.y][coordinates.x]
        let parentReferenceY = convert(tile.center, from: tile).y
        let imageView = UIImageView(frame: tile.bounds)
        imageView.image = knightIcon
        imageView.center = CGPoint(x: tile.center.x, y: parentReferenceY)
        imageView.contentMode = .scaleAspectFit
        addSubview(imageView)
        bringSubviewToFront(imageView)
        self.imageView = imageView
    }
}

// MARK: Public Methods

public extension UIChessboardView {
    func setUp(knightIcon: UIImage?) {
        self.knightIcon = knightIcon
    }
    
    /// Clears all tiles and rebuilds them
    /// - Parameter numberOfTiles: the number of tiles (number * number)
    func refresh(withNumberOfTiles numberOfTiles: Int) {
        self.numberOfTiles = numberOfTiles
        tiles = []
        clearTiles()
        setUpTiles()
    }
    
    /// Clears chessboard from paths and chess pieces
    func clear() {
        
    }
}
