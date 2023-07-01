//
//  Character.swift
//  Rickipedia
//
//  Created by Tomas Martins on 26/06/23.
//

import Foundation

struct Character: Identifiable, Equatable {
    let id: Int
    let name: String
    let status: CharacterStatus
    let type: String?
    let species: String
    let gender: Gender
    let origin: String
    let location: String
    let imageURL: URL?
    let episodesCount: Int
    
    static func == (lhs: Character, rhs: Character) -> Bool {
        return lhs.id == rhs.id &&
        lhs.name == rhs.name &&
        lhs.status == rhs.status &&
        lhs.type == rhs.type &&
        lhs.species == rhs.species &&
        lhs.gender == rhs.gender &&
        lhs.origin == rhs.origin &&
        lhs.location == rhs.location &&
        lhs.imageURL == rhs.imageURL &&
        lhs.episodesCount == rhs.episodesCount
    }
}
