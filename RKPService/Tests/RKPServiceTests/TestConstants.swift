//
//  TestConstants.swift
//  
//
//  Created by Tomas Martins on 30/06/23.
//

import XCTest
@testable import RKPService

final class TestConstants: XCTestCase {
    
    func testNetworkingConstants() {
        XCTAssertEqual(NetworkingConstant.baseURL, "https://rickandmortyapi.com/api")
        XCTAssertEqual(NetworkingConstant.characters, "character")
    }
    
    func testRawValues() {
        XCTAssertEqual(RKPCharacterGender.female.rawValue, "Female")
        XCTAssertEqual(RKPCharacterGender.male.rawValue, "Male")
        XCTAssertEqual(RKPCharacterGender.genderless.rawValue, "Genderless")
        XCTAssertEqual(RKPCharacterGender.unknown.rawValue, "unknown")
        
        XCTAssertEqual(RKPCharacterStatus.alive.rawValue, "Alive")
        XCTAssertEqual(RKPCharacterStatus.dead.rawValue, "Dead")
        XCTAssertEqual(RKPCharacterStatus.unknown.rawValue, "unknown")
    }
    
    func testNetworkingParameters() {
        XCTAssertEqual(RKPNetworkingParameter.name.rawValue, "name")
        XCTAssertEqual(RKPNetworkingParameter.page.rawValue, "page")
        XCTAssertEqual(RKPNetworkingParameter.status.rawValue, "status")
    }
    
}
