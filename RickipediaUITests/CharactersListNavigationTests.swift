//
//  CharactersListNavigationTests.swift
//  RickipediaUITests
//
//  Created by Tomas Martins on 26/06/23.
//

import XCTest

class CharactersListNavigationTests: XCTestCase {
    var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func testNavigateToCharacterDetails() {
        let characterName = "Rick Sanchez"
        let species = "Human"

        let listCollectionView = app.collectionViews.firstMatch
        XCTAssertTrue(listCollectionView.waitForExistence(timeout: 5))

        let characterCell = listCollectionView.cells.containing(.staticText, identifier: characterName).element
        XCTAssertTrue(characterCell.waitForExistence(timeout: 5))
        characterCell.tap()

        let detailsCollectionView = app.collectionViews.firstMatch
        XCTAssertTrue(detailsCollectionView.waitForExistence(timeout: 5))
        let speciesCell = detailsCollectionView.cells.containing(.staticText, identifier: species).element
        XCTAssertTrue(speciesCell.waitForExistence(timeout: 5))
    }

    func testSearch() {
        let character = "Armothy"
        let status = "Dead"

        let listCollectionView = app.collectionViews.firstMatch
        XCTAssertTrue(listCollectionView.waitForExistence(timeout: 5))

        let searchBar = app.searchFields.firstMatch
        XCTAssertTrue(searchBar.waitForExistence(timeout: 5))
        searchBar.tap()
        app.typeText(character)

        let characterCell = listCollectionView.cells.containing(.staticText, identifier: character).element
        XCTAssertTrue(characterCell.waitForExistence(timeout: 5))
        characterCell.tap()

        let detailsCollectionView = app.collectionViews.firstMatch
        XCTAssertTrue(detailsCollectionView.waitForExistence(timeout: 5))
        let speciesCell = detailsCollectionView.cells.containing(.staticText, identifier: status).element
        XCTAssertTrue(speciesCell.waitForExistence(timeout: 5))
    }
}
