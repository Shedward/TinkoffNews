//
//  SegueNavigation.swift
//  TinkoffNews
//
//  Created by Vladislav Maltsev on 16.10.17.
//  Copyright © 2017 Shedward. All rights reserved.
//

import UIKit

protocol Segue {
    var segueIdentifier: String { get }
}

extension UIViewController {
    func performSegue(_ segue: Segue) {
        self.performSegue(withIdentifier: segue.segueIdentifier, sender: segue)
    }
}
