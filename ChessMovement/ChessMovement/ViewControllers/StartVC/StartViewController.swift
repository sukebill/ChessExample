//
//  StartViewController.swift
//  ChessMovement
//
//  Created by Vassilis Alexandrof on 7/6/20.
//  Copyright © 2020 VA. All rights reserved.
//

import UIKit
import ChessboardView

class StartViewController: UIViewController {
    @IBOutlet var chessboard: UIChessboardView!

    private var viewModel: StartViewModel = StartViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }
    
    @IBAction func onResetTapped(_ sender: Any) {
        clearChessboard()
    }
    
    @IBAction func onSettingsTapped(_ sender: Any) {
        let currentTileAmount = viewModel.numberOfTiles
        Route.settings(currentTileAmount: currentTileAmount,
                       onNewTileSelection: { [weak self] newTileAmount in
                        self?.changeChessboardSize(newTileAmount)
        }).presentFrom(self)
    }

}

// MARK: View Set Up

private extension StartViewController {
    private func setUpViews() {
        chessboard.setUp(knightIcon: UIImage(named: "knight"),
                         requiredMoves: viewModel.requiredMoves)
    }
    
    private func refreshChessboard() {
        let numberOfTiles = viewModel.numberOfTiles
        chessboard.refresh(withNumberOfTiles: numberOfTiles)
    }
    
    private func clearChessboard() {
        chessboard.clear()
    }
}

// MARK: Actions

private extension StartViewController {
    func changeChessboardSize(_ newTileAmount: Int) {
        do {
            try viewModel.resizeChessboard(newTileAmount)
            refreshChessboard()
        } catch(let error) where error is SizeError {
            let sizeError = error as! SizeError
            showAlert(message: sizeError.localizedDescription)
        } catch {
            showAlert(message: "Something went realy wrong!!!")
        }
    }
}
