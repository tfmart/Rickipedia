//
//  MockAllCharactersService.swift
//  RickipediaTests
//
//  Created by Tomas Martins on 26/06/23.
//

import Foundation
@testable import Rickipedia

class MockAllCharactersService: AllCharactersServiceProtocol {
    var queries: [URLQueryItem] = []

    func fetch(page: Int) async throws -> QueryResponse {
        guard let pathString = Bundle(for: type(of: self)).path(forResource: "allCharactersMock", ofType: "json") else {
            fatalError("Could not find mock JSON file")
        }
        let jsonString = try String(contentsOfFile: pathString, encoding: .utf8)
        guard let jsonData = jsonString.data(using: .utf8) else {
            fatalError("Unable to convert mock JSON file to Data")
        }
        let jsonDictionary = try JSONDecoder().decode(QueryResponse.self, from: jsonData)
        return jsonDictionary
    }
}
