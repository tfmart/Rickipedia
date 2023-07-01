//
//  CharacterListViewModelTests.swift
//  RickipediaTests
//
//  Created by Tomas Martins on 26/06/23.
//

import XCTest
@testable import Rickipedia

class CharactersListViewModelTests: XCTestCase {
    var viewModel: CharactersListViewModel!
    var mockCharactersService: MockCharactersService!
    var mockFilterService: MockFilterService!
    var mockCharacterErrorHandler: MockCharacterErrorHandler!

    override func setUp() {
        super.setUp()
        mockCharactersService = MockCharactersService()
        mockFilterService = MockFilterService()
        mockCharacterErrorHandler = MockCharacterErrorHandler()

        viewModel = CharactersListViewModel(charactersService: mockCharactersService,
                                            filterService: mockFilterService,
                                            errorHandler: mockCharacterErrorHandler)
    }

    func testInitialState() {
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(viewModel.state, .loaded)
        XCTAssertTrue(viewModel.characters.isEmpty)
    }

    func testFetchCharacters() async {
        // Call fetchCharacters()
        await viewModel.fetchCharacters()

        // Test the service was called and the state is updated
        XCTAssertTrue(mockCharactersService.fetchCalled)
        XCTAssertEqual(viewModel.state, .loaded)

        // Test the state is updated after the fetch is completed
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(viewModel.state, .loaded)
        XCTAssertEqual(viewModel.currentPage, 2)
        XCTAssertEqual(viewModel.hasNextPage, true)

        // Clean up
        mockCharactersService.nextPageValue = nil
    }

    func testCharacterForId() async throws {
        // Add a dummy character to the view model
        await viewModel.fetchCharacters()
        let character = try XCTUnwrap(viewModel.characters.first)
        // Test retrieving the character by ID
        XCTAssertEqual(viewModel.character(for: 1), character)
        XCTAssertNil(viewModel.character(for: 21))
    }

    func testRetry() async {
        // Test retrying when not searching
        await viewModel.retry()
        XCTAssertTrue(mockCharactersService.fetchCalled)

        // Test retrying when searching
        viewModel.isSearching = true
        viewModel.currentStateFilter = .alive
        viewModel.currentSearchTerm = "Test"
        await viewModel.retry()
        XCTAssertTrue(mockFilterService.searchCalled)
    }

    func testDidUpdateSearchBar() {
        let completionExpectation = expectation(description: "Completion called")
        completionExpectation.isInverted = true
        viewModel.currentSearchTerm = "Test"
        viewModel.didUpdateSearchBar("Test") {
            completionExpectation.fulfill()
        }
        waitForExpectations(timeout: 0.1, handler: nil)
        XCTAssertFalse(mockFilterService.searchCalled)

        let searchExpectation = expectation(description: "Search called")
        viewModel.currentSearchTerm = "Test"
        viewModel.didUpdateSearchBar("New Query") {
            searchExpectation.fulfill()
        }
        waitForExpectations(timeout: 1.6, handler: nil)
        XCTAssertTrue(mockFilterService.searchCalled)

        let emptyQueryExpectation = expectation(description: "Empty Query")
        mockFilterService.searchCalled = false
        viewModel.didUpdateSearchBar("") {
            emptyQueryExpectation.fulfill()
        }
        XCTAssertFalse(viewModel.isSearching)
        XCTAssertEqual(viewModel.state, .loaded)
        waitForExpectations(timeout: 0.1, handler: nil)
        XCTAssertFalse(mockFilterService.searchCalled)
        XCTAssertTrue(viewModel.filteredCharacters.isEmpty)

        let emptyQueryWithFilterExpecation = expectation(description: "Empty Query With Filter")
        viewModel.currentStateFilter = .alive
        viewModel.didUpdateSearchBar("") {
            emptyQueryWithFilterExpecation.fulfill()
        }
        waitForExpectations(timeout: 0.1, handler: nil)
        XCTAssertTrue(mockFilterService.searchCalled)
        XCTAssertFalse(viewModel.filteredCharacters.isEmpty)
    }

    func testSearchCharacters() async {
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(viewModel.state, .loaded)
        XCTAssertTrue(viewModel.filteredCharacters.isEmpty)

        await viewModel.searchCharacters("Test", status: .alive)

        // Test the state is updated after the search is completed
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(viewModel.state, .loaded)

        // Set a next page value and call searchCharacters() again
        mockFilterService.nextPageValue = 2
        await viewModel.searchCharacters("Test", status: .alive)

        // Test the next page value is updated
        XCTAssertEqual(viewModel.currentFilterPage, 2)

        // Clean up
        mockFilterService.nextPageValue = nil
    }

    func testShouldPerformSearch() {
        XCTAssertFalse(viewModel.shouldPerformSearch(nil, status: nil))
        XCTAssertTrue(viewModel.shouldPerformSearch("Test", status: nil))
        XCTAssertTrue(viewModel.shouldPerformSearch("", status: .alive))
        XCTAssertTrue(viewModel.shouldPerformSearch("Test", status: .alive))
    }

    func testHandleError() {
        let error = NSError(domain: "TestErrorDomain", code: 0, userInfo: nil)
        viewModel.currentFilterPage = 1
        viewModel.handleError(error)
        XCTAssertEqual(viewModel.state, .empty(error))

        viewModel.currentFilterPage = 2
        viewModel.handleError(error)
        XCTAssertEqual(viewModel.state, .failedToLoadPage)
    }

    func testErrorMessage() {
        let error = NSError(domain: "TestErrorDomain", code: 0, userInfo: nil)
        let errorMessage = viewModel.errorMessage(for: error)
        XCTAssertEqual(errorMessage, "Error message")
    }

    func testShouldShowRetryButton() {
        let error = NSError(domain: "TestErrorDomain", code: 0, userInfo: nil)
        let shouldShowRetryButton = viewModel.shouldShowRetryButton(for: error)
        XCTAssertTrue(shouldShowRetryButton)
    }
}
