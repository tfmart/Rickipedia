//
//  CharacterListState.swift
//  Rickipedia
//
//  Created by Tomas Martins on 30/06/23.
//

import Foundation

enum CharactersListState {
    case idle
    case loading
    case loaded
    case error(Error)
}
