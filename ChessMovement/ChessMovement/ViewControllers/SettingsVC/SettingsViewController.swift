//
//  SettingsViewController.swift
//  ChessMovement
//
//  Created by Vassilis Alexandrof on 7/6/20.
//  Copyright © 2020 VA. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    @IBOutlet var textField: UITextField!
    
    var viewModel: SettingsViewModel!
    var onNewTileSelection: ((Int) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }
    
    private func close() {
        dismiss(animated: true, completion: { [weak self] in
            self?.fireCallbackIfNeeded()
        })
    }
    
    private func fireCallbackIfNeeded() {
        guard let number = viewModel.newTileAmount else { return }
        onNewTileSelection?(number)
    }

}

// MARK: Set up

private extension SettingsViewController {
    func setUpViews() {
        textField.text = String(viewModel.currentTileAmount)
        textField.delegate = self
        textField.addTarget(self,
                            action: #selector(textFieldDidChange(_:)),
                            for: .editingChanged)
    }
}

// MARK: Actions

extension SettingsViewController {
    @objc private func textFieldDidChange(_ textField: UITextField) {
        let number = Int(textField.text ?? "")
        viewModel.set(tileAmount: number)
    }
}

// MARK: UI Text Field Delegate

extension SettingsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        close()
        return true
    }
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        
        return ((textField.text ?? "") + string).count <= 2
    }
}
