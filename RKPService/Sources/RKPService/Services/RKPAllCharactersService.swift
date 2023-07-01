//
//  File.swift
//  
//
//  Created by Tomas Martins on 30/06/23.
//

import Foundation

public protocol RKPAllCharactersServiceProtocol: Service {
    func fetch(page: Int) async throws -> RKPQueryResponse
}

public class RKPAllCharactersService: RKPAllCharactersServiceProtocol {
    public var queries: [URLQueryItem] = []
    
    public init() {}
    
    public func fetch(page: Int) async throws -> RKPQueryResponse {
        self.queries = [
            .init(parameter: .page, numericValue: page)
        ]
        return try await self.start()
    }
}
