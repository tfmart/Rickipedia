//
//  CharacterConverter.swift
//  Rickipedia
//
//  Created by Tomas Martins on 30/06/23.
//

import Foundation
import RKPService

protocol CharacterConverter {
    func convert(character: RKPCharacter) -> Character
}

struct DefaultCharacterConverter: CharacterConverter {
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
