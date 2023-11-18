//
//  RMSearchInputViewViewModel.swift
//  RickAndMorty
//
//  Created by Cansu Kahraman on 15.11.2023.
//

import Foundation

final class RMSearchInputViewViewModel {
    
    private let type: RMSearchViewController.Config.`Type`
    
    enum DynamicOptions: String {
        case status = "Status"
        case gender = "Gender"
        case locationType = "Location Type"
        
        var choices: [String] {
            switch self {
            case .status:
                return ["alive", "dead", "unknown"]
            case.gender:
                return ["female", "male", "genderless","unknown"]
            case.locationType:
                return ["cluster", "planet", "microverse"]
            }
    }
}
    
    
    init(type: RMSearchViewController.Config.`Type`) {
        self.type = type
    }
    
    public var hasDynamicOpstions: Bool {
        switch self.type {
        case.character, .location:
            return true
        case.episode:
            return false
        }
    }
    
    public var options: [DynamicOptions] {
        switch self.type {
        case.character:
            return [.status, .gender]
        case .location:
            return [.locationType]
        case.episode:
            return []
        }
    }
    
    public var searchPlaceHolderText: String {
        switch self .type {
        case .character:
            return "Character Name"
        case.location:
            return "Location Name"
        case .episode:
            return "Episode Title"
        }
    }
}
