//
//  RMLocationViewViewModel().swift
//  RickAndMorty
//
//  Created by Cansu Kahraman on 9.11.2023.
//

import Foundation

protocol RMLocationViewViewModelDelegate: AnyObject {
    func didFetchInitialLocations()
}

final class RMLocationViewViewModel {
    
    weak var delegate: RMLocationViewViewModelDelegate?
    
     private var locations: [RMLocation] = [] {
        didSet {
            for location in locations {
                let cellViewModel = RMLocationTableViewCellViewModel(location: location)
                if !cellViewModels.contains(cellViewModel) {
                    cellViewModels.append(cellViewModel)
                }
            }
        }
    }
    
    //Location response info
    //Will content next url, if present
    
    private var apiInfo: RMGetAllLocationsResponse.Info?
    
     var cellViewModels: [RMLocationTableViewCellViewModel] = []
    
    
    init() { }
    
    func fetchLocations() {
        RMService.shared.execute(.listLocaitonsRequest, expecting:RMGetAllLocationsResponse.self) { [weak self] result in
            switch result {
            case .success(let model):
                self?.apiInfo = model.info
                self?.locations = model.results
                DispatchQueue.main.async {
                    self?.delegate?.didFetchInitialLocations()
                }
            case .failure(let error):
                break
            }
        }
        
        
    }
    
    private var hasMoreResults: Bool {
        return false
    }
}
