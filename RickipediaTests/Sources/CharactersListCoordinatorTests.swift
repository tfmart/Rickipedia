//
//  CharactersListCoordinatorTests.swift
//  RickipediaTests
//
//  Created by Tomas Martins on 01/07/23.
//

import XCTest
@testable import Rickipedia

class CharactersListCoordinatorTests: XCTestCase {
    var navigationController: UINavigationController!
    var coordinator: CharactersListCoordinator!

    override func setUp() {
        super.setUp()
        navigationController = UINavigationController()
        coordinator = CharactersListCoordinator(navigationController: navigationController)
    }

    override func tearDown() {
        navigationController = nil
        coordinator = nil
        super.tearDown()
    }

    func testStart() {
        coordinator.start()
        XCTAssertEqual(navigationController.viewControllers.count, 1)
        XCTAssertTrue(navigationController.viewControllers.first is CharactersListViewController)
    }

    func testShowCharacterDetails() {
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

        coordinator.showCharacterDetails(character)
        XCTAssertTrue(navigationController.viewControllers.last is CharacterDetailsViewController)
    }
}
