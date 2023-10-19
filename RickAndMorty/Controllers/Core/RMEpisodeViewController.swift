//
//  RMEpisodeViewController.swift
//  RickAndMorty
//
//  Created by Cansu Kahraman on 2.10.2023.
//

import UIKit

final class RMEpisodeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.largeTitleDisplayMode = .automatic
        title = "Episodes"
        
        view.backgroundColor = .systemBackground
    }

}
