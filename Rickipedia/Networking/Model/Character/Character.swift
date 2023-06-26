//
//  Character.swift
//  Rickipedia
//
//  Created by Tomas Martins on 26/06/23.
//

import Foundation

struct Character: Decodable {
    let id: Int
    let name: String
    let status: CharacterStatus
    let species: String
    let type: String
    let gender: Gender
    let origin: Location
    let location: Location
    let image: String
    let episode: [String]
    var url: String
    var created: String
    
    enum CodingKeys: CodingKey {
        case id
        case name
        case status
        case species
        case type
        case gender
        case origin
        case location
        case image
        case episode
        case url
        case created
    }
    
    init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<Character.CodingKeys> = try decoder.container(keyedBy: Character.CodingKeys.self)
        
        self.id = try container.decode(Int.self, forKey: Character.CodingKeys.id)
        self.name = try container.decode(String.self, forKey: Character.CodingKeys.name)
        self.status = try container.decode(CharacterStatus.self, forKey: Character.CodingKeys.status)
        self.species = try container.decode(String.self, forKey: Character.CodingKeys.species)
        self.type = try container.decode(String.self, forKey: Character.CodingKeys.type)
        self.gender = try container.decode(Gender.self, forKey: Character.CodingKeys.gender)
        self.origin = try container.decode(Location.self, forKey: Character.CodingKeys.origin)
        self.location = try container.decode(Location.self, forKey: Character.CodingKeys.location)
        self.image = try container.decode(String.self, forKey: Character.CodingKeys.image)
        self.episode = try container.decode([String].self, forKey: Character.CodingKeys.episode)
        self.url = try container.decode(String.self, forKey: Character.CodingKeys.url)
        self.created = try container.decode(String.self, forKey: Character.CodingKeys.created)
        
    }
}
