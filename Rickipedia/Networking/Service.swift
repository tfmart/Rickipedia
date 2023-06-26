//
//  AllCharactersService.swift
//  Rickipedia
//
//  Created by Tomas Martins on 26/06/23.
//

import Foundation

protocol Service {
    associatedtype ResponseType: Decodable
    
    var queries: [URLQueryItem] { get set }
}

extension Service {
    var url: URL? {
        var urlComponents = URLComponents(string: "\(NetworkingConstants.baseURL)/\(NetworkingConstants.characters)")
        urlComponents?.queryItems = queries
        return urlComponents?.url
    }
    
    func start() async throws -> ResponseType {
        guard let url else {
            throw NetworkingError.badURL
        }
        var request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
        let (data, _) = try await URLSession.shared.data(for: request)
        return try await parse(data)
    }
    
    func parse(_ data: Data) async throws -> ResponseType {
        do {
            return try JSONDecoder().decode(ResponseType.self, from: data)
        } catch {
            let error = try JSONDecoder().decode(ErrorMessage.self, from: data)
            throw NetworkingError.serviceError(error.error)
        }
    }
}
