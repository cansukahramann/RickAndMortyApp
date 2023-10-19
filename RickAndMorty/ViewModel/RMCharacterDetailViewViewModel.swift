//
//  RMCharacterDetailViewViewModel.swift
//  RickAndMorty
//
//  Created by Cansu Kahraman on 10.10.2023.
//

import Foundation

final class RMCharacterDetailViewViewModel{
    
    private var character: RMCharacter
    
    init(character: RMCharacter){
        self.character = character
    }
    
    var title: String{
        character.name.uppercased()
    }
}
