//
//  RMSearchResultViewModel.swift
//  RickAndMorty
//
//  Created by Cansu Kahraman on 28.11.2023.
//

import Foundation

final class  RMSearchResultViewModel {
    public private(set) var results: RMSearchResultType
    private var next: String?
    
    init(results: RMSearchResultType, next: String?) {
        self.results = results
        self.next = next
    }
    
    public private(set) var isLoadingMoreResults =  false
    
    var shouldShowLoadIndicator: Bool {
        return next != nil 
    }
    
    func fetchAdditionalLocation(completion: @escaping ([RMLocationTableViewCellViewModel]) -> Void ) {
        guard !isLoadingMoreResults else {
            return
        }
        
        guard let nextUrlString = next,
              let url = URL(string: nextUrlString) else {
            return
        }
        
        isLoadingMoreResults = true
        
        guard let request = RMRequest(url: url) else {
            isLoadingMoreResults = false
            return
        }
        
        ///Paginate if additional locations are needed
        RMService.shared.execute(request, expecting: RMGetAllLocationsResponse.self) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let responseModel):
                let moreResults = responseModel.results
                let info = responseModel.info
                self.next = info.next //capture new pagination url
                
                let additionalLocations = moreResults.compactMap({
                    return RMLocationTableViewCellViewModel(location: $0)
                })
                var newResults: [RMLocationTableViewCellViewModel] = []
                
                switch self.results {
                case .loactions(let existingResults):
                    newResults = existingResults + additionalLocations
                    self.results = .loactions(newResults)
                    break
                case .characters, .episodes:
                    break
                }
                
                DispatchQueue.main.async { [self] in
                    self.isLoadingMoreResults = false
                    
                    //Notify via callback
                    completion(newResults)
                }
            case .failure(let failure):
                print(String(describing: failure))
                self.isLoadingMoreResults = false
            }
        }
    }
    
    func fetchAdditionalResults(completion: @escaping ([any Hashable]) -> Void ) {
        guard !isLoadingMoreResults else {
            return
        }
        
        guard let nextUrlString = next,
              let url = URL(string: nextUrlString) else {
            return
        }
        
        isLoadingMoreResults = true
        
        guard let request = RMRequest(url: url) else {
            isLoadingMoreResults = false
            return
        }
        
        switch results {
        case .characters(let existingResults):
            RMService.shared.execute(request, expecting: RMGetAllCharactersResponse.self) { [weak self] result in
                guard let self else { return }
                
                switch result {
                case .success(let responseModel):
                    let moreResults = responseModel.results
                    let info = responseModel.info
                    self.next = info.next //capture new pagination url
                    
                    let additionalResults = moreResults.compactMap({
                        return RMCharacterCollectionViewCellViewModel(characterName: $0.name,
                                                                      characterStatus: $0.status,
                                                                      characterImageUrl: URL(string: $0.image))
                    })
                    var newResults: [RMCharacterCollectionViewCellViewModel] = []
                    newResults = existingResults + additionalResults
                    self.results = .characters(newResults)
                    
                    DispatchQueue.main.async { [self] in
                        self.isLoadingMoreResults = false
                        
                        //Notify via callback
                        completion(newResults)
                    }
                case .failure(let failure):
                    print(String(describing: failure))
                    self.isLoadingMoreResults = false
                }
            }
        case .episodes(let existingResults):
            RMService.shared.execute(request, expecting: RMGetAllEpisodesResponse.self) { [weak self] result in
                guard let self else { return }
                
                switch result {
                case .success(let responseModel):
                    let moreResults = responseModel.results
                    let info = responseModel.info
                    self.next = info.next //capture new pagination url
                    
                    let additionalResults = moreResults.compactMap({
                        return RMCharacterEpisodeCollectionViewCellViewModel(episodeDataUrl: URL(string: $0.url))
                    })
                    var newResults: [RMCharacterEpisodeCollectionViewCellViewModel] = []
                    
                    newResults = existingResults + additionalResults
                    self.results = .episodes(newResults)
                    
                    DispatchQueue.main.async { [self] in
                        self.isLoadingMoreResults = false
                        
                        //Notify via callback
                        completion(newResults)
                    }
                case .failure(let failure):
                    print(String(describing: failure))
                    self.isLoadingMoreResults = false
                }
            }
        case .loactions:
            break
        }
        
    }
    
}


enum RMSearchResultType {
    case characters([RMCharacterCollectionViewCellViewModel])
    case episodes([RMCharacterEpisodeCollectionViewCellViewModel])
    case loactions([RMLocationTableViewCellViewModel])
}
