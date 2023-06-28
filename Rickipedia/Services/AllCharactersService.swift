//
//  AllCharactersService.swift
//  Rickipedia
//
//  Created by Tomas Martins on 26/06/23.
//

import Foundation

protocol AllCharactersServiceProtocol: Service {
    func fetch(page: Int) async throws -> QueryResponse
}

class AllCharactersService: AllCharactersServiceProtocol {
    var queries: [URLQueryItem] = []
    
    func fetch(page: Int) async throws -> QueryResponse {
        self.queries = [
            .init(parameter: .page, numericValue: page)
        ]
        return try await self.start()
    }
}
