//
//  RMSearchViewController.swift
//  RickAndMorty
//
//  Created by Cansu Kahraman on 30.10.2023.
//

import UIKit
///Configurable controller to search
class RMSearchViewController: UIViewController {
    
    ///Configuration for search session
    struct Config {
        enum `Type` {
            case character // name | status | gender
            case episode  // name
            case location // name | type
            
            var title: String {
                switch self {
                case .character:
                    return "Search Characters"
                case.location:
                    return "Search Locations"
                case.episode:
                    return "Search Episode"
                }
            }
            
        }
        let type: `Type`
    }
    
    private let config: Config
    
    init(config: Config){
        self.config = config
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = config.type.title
        view.backgroundColor = .systemBackground
        
    }
}
