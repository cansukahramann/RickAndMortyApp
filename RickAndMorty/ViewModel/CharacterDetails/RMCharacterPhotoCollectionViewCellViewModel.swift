//
//  RMCharacterPhotoCollectionViewCellViewModel.swift
//  RickAndMorty
//
//  Created by Cansu Kahraman on 23.10.2023.
//

import UIKit

final class RMCharacterPhotoCollectionViewCellViewModel{
    
    private let imageUrl: URL?
   
    init(imageUrl: URL?){
        self.imageUrl = imageUrl
    }
    
    func fetchImage(completion: @escaping(Result <Data,Error>) -> Void){
        
        guard let imageUrl = imageUrl else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        RMImageLoader.shared.downloadImage(imageUrl, completion: completion)
    }
}
