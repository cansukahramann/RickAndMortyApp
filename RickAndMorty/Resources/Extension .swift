//
//  Extension .swift
//  RickAndMorty
//
//  Created by Cansu Kahraman on 6.10.2023.
//

import UIKit

extension UIView {
    
    func addSubviews(_ views: UIView...){
        views.forEach { addSubview($0) }
    }
}

extension UIDevice {
    static let isiPhone = UIDevice.current.userInterfaceIdiom == .phone
}
