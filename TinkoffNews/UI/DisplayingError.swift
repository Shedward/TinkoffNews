//
//  DisplayingError.swift
//  TinkoffNews
//
//  Created by Vladislav Maltsev on 16.10.17.
//  Copyright © 2017 Shedward. All rights reserved.
//

import UIKit

protocol DisplayingError {
    func show(error: Error)
}

extension UIViewController: DisplayingError {
    func show(error: Error) {
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)

        alertController.addAction(UIAlertAction(title: "Dismiss", style: .cancel) { [weak alertController] action in
            alertController?.dismiss(animated: true, completion: nil)
        })
        
        self.present(alertController, animated: true, completion: nil)
    }
}
