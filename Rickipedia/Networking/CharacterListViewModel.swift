//
//  CharacterListViewModel.swift
//  Rickipedia
//
//  Created by Tomas Martins on 26/06/23.
//

import Foundation

final class CharactersListViewModel {
    let charactersService: AllCharactersServiceProtocol
    let filterService: FilterCharactersServiceProtocol
    
    private var allCharacters: [Character] = []
    private var filteredCharacters: [Character] = []
    var currentPage: Int = 1
    
    var isLoading: Bool = false
    var hasNextPage: Bool = true
    var currentStateFilter: CharacterStatus? = nil
    
    private var searchTimer: Timer?
    
    var characters: [Character] {
        return filteredCharacters.isEmpty ? allCharacters : filteredCharacters
    }
    
    init(charactersService: AllCharactersServiceProtocol = AllCharactersService(),
         filterService: FilterCharactersServiceProtocol = FilterCharactersService()) {
        self.charactersService = charactersService
        self.filterService = filterService
    }
    
    func fetchCharacters(page: Int, _ completion: @escaping (Result<Void, Error>) -> Void) {
        Task {
            do {
                let response = try await charactersService.fetch(page: page)
                allCharacters.append(contentsOf: response.results)
                completion(.success(()))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func fetchCharacters() async {
        guard !isLoading else {
            return
        }
        
        isLoading = true
        
        do {
            let response = try await charactersService.fetch(page: currentPage)
            self.isLoading = false
            self.allCharacters.append(contentsOf: response.results)
            guard let nextPage = response.info.nextPage else {
                self.hasNextPage = false
                return
            }
            self.currentPage = nextPage
        } catch {
            // Handle error
            self.isLoading = false
        }
    }
    
    func didUpdateSearchBar(_ query: String) {
        guard !query.isEmpty else { return }
        searchTimer?.invalidate()
        searchTimer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { [weak self] _ in
            guard let self else { return }
            Task {
                await self.searchCharacters(query, status: self.currentStateFilter)
            }
        }
    }
    
    func searchCharacters(_ query: String?, status: CharacterStatus?) async {
        currentStateFilter = status
        guard !(query == nil && status == nil) else {
            filteredCharacters = []
            return
        }
        do {
            let response = try await filterService.search(query, status: status)
            self.isLoading = false
            self.filteredCharacters = response.results
        } catch {
            // Handle error
            self.isLoading = false
        }
    }
}
