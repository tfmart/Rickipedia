//
//  Character.swift
//  Rickipedia
//
//  Created by Tomas Martins on 26/06/23.
//

import Foundation

struct Character: Hashable {
    let id: Int
    let name: String
    let stauts: CharacterStatus
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
        lhs.stauts == rhs.stauts &&
        lhs.type == rhs.type &&
        lhs.species == rhs.species &&
        lhs.gender == rhs.gender &&
        lhs.origin == rhs.origin &&
        lhs.location == rhs.location &&
        lhs.imageURL == rhs.imageURL &&
        lhs.episodesCount == rhs.episodesCount
    }
}
