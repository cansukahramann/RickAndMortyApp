//
//  RMImageLoader.swift
//  RickAndMorty
//
//  Created by Cansu Kahraman on 19.10.2023.
//

import Foundation


final class RMImageLoader{
    static let shared = RMImageLoader()
    
    private init() {}
    
    private var imageDataCache = NSCache<NSString, NSData>()
    
    ///Get image content url
    /// Parameters:
    ///  - url: Source url
    ///  - completion: Callback
    
    func downloadImage(_ url: URL, completion: @escaping (Result<Data, Error>) -> Void){
        
        let key = url.absoluteString as NSString
        if let data = imageDataCache.object(forKey: key){
            print("Reading from cache: \(key)")
            completion(.success(data as Data)) //NSData == Data | NSString == String
            return
        }
        
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard
                let response = response as? HTTPURLResponse,
                response.statusCode >= 200 && response.statusCode < 300 else {
                completion(.failure(URLError(.badServerResponse)))
                return
            }
            guard let data = data else {
                completion(.failure(RMServiceError.failedToGetData))
                return
            }
            let value = data as NSData
            self?.imageDataCache.setObject(value, forKey: key)
            completion(.success(data))
        }
        task.resume()
    }
}
