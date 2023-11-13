//
//  RMGetAllLocationsResponse.swift
//  RickAndMorty
//
//  Created by Cansu Kahraman on 10.11.2023.
//

import Foundation

struct RMGetAllLocationsResponse: Decodable {
    let info: Info
    let results: [RMLocation]
    
    struct Info: Decodable {
        let count: Int
        let pages: Int
        let next: String?
        let prev: String?
    }
}
