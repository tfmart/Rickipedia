//
//  CharacterListViewModel.swift
//  Rickipedia
//
//  Created by Tomas Martins on 26/06/23.
//

import Combine
import Foundation

final class CharactersListViewModel {
    // Dependencies
    let charactersService: CharactersService
    let filterService: FilterService
    let converter: CharacterConverter
    let errorHandler: CharacterErrorHandler

    // Character lists
    private var allCharacters: [Character] = []
    private var filteredCharacters: [Character] = []

    var characters: [Character] {
        if filteredCharacters.isEmpty {
            return isSearching ? [] : allCharacters
        } else {
            return filteredCharacters
        }
    }

    // Pages
    private var currentPage: Int = 1
    private var hasNextPage: Bool = true
    private var currentFilterPage: Int = 1
    private var hasNextFilterPage: Bool = true

    // Search and filters
    var currentStateFilter: CharacterStatus?
    var currentSearchTerm: String?
    private var searchTimer: Timer?
    var isSearching: Bool = false

    // State
    @Published private(set) var state: CharactersListState = .loaded

    var isLoading: Bool {
        switch state {
        case .loading: return true
        default: return false
        }
    }

    var isShowingFooter: Bool {
        switch state {
        case .failedToLoadPage: return true
        default: return false
        }
    }

    init(charactersService: CharactersService = DefaultCharactersService(),
         filterService: FilterService = DefaultFilterService(),
         characterConverter: CharacterConverter = DefaultCharacterConverter(),
         errorHandler: CharacterErrorHandler = DefaultCharacterErrorHandler()) {
        self.charactersService = charactersService
        self.filterService = filterService
        self.converter = characterConverter
        self.errorHandler = errorHandler
    }
}

// MARK: Fetch all characteres
extension CharactersListViewModel {
    func fetchCharacters() async {
        guard !isLoading, hasNextPage else {
            return
        }
        state = .loading
        do {
            let response = try await charactersService.fetch(page: currentPage)
            let charactersToAppend = response.results.map { converter.convert(character: $0) }
            allCharacters.append(contentsOf: charactersToAppend)
            if let nextPage = charactersService.nextPage(response: response) {
                currentPage = nextPage
            } else {
                hasNextPage = false
            }
        } catch {
            handleError(error)
        }
        state = .loaded
    }

    func character(for id: Int) -> Character? {
        if isSearching {
            return filteredCharacters.first(where: { $0.id == id })
        } else {
            return allCharacters.first(where: { $0.id == id })
        }
    }

    func retry() async {
        if isSearching {
            await searchCharacters(currentSearchTerm, status: currentStateFilter)
        } else {
            await fetchCharacters()
        }
    }
}

// MARK: Seaching and filtering
extension CharactersListViewModel {
    func didUpdateSearchBar(_ query: String, _ completion: @escaping () -> Void) {
        guard query != currentSearchTerm else { return }
        searchTimer?.invalidate()
        self.currentFilterPage = 1
        self.hasNextFilterPage = true

        guard !query.isEmpty else {
            self.isSearching = currentStateFilter != nil
            self.state = .loaded
            currentSearchTerm = nil
            if !isSearching {
                self.filteredCharacters = []
                completion()
            } else {
                Task {
                    await self.searchCharacters("", status: currentStateFilter)
                    completion()
                }
            }
            return
        }

        searchTimer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { [weak self] _ in
            guard let self else { return }
            Task {
                await self.searchCharacters(query, status: self.currentStateFilter)
                completion()
            }
        }
    }

    func searchCharacters(_ query: String?, status: CharacterStatus?) async {
        guard !isLoading else { return }

        if currentStateFilter == status, currentSearchTerm == query {
            guard hasNextFilterPage else { return }
        } else {
            currentStateFilter = status
            currentSearchTerm = query
            self.currentFilterPage = 1
            self.filteredCharacters = []
            self.state = .loaded
        }

        guard shouldPerformSearch(query, status: status) else {
            filteredCharacters = []
            currentFilterPage = 1
            self.isSearching = false
            self.state = .loaded
            return
        }
        do {
            self.isSearching = true
            self.state = .loading
            let response = try await filterService.search(query,
                                                          status: status,
                                                          page: currentFilterPage)
            self.state = .loaded
            self.filteredCharacters.append(contentsOf: response.results.map { converter.convert(character: $0) })
            guard let nextPage = filterService.nextPage(response: response) else {
                self.hasNextFilterPage = false
                return
            }
            self.currentFilterPage = nextPage
        } catch {
            if currentFilterPage == 1 {
                self.state = .empty(error)
            } else {
                self.state = .failedToLoadPage
            }
        }
    }

    func shouldPerformSearch(_ query: String?, status: CharacterStatus?) -> Bool {
        guard let query else { return status != nil }
        return !(query.isEmpty && status == nil)
    }
}

// MARK: - Error Handling
extension CharactersListViewModel {
    private func handleError(_ error: Error) {
        if currentFilterPage == 1 {
            state = .empty(error)
        } else {
            state = .failedToLoadPage
        }
    }
    
    func errorMessage(for error: Error) -> String {
        return errorHandler.message(for: error)
    }

    func shouldShowRetryButton(for error: Error) -> Bool {
        return errorHandler.shouldShowRetry(for: error)
    }
}
