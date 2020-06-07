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
    @IBOutlet var tableView: UITableView!
    
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
        chessboard.onPathCalculated = { [weak self] path in
            self?.onPathCalculated(path)
        }
        tableView.dataSource = self
    }
    
    private func refreshChessboard() {
        viewModel.clearPaths()
        let numberOfTiles = viewModel.numberOfTiles
        chessboard.refresh(withNumberOfTiles: numberOfTiles)
        tableView.reloadData()
    }
    
    private func clearChessboard() {
        chessboard.clear()
        viewModel.clearPaths()
        tableView.reloadData()
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
    
    func onPathCalculated(_ path: [TilePoint]) {
        viewModel.addPath(path)
        tableView.reloadData()
    }
}

// MARK: UI Table View Datasource

extension StartViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.paths.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PathTableViewCell", for: indexPath) as! PathTableViewCell
        cell.configure(with: viewModel.paths[indexPath.row])
        return cell
    }
}
