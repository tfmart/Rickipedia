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
    var nextPage: Int? { get }
}

class DefaultCharactersService: CharactersService {
    var currentResponse: RKPQueryResponse?

    func fetch(page: Int) async throws -> RKPQueryResponse {
        let service = RKPAllCharactersService()
        let response = try await service.fetch(page: page)
        self.currentResponse = response
        return response
    }

    var nextPage: Int? {
        guard let currentResponse,
              let next = currentResponse.info.next,
              let nextURL = URLComponents(string: next),
              let pageQuery =  nextURL.queryItems?.first(where: {
                  $0.name == "page"
              }),
              let pageValue = pageQuery.value else { return nil }
        return Int(pageValue)
    }
}
