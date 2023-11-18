//
//  RMSearchViewViewModel.swift
//  RickAndMorty
//
//  Created by Cansu Kahraman on 15.11.2023.
//

import Foundation

final class RMSearchViewViewModel {
    
    let config: RMSearchViewController.Config
    
    private var optionMap: [RMSearchInputViewViewModel.DynamicOptions: String] = [:]
    
    private var searchText = ""
    
    private var optionMapUpdateBlock: (((RMSearchInputViewViewModel.DynamicOptions, String))->Void)?
    
    init(config: RMSearchViewController.Config) {
        self.config = config
    }
    
    func executeSearch() {
         
    }
    
    func set(query text: String) {
        self.searchText = text
    }
    
    func set (value: String, for option : RMSearchInputViewViewModel.DynamicOptions) {
        optionMap[option] = value
        let tuple = (option, value)
        optionMapUpdateBlock?(tuple)
    }
    
    func registerOptionChangeBlock (_ block: @escaping((RMSearchInputViewViewModel.DynamicOptions, String))->Void) {
        self.optionMapUpdateBlock = block
    }
    
    
}
