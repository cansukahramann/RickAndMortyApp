//
//  GetAllEpisodesResponse.swift
//  RickAndMorty
//
//  Created by Cansu Kahraman on 30.10.2023.
//

import Foundation

struct RMGetAllEpisodesResponse: Decodable {
    let info: Info
    let results: [RMEpisode]
    
    struct Info: Decodable {
        let count: Int
        let pages: Int
        let next: String?
        let prev: String?
    }
}
