//
//  CharacterListViewModel.swift
//  Rickipedia
//
//  Created by Tomas Martins on 26/06/23.
//

import Combine
import Foundation

final class CharactersListViewModel {
    let charactersService: CharactersService
    let filterService: FilterService
    let converter: CharacterConverter

    private var allCharacters: [Character] = []
    private var filteredCharacters: [Character] = []

    private var currentPage: Int = 1
    private var currentFilterPage: Int = 1

    var isSearching: Bool = false

    private var hasNextPage: Bool = true
    private var hasNextFilterPage: Bool = true
    var currentStateFilter: CharacterStatus?

    @Published private(set) var isLoading = false

    private var searchTimer: Timer?

    var characters: [Character] {
        return filteredCharacters.isEmpty ? allCharacters : filteredCharacters
    }

    init(charactersService: CharactersService = DefaultCharactersService(),
         filterService: FilterService = DefaultFilterService(),
         characterConverter: CharacterConverter = DefaultCharacterConverter()) {
        self.charactersService = charactersService
        self.filterService = filterService
        self.converter = characterConverter
    }
}

// MARK: Fetch all characteres

extension CharactersListViewModel {
    func fetchCharacters(page: Int, _ completion: @escaping (Result<Void, Error>) -> Void) {
        Task {
            do {
                let response = try await charactersService.fetch(page: page)
                let charactersToAppend = response.results.map { converter.convert(character: $0) }
                allCharacters.append(contentsOf: charactersToAppend)
                completion(.success(()))
            } catch {
                completion(.failure(error))
            }
        }
    }

    func fetchCharacters() async {
        guard !isLoading, hasNextPage else {
            return
        }

        isLoading = true

        do {
            let response = try await charactersService.fetch(page: currentPage)
            self.isLoading = false
            let charactersToAppend = response.results.map { converter.convert(character: $0) }
            allCharacters.append(contentsOf: charactersToAppend)
            guard let nextPage = charactersService.nextPage else {
                self.hasNextPage = false
                return
            }
            self.currentPage = nextPage
        } catch {
            // Handle error
            self.isLoading = false
        }
    }
}

// MARK: Seaching and filtering
extension CharactersListViewModel {
    func didUpdateSearchBar(_ query: String, _ completion: @escaping () -> Void) {
        searchTimer?.invalidate()

        guard !query.isEmpty else {
            self.filteredCharacters = []
            self.currentFilterPage = 1
            self.hasNextFilterPage = true
            completion()
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
        if currentStateFilter != status {
            currentStateFilter = status
            self.currentFilterPage = 1
            self.filteredCharacters = []
        } else {
            guard hasNextFilterPage else { return }
        }

        guard shouldPerformQuery(query, status: status) else {
            filteredCharacters = []
            currentFilterPage = 1
            self.isSearching = false
            return
        }
        do {
            self.isSearching = true
            self.isLoading = true
            let response = try await filterService.search(query,
                                                          status: status,
                                                          page: currentFilterPage)
            guard let nextPage = filterService.nextPage else {
                self.isLoading = false
                self.hasNextFilterPage = false
                return
            }
            self.isLoading = false
            self.currentFilterPage = nextPage
            self.filteredCharacters.append(contentsOf: response.results.map { converter.convert(character: $0) })
        } catch {
            // Handle error
            self.isLoading = false
        }
    }

    func shouldPerformQuery(_ query: String?, status: CharacterStatus?) -> Bool {
        guard let query else { return status != nil }
        return !(query.isEmpty && status == nil)
    }
}
