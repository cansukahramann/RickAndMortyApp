//
//  RMSearchViewViewModel.swift
//  RickAndMorty
//
//  Created by Cansu Kahraman on 15.11.2023.
//

import Foundation

final class RMSearchViewViewModel {
    
    let config: RMSearchViewController.Config
    
    private var optionMap: [RMSearchInputViewViewModel.DynamicOptions: String] = [:]
    
    private var searchText = ""
    
    private var optionMapUpdateBlock: (((RMSearchInputViewViewModel.DynamicOptions, String))->Void)?
    
    private var searchReslutHandler: ((RMSearchResultViewModel) -> Void)?
    
    init(config: RMSearchViewController.Config) {
        self.config = config
    }
    
    func registerSearchResultHandler( _ block: @escaping(RMSearchResultViewModel) -> Void){
        self.searchReslutHandler = block
    }
    
    func executeSearch() {
        
        var queryParams: [URLQueryItem] = [URLQueryItem(name: "name", value: searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))]
        
        queryParams.append(contentsOf: optionMap.enumerated().compactMap({ _, element in
            let key: RMSearchInputViewViewModel.DynamicOptions = element.key
            let value: String =  element.value
            return URLQueryItem(name: key.queryArgument, value: value)
        }))
        let request = RMRequest(endpoint: config.type.endpoint, queryParameters: queryParams)
        
        switch config.type.endpoint {
        case.character:
            makeSearchAPICall(RMGetAllCharactersResponse.self, request: request)
        case.episode:
            makeSearchAPICall(RMGetAllEpisodesResponse.self, request: request)
        case.location:
            makeSearchAPICall(  RMGetAllLocationsResponse.self, request: request )
        }
    }
    
    private func makeSearchAPICall<T: Codable>(_ type: T.Type, request: RMRequest) {
        RMService.shared.execute(request, expecting: type) { [weak self] result in
            switch result {
            case .success(let model):
                self?.processSearchResult(model:  model)
            case.failure:
                print("Failed to get results")
                break
            }
        }
    }
    
    private func processSearchResult(model: Codable) {
        var resultVM: RMSearchResultViewModel?
        if let characterResult = model as? RMGetAllCharactersResponse {
            resultVM  = .characters(characterResult.results.compactMap({
                return RMCharacterCollectionViewCellViewModel(
                    characterName: $0.name,
                    characterStatus: $0.status,
                    characterImageUrl: URL(string: $0.image))
            }))
        }
        else if let episodesResult = model as? RMGetAllEpisodesResponse {
            resultVM = .episodes(episodesResult.results.compactMap({
                return RMCharacterEpisodeCollectionViewCellViewModel(
                    episodeDataUrl: URL(string: $0.url))
            }))
        }
        else if let locationResult = model as? RMGetAllLocationsResponse {
            resultVM = .loactions(locationResult.results.compactMap({
                return RMLocationTableViewCellViewModel(location: $0)
            }))
        }
        
        if let results = resultVM {
            self.searchReslutHandler?(results)
        } else {
            
        }
    }
    
    func set(query text: String) {
        self.searchText = text
    }
    
    func set (value: String, for option : RMSearchInputViewViewModel.DynamicOptions) {
        optionMap[option] = value
        let tuple = (option, value)
        optionMapUpdateBlock?(tuple)
    }
    
    func registerOptionChangeBlock (_ block: @escaping((RMSearchInputViewViewModel.DynamicOptions, String))->Void) {
        self.optionMapUpdateBlock = block
    }
}
