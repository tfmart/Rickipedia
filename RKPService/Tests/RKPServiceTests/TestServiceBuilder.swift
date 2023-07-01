//
//  TestServiceBuilder.swift
//  
//
//  Created by Tomas Martins on 30/06/23.
//

import XCTest
@testable import RKPService

final class TestServiceBuilder: XCTestCase {
    func testService() {
        let serviceQueries: [URLQueryItem] = [
            .init(name: "page", value: "1"),
            .init(name: "name", value: "John"),
            .init(name: "gender", value: "female")
        ]
        
        let mock = MockGenericService(queries: serviceQueries)
        
        XCTAssertNotNil(mock.url)
        XCTAssertEqual(mock.url?.pathComponents.count, 3)
        XCTAssertEqual(mock.url?.absoluteString, "https://rickandmortyapi.com/api/character?page=1&name=John&gender=female")
    }
}
