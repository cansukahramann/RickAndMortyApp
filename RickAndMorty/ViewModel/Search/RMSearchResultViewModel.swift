//
//  RMSearchResultViewModel.swift
//  RickAndMorty
//
//  Created by Cansu Kahraman on 28.11.2023.
//

import Foundation

enum RMSearchResultViewModel {
    case characters([RMCharacterCollectionViewCellViewModel])
    case episodes([RMCharacterEpisodeCollectionViewCellViewModel])
    case loactions([RMLocationTableViewCellViewModel])
}
