//
//  CharacterListState.swift
//  Rickipedia
//
//  Created by Tomas Martins on 30/06/23.
//

import Foundation

enum CharactersListState {
    case loading
    case loaded
    case empty(Error)
    case failedToLoadPage

    var isLoading: Bool {
        switch self {
        case .loading:
            return true
        default:
            return false
        }
    }
}
