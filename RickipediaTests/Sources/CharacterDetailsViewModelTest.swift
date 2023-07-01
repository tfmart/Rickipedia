//
//  CharacterDetailsViewModelTest.swift
//  RickipediaTests
//
//  Created by Tomas Martins on 01/07/23.
//

import XCTest
@testable import Rickipedia

class CharacterDetailsViewModelTests: XCTestCase {
    func testGetCharacterDetails() {
        let character = Character(id: 1,
                                  name: "Rick Sanchez",
                                  status: .alive,
                                  type: "Scientist",
                                  species: "Human",
                                  gender: .male,
                                  origin: "Earth",
                                  location: "Earth",
                                  imageURL: nil,
                                  episodesCount: 41)
        let viewModel = CharacterDetailsViewModel(character: character)

        let details = viewModel.getCharacterDetails()

        XCTAssertEqual(details.count, 7)
        XCTAssertEqual(details[0].title, "Status")
        XCTAssertEqual(details[0].value, "Alive")
        XCTAssertEqual(details[1].title, "Species")
        XCTAssertEqual(details[1].value, "Human")
        XCTAssertEqual(details[2].title, "Type")
        XCTAssertEqual(details[2].value, "Scientist")
        XCTAssertEqual(details[3].title, "Gender")
        XCTAssertEqual(details[3].value, "Male")
        XCTAssertEqual(details[4].title, "Origin")
        XCTAssertEqual(details[4].value, "Earth")
        XCTAssertEqual(details[5].title, "Location")
        XCTAssertEqual(details[5].value, "Earth")
        XCTAssertEqual(details[6].title, "Episode Count")
        XCTAssertEqual(details[6].value, "41")
    }
}
