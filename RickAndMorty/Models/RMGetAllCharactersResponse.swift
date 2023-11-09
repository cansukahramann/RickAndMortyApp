//
//  RMGetAllCharactersResponse.swift
//  RickAndMorty
//
//  Created by Cansu Kahraman on 6.10.2023.
//

import Foundation

struct RMGetAllCharactersResponse: Decodable {
    let info: Info
    let results: [RMCharacter]
    
    struct Info: Decodable {
        let count: Int
        let pages: Int
        let next: String?
        let prev: String?
    }
}
