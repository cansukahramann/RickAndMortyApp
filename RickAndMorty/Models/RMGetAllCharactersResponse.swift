//
//  RMGetAllCharactersResponse.swift
//  RickAndMorty
//
//  Created by Cansu Kahraman on 6.10.2023.
//

import Foundation

struct RMGetAllCharactersResponse: Codable{
    let info: Info
    let results: [RMCharacter]
    
    struct Info: Codable {
        let count: Int
        let pages: Int
        let next: String?
        let prev: String?
    }
}
