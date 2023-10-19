//
//  RMSettingsViewController.swift
//  RickAndMorty
//
//  Created by Cansu Kahraman on 2.10.2023.
//

import UIKit

final class RMSettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.largeTitleDisplayMode = .automatic
        title = "Settings"
        
        view.backgroundColor = .systemBackground
    }

}
