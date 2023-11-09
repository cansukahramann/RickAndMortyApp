//
//  RMEpisodeDetailViewModel.swift
//  RickAndMorty
//
//  Created by Cansu Kahraman on 28.10.2023.
//

import UIKit

protocol RMEpisodeDetailViewViewModelDelegate: AnyObject {
    func didFetchEpisodeDetails()
}

final class RMEpisodeDetailViewViewModel {
    
    private let endpointUrl: URL?
    
    //????*
    private var dataTuple: (episode: RMEpisode,characters: [RMCharacter])? {
        didSet {
            createCellViewModels()
            delegate?.didFetchEpisodeDetails()
        }
    }
    
    enum SectionType {
        case information(viewModels: [RMEpisodeInfoCollectionViewCellViewModel])
        case characters(viewModel: [RMCharacterCollectionViewCellViewModel])
    }
    
    weak var delegate: RMEpisodeDetailViewViewModelDelegate?
    
    private(set) var cellViewModels: [SectionType] = []

    init(endpointUrl: URL?) {
        self.endpointUrl = endpointUrl
    }
    
    func character(at index: Int) -> RMCharacter? {
        guard let dataTuple else {
            return nil
        }
        return dataTuple.characters[index]
    }
    
    private func createCellViewModels() {
        guard let dataTuple = dataTuple else {
            return
        }
        let episode = dataTuple.episode
        let characters = dataTuple.characters
        
        var createdString = episode.created
        if let date = RMCharacterInfoCollectionViewCellViewModel.dateFormatter.date(from: episode.created) {
            createdString = RMCharacterInfoCollectionViewCellViewModel.shortDateFormatter.string(from: date)
        }
        
        cellViewModels = [
            .information(viewModels: [
                .init(title: "Episode Name", value:episode.name),
                .init(title: "Air Date", value: episode.air_date),
                .init(title: "Episode", value: episode.episode),
                .init(title: "Created", value: createdString)]),
            
            .characters(viewModel: characters.compactMap({ character in
                return RMCharacterCollectionViewCellViewModel(characterName: character.name,
                                                              characterStatus: character.status,
                                                              characterImageUrl: URL(string: character.image))
            }))
            
            ]
    }
    
     func fetchEpisodeData() {
        guard let url = endpointUrl,
              let request = RMRequest(url: url) else {
            return
        }
        RMService.shared.execute(request, expecting: RMEpisode.self) { [weak self] result in
            switch result {
            case .success(let model):
                self?.fetchRelatedCharacters(episode: model)
            case .failure(let failure):
                break
            }
        }
    }
    
    private func fetchRelatedCharacters(episode: RMEpisode) {
        
        let requests = episode.characters.compactMap { URL(string: $0) }.compactMap { RMRequest(url: $0) }
        
        let group = DispatchGroup()
        var characters = [RMCharacter]()

        for request in requests {
            group.enter()
            
            RMService.shared.execute(request, expecting: RMCharacter.self) { [weak self] result in
                guard let self else { return }
                
                defer {
                    group.leave()
                }
                
                switch result {
                case .success(let character):
                    characters.append(character)
                case .failure(let error):
                    print(error)
                }
                
            }
        }
        
        group.notify(queue: .main) {
            self.dataTuple = (
                episode: episode,
                characters: characters
            )
        }
    }
}
