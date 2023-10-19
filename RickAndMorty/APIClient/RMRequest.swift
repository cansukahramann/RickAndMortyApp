//
//  File.swift
//  RickAndMorty
//
//  Created by Cansu Kahraman on 2.10.2023.
//

import Foundation

//extension String {
//    var asURL: URL? {
//        URL(string: self)
//    }
//}

/// Bu class bize bir URL hazırlar.
final class RMRequest{
    
    private struct Constants {
        static let baseUrl =  "https://rickandmortyapi.com/api"
    }
    
    private let endpoint: RMEndpoint
    private let pathComponent: [String]
    private let queryParameters: [URLQueryItem]

    private var urlString: String {
        var string = Constants.baseUrl
        string += "/"
        string += endpoint.rawValue
        
        if !pathComponent.isEmpty{
            pathComponent.forEach {
                string += "/\($0)"
            }
        }
        
        if !queryParameters.isEmpty {
            string += "?"
            
            let queryString = queryParameters.compactMap { queryItem  in
                guard let value = queryItem.value else { return nil }
                return "\(queryItem.name)=\(value)"
            }.joined(separator: "&")
            
            string += queryString
        }
        return string
    }
        
        var url: URL? {
            URL(string: urlString)
        }
        
        let httpMethod = "GET"
        
        init(
             endpoint: RMEndpoint,
             pathComponent: [String] = [] ,
             queryParameters: [URLQueryItem] = [] )
        {
            self.endpoint = endpoint
            self.pathComponent = pathComponent
            self.queryParameters = queryParameters
            
        }
        convenience init?(url: URL){
            let string = url.absoluteString
            if  !string.contains(Constants.baseUrl){
                return nil
            }
            let trimmed = string.replacingOccurrences(of: Constants.baseUrl+"/", with: "")
            if trimmed.contains("/"){
                let components = trimmed.components(separatedBy: "/")
                if !components.isEmpty{
                    let endpointString = components[0]
                    if let rmEndpoint = RMEndpoint(rawValue: endpointString){
                        self.init(endpoint: rmEndpoint)
                        return
                    }
                }
            } else if trimmed.contains("?"){
                let components = trimmed.components(separatedBy: "?")
                if !components.isEmpty, components.count >= 2 {
                    let endpointString = components[0]
                    let queryItemsString = components[1]
                    
                    let queryItem: [URLQueryItem] = queryItemsString.components(separatedBy: "&").compactMap ({
                        guard $0.contains("=") else {
                            return nil
                        }
                        let parts = $0.components(separatedBy: "=")
                        
                        return URLQueryItem(name: parts[0], value: parts[1])
                    })
                    
                    
                    
                    if let rmEndpoint = RMEndpoint(rawValue: endpointString){
                        self.init(endpoint: rmEndpoint, queryParameters: queryItem)
                        return
                    }
                }
            }
            return nil
        } 
}

extension RMRequest {
    static let listCharactersRequest = RMRequest(endpoint: .character)
}
