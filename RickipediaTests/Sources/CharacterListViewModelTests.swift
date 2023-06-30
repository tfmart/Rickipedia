//
//  CharacterListViewModelTests.swift
//  RickipediaTests
//
//  Created by Tomas Martins on 26/06/23.
//

import XCTest
@testable import Rickipedia

final class CharacterListViewModelTests: XCTestCase {
    func testFetchingFirstPage() async throws {
        let viewModel = CharactersListViewModel(charactersService: MockAllCharactersService())
        XCTAssertEqual(viewModel.currentPage, 1)
        XCTAssertTrue(viewModel.characters.isEmpty)
        await viewModel.fetchCharacters()
        XCTAssertFalse(viewModel.characters.isEmpty)
        XCTAssertEqual(viewModel.currentPage, 2)
    }
}
