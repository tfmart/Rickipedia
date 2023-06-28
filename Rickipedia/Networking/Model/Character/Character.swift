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
}
