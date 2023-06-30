//
//  FilterService.swift
//  Rickipedia
//
//  Created by Tomas Martins on 30/06/23.
//

import Foundation
import RKPService

protocol FilterService {
    func search(_ query: String, status: CharacterStatus?, page: Int) async throws -> RKPQueryResponse
}

struct DefaultFilterService: FilterService {
    func search(_ query: String, status: CharacterStatus?, page: Int) async throws -> RKPQueryResponse {
        let service = RKPFilterCharactersService()
        var characterStatus: RKPCharacterStatus? {
            guard let status else { return nil }
            return RKPCharacterStatus(rawValue: status.rawValue)
        }
        return try await service.search(query, status: characterStatus, page: page)
    }
}
