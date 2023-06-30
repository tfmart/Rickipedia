//
//  CharacterListViewModel.swift
//  Rickipedia
//
//  Created by Tomas Martins on 26/06/23.
//

import Combine
import Foundation
import RKPService

final class CharactersListViewModel {
    let charactersService: RKPAllCharactersService
    let filterService: RKPFilterCharactersServiceProtocol
    
    private var allCharacters: [Character] = []
    private var filteredCharacters: [Character] = []
    
    private var currentPage: Int = 1
    private var currentFilterPage: Int = 1
    
    var isSearching: Bool = false
    
    private var hasNextPage: Bool = true
    private var hasNextFilterPage: Bool = true
    var currentStateFilter: CharacterStatus? = nil
    
    @Published private(set) var isLoading = false
    
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
        guard !isLoading, hasNextPage else {
            return
        }
        
        isLoading = true
        
        do {
            let response = try await charactersService.fetch(page: currentPage)
            self.isLoading = false
            let charactersToAppend = response.results.map { convert(character: $0) }
            allCharacters.append(contentsOf: charactersToAppend)
            guard let nextPage = nextPage(response.info) else {
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
    
    func nextPage(_ info: RKPQueryInfo) -> Int? {
        guard let next = info.next,
              let nextURL = URLComponents(string: next),
              let pageQuery =  nextURL.queryItems?.first(where: {
                  $0.name == "page"
              }),
              let pageValue = pageQuery.value else {
            return nil
        }
        return Int(pageValue)
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
        guard !isLoading else { return }
        if currentStateFilter != status {
            currentStateFilter = status
            self.currentFilterPage = 1
            self.filteredCharacters = []
        } else {
            guard hasNextFilterPage else { return }
        }
        
        guard shouldPerformQuery(query, status: status) else {
            self.isSearching = false
            filteredCharacters = []
            return
        }
        do {
            self.isSearching = true
            self.isLoading = true
            let response = try await filterService.search(query, status: serviceStatus(from: status), page: currentFilterPage)
            guard let nextPage = nextPage(response.info) else {
                self.isLoading = false
                self.hasNextFilterPage = false
                return
            }
            self.isLoading = false
            self.currentFilterPage = nextPage
            self.filteredCharacters.append(contentsOf: response.results.map { convert(character: $0) })
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
