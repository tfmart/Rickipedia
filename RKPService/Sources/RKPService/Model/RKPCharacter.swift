//
//  RKPCharacter.swift
//  
//
//  Created by Tomas Martins on 30/06/23.
//

import Foundation

public struct RKPCharacter: Decodable {
    public let id: Int
    public let name: String
    public let status: RKPCharacterStatus
    public let species: String
    public let type: String
    public let gender: RKPCharacterGender
    public let origin: RKPCharacterLocation
    public let location: RKPCharacterLocation
    public let image: String
    public let episode: [String]
    public let url: String
    public let created: String
}

extension RKPCharacter: Hashable {
    public static func == (lhs: RKPCharacter, rhs: RKPCharacter) -> Bool {
        return lhs.id == rhs.id &&
        lhs.name == rhs.name &&
        lhs.status == rhs.status &&
        lhs.species == rhs.species &&
        lhs.type == rhs.type &&
        lhs.gender == rhs.gender &&
        lhs.origin == rhs.origin &&
        lhs.location == rhs.location &&
        lhs.image == rhs.image &&
        lhs.episode == rhs.episode &&
        lhs.url == rhs.url &&
        lhs.created == rhs.created
    }
}
