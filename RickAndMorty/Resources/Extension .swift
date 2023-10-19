//
//  Extension .swift
//  RickAndMorty
//
//  Created by Cansu Kahraman on 6.10.2023.
//

import UIKit

extension UIView {
    // Variadic parameter.
    func addSubviews(_ views: UIView...){
        views.forEach { addSubview($0) }
    }
}
