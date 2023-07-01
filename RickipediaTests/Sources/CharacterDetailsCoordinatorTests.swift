//
//  CharacterDetailsCoordinatorTests.swift
//  RickipediaTests
//
//  Created by Tomas Martins on 01/07/23.
//

import XCTest
@testable import Rickipedia

class CharacterDetailsCoordinatorTests: XCTestCase {
    var navigationController: UINavigationController!
    var coordinator: CharacterDetailsCoordinator!

    override func setUp() {
        super.setUp()
        navigationController = UINavigationController()
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
        coordinator = CharacterDetailsCoordinator(navigationController: navigationController, character: character)
    }

    override func tearDown() {
        navigationController = nil
        coordinator = nil
        super.tearDown()
    }

    func testStart() {
        coordinator.start()
        XCTAssertTrue(navigationController.viewControllers.first is CharacterDetailsViewController)
    }
}
