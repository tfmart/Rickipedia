//
//  MockFilterCharactersService.swift
//  
//
//  Created by Tomas Martins on 30/06/23.
//

import Foundation
@testable import RKPService

class MockFilterCharactersService: RKPFilterCharactersServiceProtocol, MockServiceProtocol {
    var queries: [URLQueryItem] = []

    func search(_ query: String?, status: RKPCharacterStatus?, page: Int) async throws -> RKPQueryResponse {
        guard page > 0 else {
            throw try failRequest()
        }

        guard let pathString = Bundle.module.path(forResource: "filterCharactersMock", ofType: "json") else {
            fatalError("Could not find mock JSON file")
        }
        let jsonString = try String(contentsOfFile: pathString, encoding: .utf8)
        guard let jsonData = jsonString.data(using: .utf8) else {
            fatalError("Unable to convert mock JSON file to Data")
        }
        let jsonDictionary = try JSONDecoder().decode(RKPQueryResponse.self, from: jsonData)
        return jsonDictionary
    }
}
