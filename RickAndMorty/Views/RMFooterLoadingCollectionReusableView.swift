//
//  RMFooterLoadingCollectionReusableView.swift
//  RickAndMorty
//
//  Created by Cansu Kahraman on 12.10.2023.
//

import UIKit

final class RMFooterLoadingCollectionReusableView: UICollectionReusableView {
      
    static let identifier = "RMFooterLoadingCollectionReusableView"
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubview(spinner)
        addConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupperted")
    }
    
    private func addConstraint() {
        NSLayoutConstraint.activate([
            spinner.widthAnchor.constraint(equalToConstant: 100),
            spinner.heightAnchor.constraint(equalToConstant: 100),
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    func startAnimating(){
        spinner.startAnimating()
    }
}
