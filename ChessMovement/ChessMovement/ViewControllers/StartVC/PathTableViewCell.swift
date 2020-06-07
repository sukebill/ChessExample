//
//  PathTableViewCell.swift
//  ChessMovement
//
//  Created by Vassilis Alexandrof on 7/6/20.
//  Copyright © 2020 VA. All rights reserved.
//

import UIKit
import ChessboardView

class PathTableViewCell: UITableViewCell {

    @IBOutlet var pathLabel: UILabel!
    
    func configure(with path: [TilePoint]) {
        pathLabel.text = path.description
    }
}
