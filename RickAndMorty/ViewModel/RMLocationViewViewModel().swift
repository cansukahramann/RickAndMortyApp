//
//  RMLocationViewViewModel().swift
//  RickAndMorty
//
//  Created by Cansu Kahraman on 9.11.2023.
//

import Foundation

final class RMLocationViewViewModel {
    
    private var locations: [RMLocation] = []
    
    //Location response info
    //Will content next url, if present
    
    private var cellViewModels: [String] = []
    
    init() { }
    
     func fetchLocations() {
         RMService.shared.execute(.listLocaitonsRequest, expecting: String.self) { result in
             switch result {
             case .success(let model):
                 break
             case .failure(let error):
                 break
             }
         }
       
        
    }
    
    private var hasMoreResults: Bool {
        return false
    }
}
