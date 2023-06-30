//
//  CharacterListViewModel.swift
//  Rickipedia
//
//  Created by Tomas Martins on 26/06/23.
//

import Foundation

final class CharactersListViewModel {
    let charactersService: AllCharactersServiceProtocol
    
    private var allCharacters: [Character] = []
    private var filteredCharacters: [Character] = []
    var currentPage: Int = 1
    
    var isLoading: Bool = false
    var hasNextPage: Bool = true
    var currentStateFilter: CharacterStatus? = nil
    
    var characters: [Character] {
        return filteredCharacters.isEmpty ? allCharacters : filteredCharacters
    }
    
    init(charactersService: AllCharactersServiceProtocol = AllCharactersService()) {
        self.charactersService = charactersService
    }
    
    func fetchCharacters(page: Int, _ completion: @escaping (Result<Void, Error>) -> Void) {
        Task {
            do {
                let response = try await charactersService.fetch(page: page)
                allCharacters.append(contentsOf: response.results)
                filteredCharacters = allCharacters
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
            if self.currentPage == response.info.pages {
                self.hasNextPage = false
            }
            self.allCharacters.append(contentsOf: response.results)
            self.currentPage += 1
            if let currentStateFilter {
                filterCharactersByStatus(currentStateFilter)
            }
        } catch {
            // Handle error
            self.isLoading = false
        }
    }
    
    func filterCharactersByName(_ name: String) {
        if name.isEmpty {
            if currentStateFilter == nil {
                filteredCharacters = allCharacters
            }
        } else if currentStateFilter != nil {
            filteredCharacters = filteredCharacters.filter { $0.name.lowercased().contains(name.lowercased()) }
        } else {
            filteredCharacters = allCharacters.filter { $0.name.lowercased().contains(name.lowercased()) }
        }
    }
    
    func filterCharactersByStatus(_ status: CharacterStatus?) {
        guard currentStateFilter != status else {
            currentStateFilter = nil
            filteredCharacters = allCharacters
            return
        }
        currentStateFilter = status
        guard let status else {
            filteredCharacters = allCharacters
            return
        }
        filteredCharacters = allCharacters.filter { $0.status == status }
    }
}
