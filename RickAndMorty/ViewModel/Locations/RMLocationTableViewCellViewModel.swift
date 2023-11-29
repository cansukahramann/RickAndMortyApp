//
//  RMLocationTableViewCellViewModel.swift
//  RickAndMorty
//
//  Created by Cansu Kahraman on 13.11.2023.
//

import Foundation

// hashble equatable'ı conform ediyor, yazmaya gerek yok
struct RMLocationTableViewCellViewModel: Hashable, Equatable {
    
    private let location: RMLocation
    
    init(location: RMLocation) {
        self.location = location
    }
    
    var name: String {
        return location.name
    }
    
    var type: String {
        return "Type: "+location.type
    }
    
    var dimension: String {
        return location.dimension
    }
    
    static func == (lhs: RMLocationTableViewCellViewModel, rhs: RMLocationTableViewCellViewModel) -> Bool {
        return lhs.location.id == rhs.location.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(location.id)
        hasher.combine(dimension)
        hasher.combine(type)
    }
}
