//
//  CharacterListViewModel.swift
//  Rickipedia
//
//  Created by Tomas Martins on 26/06/23.
//

import Foundation

class CharactersListViewModel {
    private let charactersService: AllCharactersServiceProtocol
    
    private var allCharacters: [Character] = []
    private var filteredCharacters: [Character] = []
    private var currentPage: Int = 1
    
    var isLoading: Bool = false
    var hasNextPage: Bool = true
    
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
    
    func fetchCharacters() {
        guard !isLoading else {
            return
        }
        
        isLoading = true
        
        Task {
            do {
                let response = try await charactersService.fetch(page: currentPage)
                self.isLoading = false
                if self.currentPage == response.info.pages {
                    self.hasNextPage = false
                }
                self.allCharacters.append(contentsOf: response.results)
                self.currentPage += 1
            } catch {
                // Handle error
            }
        }
    }
    
    func filterCharactersByName(_ name: String) {
        if name.isEmpty {
            filteredCharacters = allCharacters
        } else {
            filteredCharacters = allCharacters.filter { $0.name.lowercased().contains(name.lowercased()) }
        }
    }
    
    func filterCharactersByStatus(_ status: String) {
        if status.isEmpty {
            filteredCharacters = allCharacters
        } else {
            filteredCharacters = allCharacters.filter { $0.status.rawValue.lowercased() == status.lowercased() }
        }
    }
}
