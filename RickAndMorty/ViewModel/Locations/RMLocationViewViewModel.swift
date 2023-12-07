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
    
    private(set) var cellViewModels: [RMLocationTableViewCellViewModel] = []
    
    var shouldShowLoadIndicator: Bool{
        return apiInfo?.next != nil
    }
    
    var isLoadingMoreLocations = false
    private var didFinishPagination: (() -> Void)?
    
    // MARK: - Init 
    init() { }
    
    func registerDidFinishPaginationBlock(_ block: @escaping() -> Void) {
        self.didFinishPagination = block
    }
    
    func fetchAdditionalLocation() {
        guard !isLoadingMoreLocations else {
            return
        }
        isLoadingMoreLocations = true
        
        guard let nextUrlString = apiInfo?.next,
              let url = URL(string: nextUrlString) else {
            return
        }
        
        guard let request = RMRequest(url: url) else {
            isLoadingMoreLocations = false
            return
        }
        
        ///Paginate if additional locations are needed
        RMService.shared.execute(request, expecting: RMGetAllLocationsResponse.self) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let responseModel):
                let moreResults = responseModel.results
                let info = responseModel.info
                self.apiInfo = info
                self.cellViewModels.append(contentsOf: moreResults.compactMap({
                    return RMLocationTableViewCellViewModel(location: $0)
                }))
                DispatchQueue.main.async { [self] in
                    self.isLoadingMoreLocations = false
                    
                    //Notify via callback
                    self.didFinishPagination?()
                }
            case .failure(let failure):
                print(String(describing: failure))
                self.isLoadingMoreLocations = false
            }
        }
    }
    
    func location(at index: Int) -> RMLocation? {
        guard index < locations.count, index >= 0 else {
            return nil
        }
        return self.locations[index]
    }
    
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
                // TODO: Handle error 
                break
            }
        }
    }
    
    private var hasMoreResults: Bool {
        return false
    }
}
