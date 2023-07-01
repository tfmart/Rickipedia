//
//  MockAllCharactersService.swift
//  RickipediaTests
//
//  Created by Tomas Martins on 26/06/23.
//

import Foundation
import RKPService
@testable import Rickipedia

class MockCharactersService: CharactersService {
    var fetchCalled = false
    var nextPageValue: Int?

    func fetch(page: Int) async throws -> RKPQueryResponse {
        guard let pathString = Bundle(for: type(of: self)).path(forResource: "allCharactersMock", ofType: "json") else {
            fatalError("Could not find mock JSON file")
        }
        let jsonString = try String(contentsOfFile: pathString, encoding: .utf8)
        guard let jsonData = jsonString.data(using: .utf8) else {
            fatalError("Unable to convert mock JSON file to Data")
        }
        let jsonDictionary = try JSONDecoder().decode(RKPQueryResponse.self, from: jsonData)
        fetchCalled = true
        return jsonDictionary
    }

    func nextPage(response: RKPQueryResponse) -> Int? {
        guard let next = response.info.next,
              let nextURL = URLComponents(string: next),
              let pageQuery = nextURL.queryItems?.first(where: { $0.name == "page" }),
              let pageValue = pageQuery.value else { return nil }
        return Int(pageValue)
    }
}
