//
//  RMService.swift
//  RickAndMorty
//
//  Created by Cansu Kahraman on 2.10.2023.
//

import Foundation

final class RMService {
    
    static let shared = RMService()
    private init() {}
    
    func execute<T: Decodable>(
        _ request: RMRequest,
        expecting type: T.Type,
        completion: @escaping (Result<T, Error>) -> Void) {
            
            guard
                let urlRequest = self.request(from: request) else {
                completion(.failure(RMServiceError.failedToCreateRequest))
                return
            }
            
            let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard
                    let response = response as? HTTPURLResponse,
                    response.statusCode >= 200 && response.statusCode < 300 else {
                    completion(.failure(RMServiceError.invalidServiceResponse))
                    return
                }
                
                guard
                    let data = data else {
                    completion(.failure(RMServiceError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(type.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
            
            task.resume()
        }
    
    private func request(from rmRequest: RMRequest) -> URLRequest? {
        guard let url = rmRequest.url else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = rmRequest.httpMethod
        return request
    }
    
}
