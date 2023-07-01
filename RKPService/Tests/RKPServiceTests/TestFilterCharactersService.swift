//
//  TestFilterCharactersService.swift
//  
//
//  Created by Tomas Martins on 30/06/23.
//

import XCTest
@testable import RKPService

final class TestFilterCharactersService: XCTestCase {
    let sut = MockFilterCharactersService()
    
    func testFilterCharactersService() async throws {
        let result = try await sut.search("Rick", status: .alive, page: 1)
        
        XCTAssertEqual(result.info.count, 29)
        XCTAssertEqual(result.info.pages, 2)
        XCTAssertEqual(result.info.next, "https://rickandmortyapi.com/api/character/?page=2&name=rick&status=alive")
        XCTAssertEqual(result.info.prev, nil)
        
        let character = try XCTUnwrap(result.results.first)
        XCTAssertEqual(character.id, 1)
        XCTAssertEqual(character.name, "Rick Sanchez")
        XCTAssertEqual(character.gender, .male)
        XCTAssertEqual(character.status, .alive)
        XCTAssertEqual(character.episode.count, 51)
        
        XCTAssertEqual(result.results.count, 20)
    }
    
    func testRequestError() async throws {
        do {
            _ = try await sut.search("Sanchez", status: .alive, page: 0)
            XCTFail("Service didn't throw an error")
        } catch let error {
            let networkingError = try XCTUnwrap(error as? RKPNetworkingError)
            XCTAssertEqual(networkingError, RKPNetworkingError.serviceError("Resource not found"))
        }
    }
}
