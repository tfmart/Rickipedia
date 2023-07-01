//
//  CharacterListState.swift
//  Rickipedia
//
//  Created by Tomas Martins on 30/06/23.
//

import Foundation

enum CharactersListState: Equatable {
    case loading
    case loaded
    case empty(Error)
    case failedToLoadPage

    var isLoading: Bool {
        if case .loading = self {
            return true
        }
        return false
    }

    static func == (lhs: CharactersListState, rhs: CharactersListState) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading):
            return true
        case (.loaded, .loaded):
            return true
        case let (.empty(error1), .empty(error2)):
            return error1.localizedDescription == error2.localizedDescription
        case (.failedToLoadPage, .failedToLoadPage):
            return true
        default:
            return false
        }
    }
}
