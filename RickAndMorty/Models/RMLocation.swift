//
//  RMLocation.swift
//  RickAndMorty
//
//  Created by Cansu Kahraman on 28.09.2023.
//

import Foundation

struct RMLocation: Codable{
    let id: Int
    let name: String
    let type: String
    let dimension: String
    let residents:[String]
    let url: String
    let created: String
}
