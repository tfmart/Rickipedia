//
//  FilterService.swift
//  Rickipedia
//
//  Created by Tomas Martins on 30/06/23.
//

import Foundation
import RKPService

protocol FilterService {
    func search(_ query: String?, status: CharacterStatus?, page: Int) async throws -> RKPQueryResponse
    func nextPage(response: RKPQueryResponse) -> Int?
}

class DefaultFilterService: FilterService {
    func search(_ query: String?, status: CharacterStatus?, page: Int) async throws -> RKPQueryResponse {
        let service = RKPFilterCharactersService()
        var characterStatus: RKPCharacterStatus? {
            guard let status = status else { return nil }
            return RKPCharacterStatus(rawValue: status.rawValue)
        }
        let response = try await service.search(query, status: characterStatus, page: page)
        return response
    }

    func nextPage(response: RKPQueryResponse) -> Int? {
        guard let next = response.info.next,
              let nextURL = URLComponents(string: next),
              let pageQuery = nextURL.queryItems?.first(where: { $0.name == "page" }),
              let pageValue = pageQuery.value else { return nil }
        return Int(pageValue)
    }
}
