//
//  FilterCharactersService.swift
//  Rickipedia
//
//  Created by Tomas Martins on 26/06/23.
//

import Foundation

protocol FilterCharactersServiceProtocol: Service {
    func search(_ query: String?, status: CharacterStatus?) async throws -> QueryResponse
}

class FilterCharactersService: FilterCharactersServiceProtocol {
    var queries: [URLQueryItem] = []
    
    func search(_ query: String?, status: CharacterStatus?) async throws -> QueryResponse {
        self.queries = [
            .init(parameter: .name, value: query),
            .init(parameter: .status, value: status?.rawValue)
        ]
        return try await start()
    }
}
