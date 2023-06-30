//
//  CharacterListViewModel.swift
//  Rickipedia
//
//  Created by Tomas Martins on 26/06/23.
//

import Foundation
import RKPService

final class CharactersListViewModel {
    let charactersService: RKPAllCharactersService
    let filterService: RKPFilterCharactersServiceProtocol
    
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
    
    init(charactersService: RKPAllCharactersService = RKPAllCharactersService(),
         filterService: RKPFilterCharactersServiceProtocol = RKPFilterCharactersService()) {
        self.charactersService = charactersService
        self.filterService = filterService
    }
}

// MARK: Fetch all characteres

extension CharactersListViewModel {
    func fetchCharacters(page: Int, _ completion: @escaping (Result<Void, Error>) -> Void) {
        Task {
            do {
                let response = try await charactersService.fetch(page: page)
                let charactersToAppend = response.results.map { convert(character: $0) }
                allCharacters.append(contentsOf: charactersToAppend)
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
            let charactersToAppend = response.results.map { convert(character: $0) }
            allCharacters.append(contentsOf: charactersToAppend)
            guard let next = response.info.next, let nextPage = Int(next) else {
                self.hasNextPage = false
                return
            }
            self.currentPage = nextPage
        } catch {
            // Handle error
            self.isLoading = false
        }
    }
    
    func convert(character: RKPCharacter) -> Character {
        Character(id: character.id,
                     name: character.name,
                     stauts: .init(rawValue: character.status.rawValue) ?? .unknown,
                     type: character.type.isEmpty ? nil : character.type,
                     species: character.species,
                     gender: .init(rawValue: character.gender.rawValue) ?? .unknown,
                     origin: character.origin.name,
                     location: character.location.name,
                     imageURL: URL(string: character.image),
                     episodesCount: character.episode.count)
    }
}

// MARK: Seaching and filtering
extension CharactersListViewModel {
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
        guard shouldPerformQuery(query, status: status) else {
            filteredCharacters = []
            return
        }
        do {
            let response = try await filterService.search(query, status: serviceStatus(from: status), page: 1)
            self.isLoading = false
            self.filteredCharacters = response.results.map { convert(character: $0) }
        } catch {
            // Handle error
            self.isLoading = false
        }
    }
    
    func shouldPerformQuery(_ query: String?, status: CharacterStatus?) -> Bool {
        guard let query else { return status != nil }
        return !(query.isEmpty && status == nil)
    }
    
    func serviceStatus(from characterStatus: CharacterStatus?) -> RKPCharacterStatus? {
        guard let characterStatus else {
            return nil
        }
        return RKPCharacterStatus(rawValue: characterStatus.rawValue)
    }
}
