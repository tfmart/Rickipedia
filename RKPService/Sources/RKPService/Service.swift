//
//  AllCharactersService.swift
//  RKPService
//
//  Created by Tomas Martins on 26/06/23.
//

import Foundation

public protocol Service {
    var queries: [URLQueryItem] { get set }
}

extension Service {
    var url: URL? {
        var urlComponents = URLComponents(string: "\(NetworkingConstant.baseURL)/\(NetworkingConstant.characters)")
        urlComponents?.queryItems = queries
        return urlComponents?.url
    }
    
    func start() async throws -> RKPQueryResponse {
        guard let url else {
            throw RKPNetworkingError.badURL
        }
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
        let (data, _) = try await URLSession.shared.data(for: request)
        return try await parse(data)
    }
    
    func parse(_ data: Data) async throws -> RKPQueryResponse {
        do {
            return try JSONDecoder().decode(RKPQueryResponse.self, from: data)
        } catch let error {
            if let serviceError = try? JSONDecoder().decode(RKPErrorMessage.self, from: data) {
                throw RKPNetworkingError.serviceError(serviceError.error)
            } else {
                throw error
            }
        }
    }
}

