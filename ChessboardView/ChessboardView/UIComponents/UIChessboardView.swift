//
//  UIChessboardView.swift
//  ChessboardView
//
//  Created by Vassilis Alexandrof on 7/6/20.
//  Copyright © 2020 VA. All rights reserved.
//

import UIKit

public protocol UIChessboardDelegate: class {
    func didCalculate(_ path: [TilePoint])
    func didFailFindingPaths()
}

public class UIChessboardView: UIView {
    @IBInspectable var numberOfTiles: Int = 8
    private var verticalStack: UIStackView!
    private var imageView: UIImageView?
    private var knightIcon: UIImage?
    private var tiles: [[UIChessTile]] = []
    private var startingPoint: TilePoint?
    private var endingPoint: TilePoint?
    private var requiredMoves: Int = 3
    private var shapeLayers: [CAShapeLayer] = []
    private var totalPathsFailed: Int = 0
    weak public var delegate: UIChessboardDelegate?
   
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
}

// MARK: Local Mutations

extension UIChessboardView {
    func setStartingPoint(_ coordinates: TilePoint) {
        startingPoint = coordinates
        setIcon(coordinates)
    }
    
    /// Sets ending point (destination) and if starting point exists, calculates possible moves
    /// - Parameter coordinates: coordinate (TilePoint) to set for destination
    func setEndingPoint(_ coordinates: TilePoint) {
        endingPoint = coordinates
        tiles[coordinates.y][coordinates.x].select()
        guard let startingPoint = startingPoint  else {
            debugPrint("SOMETHING REALLY WRONG HAPPENED!!")
            return
        }
        DispatchQueue.init(label: "pathBG", qos: .background).async {
            self.calculatePossibleMoves(startingFrom: startingPoint)
        }
    }
    
    func clearTiles() {
        verticalStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        clear()
    }
    
    func clearPaths() {
        shapeLayers.forEach { $0.removeFromSuperlayer() }
        shapeLayers = []
    }
}

// MARK: Public Methods

public extension UIChessboardView {
    func setUp(knightIcon: UIImage?, requiredMoves: Int) {
        self.requiredMoves = requiredMoves
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
        startingPoint = nil
        endingPoint = nil
        imageView?.removeFromSuperview()
        imageView = nil
        tiles.forEach { $0.deselect() }
        clearPaths()
    }
}

// MARK: UI Chess Tile Callback

extension UIChessboardView {
    /// Sets starting or ending point
    /// - Parameter coordinate: coordinate (TilePoint) that was selected
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

// MARK: Route Calculation

private extension UIChessboardView {
    /// Takes starting possition and Calculates every possible valid path based on the required moves.
    /// Each path that has reached the destination is draw
    /// If none has reached the destination, the Failure Error is Fired.
    /// - Parameters:
    ///   - pathUntilHere: The TilePoint Array (path) that's been calculated already
    ///   - moveCounter: move number, e.g. move number 2
    func calculatePossibleMoves(startingFrom startingPoint: TilePoint) {
        var paths: [[TilePoint]] = [[startingPoint]]
        for _ in 0..<requiredMoves {
            paths = calculatePaths(paths: paths)
        }
        let totalPathsToTry = paths.count
        totalPathsFailed = 0
        paths.forEach {
            showPathIfNeeded($0)
        }
        guard totalPathsFailed == totalPathsToTry else { return }
        fireError()
    }
    
    /// Takes paths and for each one of them tries to create a new fork of paths if the move is valid
    /// e.g. if you give a point, and all next moves are valid, it will return an array of 8 paths (for the Knight chess piece)
    /// - Parameter paths: Array of paths
    /// - Returns: Array of updated paths ([paths[index] + newMove])
    func calculatePaths(paths: [[TilePoint]]) -> [[TilePoint]] {
        var extendedPaths: [[TilePoint]] = []
        for path in paths {
            
            guard let startingPoint = path.last else {
                fatalError("Path is Empty!!!")
            }
            var validMoves: [TilePoint] = []
            let possibleMoves = TilePoint.possibleKnighMoves
            
            for move in possibleMoves {
                
                let newPoint = startingPoint + move
                let isBetweenBounds = newPoint.x >= 0
                    && newPoint.y >= 0
                    && newPoint.x < numberOfTiles
                    && newPoint.y < numberOfTiles
                guard isBetweenBounds else { continue }
                validMoves.append(newPoint)
            }
            validMoves.forEach {
                let extendedPath = path + [$0]
                extendedPaths.append(extendedPath)
            }
        }
        return extendedPaths
    }
    
    /// Draws a line if the path array isn't empty & if it has reached the destination Point
    /// - Parameter path: the Path through the tiles to draw
    func showPathIfNeeded(_ path: [TilePoint]) {
        guard let destination = path.last else {
            debugPrint("Path is Empty!!!")
            return
        }
        guard destination == endingPoint else {
            totalPathsFailed += 1
            return
        }
        DispatchQueue.main.async {
//        let normalPath = path.buildKnightPath(mirrored: false)
//        drawPath(normalPath)
//        let mirroredPath = path.buildKnightPath(mirrored: true)
//        drawPath(mirroredPath)
            self.drawPath(path)
            self.delegate?.didCalculate(path)
        }
    }
    
    func fireError() {
        DispatchQueue.main.async {
            self.delegate?.didFailFindingPaths()
        }
    }
    
    /// Draws the Basier Path and animates it
    /// - Parameter path: the Path through the tiles to draw
    func drawPath(_ path: [TilePoint]) {
        let bezierPath = UIBezierPath()
        for point in path {
            let tile = tiles[point.y][point.x]
            let tileY = convert(tile.center, from: tile).y
            if point == startingPoint {
                bezierPath.move(to: CGPoint(x: tile.center.x, y: tileY))
            } else {
                bezierPath.addLine(to: CGPoint(x: tile.center.x, y: tileY))
            }
        }
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = bezierPath.cgPath
        shapeLayer.strokeColor = UIColor.random.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 4.0
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.duration = 2
        shapeLayer.add(animation, forKey: "pathANimation")

        layer.addSublayer(shapeLayer)
        shapeLayers.append(shapeLayer)
    }
}
