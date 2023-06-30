//
//  Character.swift
//  Rickipedia
//
//  Created by Tomas Martins on 26/06/23.
//

import Foundation

struct Character: Identifiable {
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
}
