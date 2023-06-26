//
//  CharacterStatus.swift
//  Rickipedia
//
//  Created by Tomas Martins on 26/06/23.
//

import Foundation

enum CharacterStatus: String, Decodable {
    case alive = "Alive"
    case dead = "Dead"
    case unknown = "Unknown"
}
