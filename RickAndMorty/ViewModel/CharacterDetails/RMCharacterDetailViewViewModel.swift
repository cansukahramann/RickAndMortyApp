//
//  RMCharacterDetailViewViewModel.swift
//  RickAndMorty
//
//  Created by Cansu Kahraman on 10.10.2023.
//

import UIKit

final class RMCharacterDetailViewViewModel{
    
    private var character: RMCharacter
    
    var episodes: [String] {
        character.episode
    }
    
    enum SectionType{
        case photo(viewModel: RMCharacterPhotoCollectionViewCellViewModel)
        case information(viewModels: [RMCharacterInfoCollectionViewCellViewModel])
        case episodes(viewModels: [RMCharacterEpisodeCollectionViewCellViewModel])
    }
    
    var sections: [SectionType] = []
    
    init(character: RMCharacter){
        self.character = character
        setUpSection()
        
    }
    
    private func setUpSection(){
        sections = [
            .photo(viewModel: .init(imageUrl: URL(string: character.image))),
            .information(viewModels: [
                .init(type:.status,value: character.status.text),
                .init(type:.gender,value: character.gender.rawValue),
                .init(type:.type,value: character.type),
                .init(type:.species,value: character.species),
                .init(type:.origin,value: character.origin.name),
                .init(type:.location,value: character.location.name),
                .init(type:.created,value: character.created),
                .init(type:.episodeCount,value: "\(character.episode.count)")
            ]),
            .episodes(viewModels: character.episode.compactMap({
                return RMCharacterEpisodeCollectionViewCellViewModel(episodeDataUrl: URL(string: $0))
            } ))
        ]
    }
    
    private var requestUrl: URL? {
        return URL(string: character.url)
    }
    
    var title: String{
        character.name.uppercased()
    }
    
    func createPhotoSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)))
        item.contentInsets.bottom = 10
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize:NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(0.5)) ,
            subitems: [item] )
        
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
    func createInformationSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .fractionalHeight(1.0)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize:NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(150)) ,
            subitems: [item, item])
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
    func createEpisodesSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 8, bottom: 10, trailing: 5 )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize:NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.8),
                heightDimension: .absolute(150)) ,
            subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        return section
    }
}
