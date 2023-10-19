//
//  ViewController.swift
//  RickAndMorty
//
//  Created by Cansu Kahraman on 28.09.2023.
//

import UIKit

final class RMTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTaps()
    }

    private func setUpTaps(){
        let nav1 = UINavigationController(rootViewController: RMCharacterViewController())
        let nav2 = UINavigationController(rootViewController: RMLocationViewController())
        let nav3 = UINavigationController(rootViewController: RMEpisodeViewController())
        let nav4 = UINavigationController(rootViewController: RMSettingsViewController())
        
        nav1.tabBarItem = UITabBarItem(title: "Character",
                                       image: UIImage(systemName: "person"),
                                       tag: 1)
        
        nav2.tabBarItem = UITabBarItem(title: "Locations",
                                       image: UIImage(systemName: "globe"),
                                       tag: 2)
        
        nav3.tabBarItem = UITabBarItem(title: "Episodes",
                                       image: UIImage(systemName: "tv"),
                                       tag: 3)
        
        nav4.tabBarItem = UITabBarItem(title: "Settings",
                                       image: UIImage(systemName: "gear"),
                                       tag: 4)
        
        for nav in [nav1, nav2, nav3, nav4] {
            nav.navigationBar.prefersLargeTitles = true
        }
        
        setViewControllers(
            [nav1,nav2,nav3,nav4],
            animated: true)
    }
}

