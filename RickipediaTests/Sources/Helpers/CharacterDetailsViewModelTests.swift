//
//  CharacterDetailsViewModelTests.swift
//  RickipediaTests
//
//  Created by Tomas Martins on 29/06/23.
//

import XCTest
@testable import Rickipedia

class CharacterDetailsViewModelTests: XCTestCase {
    func testCharacterDetailsViewModel() {
        let character = Character(id: 1, name: "Test Character",
                                  status: .alive,
                                  species: "Human",
                                  type: "",
                                  gender: .male,
                                  origin: Location(name: "Earth", url: ""),
                                  location: Location(name: "Mars", url: ""),
                                  image: "",
                                  episode: [],
                                  url: "",
                                  created: "")
        let viewModel = CharacterDetailsViewModel(character: character)
        
        XCTAssertEqual(viewModel.getCharacterDetails().count, 7)
        XCTAssertEqual(viewModel.getCharacterDetails()[0].title, "Status")
        XCTAssertEqual(viewModel.getCharacterDetails()[0].value, "Alive")
    }
}
