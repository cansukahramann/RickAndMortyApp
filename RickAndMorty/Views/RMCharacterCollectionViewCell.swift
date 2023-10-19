//
//  RMCharacterCollectionViewCell.swift
//  RickAndMorty
//
//  Created by Cansu Kahraman on 8.10.2023.
//

import UIKit

final class RMCharacterCollectionViewCell: UICollectionViewCell {
    static let cellIdentifer = "RMCharacterCollectionViewCell"
    
    private let imageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private let nameLbl: UILabel = {
       let nameLbl = UILabel()
        nameLbl.textColor = .label
        nameLbl.font = .systemFont(ofSize: 18, weight: .medium)
        nameLbl.translatesAutoresizingMaskIntoConstraints = false
        
        return nameLbl
    }()
    
    private let statusLbl: UILabel = {
       let statusLbl = UILabel()
        statusLbl.textColor = .secondaryLabel
        statusLbl.font = .systemFont(ofSize: 16, weight: .regular)
        statusLbl.translatesAutoresizingMaskIntoConstraints = false
        
        return statusLbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubviews(imageView, nameLbl, statusLbl)
        addConstraints()
        setUpLayer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    private func setUpLayer(){
        contentView.layer.cornerRadius = 8
        contentView.layer.shadowColor = UIColor.secondaryLabel.cgColor
        contentView.layer.cornerRadius = 4
        contentView.layer.shadowOffset = CGSize(width: -4, height: 4)
        contentView.layer.shadowOpacity = 0.3
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            statusLbl.heightAnchor.constraint(equalToConstant: 30),
            nameLbl.heightAnchor.constraint(equalToConstant: 30),
            
            statusLbl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 7),
            statusLbl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -7),
            nameLbl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 7),
            nameLbl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -7),
            
            statusLbl.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            nameLbl.bottomAnchor.constraint(equalTo: statusLbl.topAnchor, constant: -3),
            
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: nameLbl.topAnchor, constant: -3)
        ])
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setUpLayer()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        nameLbl.text = nil
        statusLbl.text = nil
    }
    
    func configure(with viewModel: RMCharacterCollectionViewCellViewModel){
        nameLbl.text = viewModel.characterName
        statusLbl.text = viewModel.characterStatusText
        viewModel.fetchImage { [weak self] result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    let image = UIImage(data: data)
                    self?.imageView.image = image
                }
            case .failure(let error):
                print(String(describing: error))
                break
            }
        }
    }
}
