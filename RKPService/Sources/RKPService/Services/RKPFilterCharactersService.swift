//
//  File.swift
//  
//
//  Created by Tomas Martins on 30/06/23.
//

import Foundation

public protocol RKPFilterCharactersServiceProtocol: Service {
    func search(_ query: String?, status: RKPCharacterStatus?, page: Int) async throws -> RKPQueryResponse
}

public class RKPFilterCharactersService: RKPFilterCharactersServiceProtocol {
    public var queries: [URLQueryItem] = []
    
    public init() {}
    
    public func search(_ query: String?, status: RKPCharacterStatus?, page: Int) async throws -> RKPQueryResponse {
        self.queries = [
            .init(parameter: .name, value: query),
            .init(parameter: .status, value: status?.rawValue),
            .init(parameter: .page, numericValue: page)
        ]
        return try await start()
    }
}
