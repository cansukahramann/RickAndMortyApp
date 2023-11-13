//
//  RMLocationTableViewCell.swift
//  RickAndMorty
//
//  Created by Cansu Kahraman on 13.11.2023.
//

import UIKit

final class RMLocationTableViewCell: UITableViewCell {

   static let cellIdentifier = "RMLocationTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func configure(with viewModel: RMLocationTableViewCell) {
        
    }


}
