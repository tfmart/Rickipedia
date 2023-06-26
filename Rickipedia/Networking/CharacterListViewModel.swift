//
//  CharacterListViewModel.swift
//  Rickipedia
//
//  Created by Tomas Martins on 26/06/23.
//

import Foundation

final class CharacterListViewModel {
    var service: AllCharactersServiceProtocol? = nil

    var characters: [Character] = []
    var currentPage: Int = 1
    
    var hasNextPage: Bool = true
    
    func fetchCharacters() async {
        do {
            if let response = try await service?.fetch(page: currentPage) {
                characters.append(contentsOf: response.results)
                hasNextPage = response.info.nextPage != nil
                if hasNextPage {
                    currentPage += 1
                }
            }
        } catch let error {
            // show empty state or handle errors
        }
    }
}
