//
//  FilterCharactersService.swift
//  Rickipedia
//
//  Created by Tomas Martins on 26/06/23.
//

import Foundation

class FilterCharactersService: Service {
    typealias ResponseType = QueryResponse
    var queries: [URLQueryItem]
    
    init(
        name: String?,
        status: CharacterStatus?
    ) {
        self.queries = [
            .init(parameter: .name, value: name),
            .init(parameter: .status, value: status?.rawValue)
        ]
    }
}
