//
//  RMServiceError.swift
//  RickAndMorty
//
//  Created by Cansu Kahraman on 6.10.2023.
//

import Foundation

enum RMServiceError: Error {
    case failedToCreateRequest
    case failedToGetData
    case invalidServiceResponse
}
