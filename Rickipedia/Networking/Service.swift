//
//  AllCharactersService.swift
//  Rickipedia
//
//  Created by Tomas Martins on 26/06/23.
//

import Foundation

protocol Service {
    var queries: [URLQueryItem] { get set }
}

extension Service {
    var url: URL? {
        var urlComponents = URLComponents(string: "\(NetworkingConstant.baseURL)/\(NetworkingConstant.characters)")
        urlComponents?.queryItems = queries
        return urlComponents?.url
    }
    
    func start() async throws -> QueryResponse {
        guard let url else {
            throw NetworkingError.badURL
        }
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
        let (data, _) = try await URLSession.shared.data(for: request)
        return try await parse(data)
    }
    
    func parse(_ data: Data) async throws -> QueryResponse {
        do {
            return try JSONDecoder().decode(QueryResponse.self, from: data)
        } catch let error {
            if let serviceError = try? JSONDecoder().decode(ErrorMessage.self, from: data) {
                throw NetworkingError.serviceError(serviceError.error)
            } else {
                throw error
            }
        }
    }
}
