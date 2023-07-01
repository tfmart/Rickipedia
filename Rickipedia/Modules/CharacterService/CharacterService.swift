//
//  CharacterService.swift
//  Rickipedia
//
//  Created by Tomas Martins on 30/06/23.
//

import Foundation
import RKPService

protocol CharactersService {
    func fetch(page: Int) async throws -> RKPQueryResponse
    func nextPage(response: RKPQueryResponse) -> Int?
}

class DefaultCharactersService: CharactersService {
    func fetch(page: Int) async throws -> RKPQueryResponse {
        let service = RKPAllCharactersService()
        let response = try await service.fetch(page: page)
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
