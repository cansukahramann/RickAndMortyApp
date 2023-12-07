//
//  RMSettingsCellViewModel.swift
//  RickAndMorty
//
//  Created by Cansu Kahraman on 3.11.2023.
//

import  UIKit

struct RMSettingsCellViewModel: Identifiable {
    let id = UUID()
    
    let type: RMSettingsOption
    let onTapHandler: (RMSettingsOption) -> Void
    
    init(type: RMSettingsOption, onTapHandler: @escaping(RMSettingsOption) -> Void) {
        self.type = type
        self.onTapHandler = onTapHandler
    }
    var image: UIImage? {
        return type.iconImage
    }
    var title: String {
        return type.displayTitle
    }
    
    var iconContainerColor: UIColor {
        return type.iconContainerColor
    }
}
