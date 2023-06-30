//
//  CharacterDetailsViewModel.swift
//  Rickipedia
//
//  Created by Tomas Martins on 29/06/23.
//

import UIKit

class CharacterDetailsViewModel {
    var character: Character
    private var details: [CharacterDetail] = []

    init(character: Character) {
        self.character = character
        updateDetails()
    }

    private func updateDetails() {
        details.append(CharacterDetail(title: "Status", value: character.status.rawValue))
        details.append(CharacterDetail(title: "Species", value: character.species))
        if let type = character.type {
            details.append(CharacterDetail(title: "Type", value: type))
        }
        details.append(CharacterDetail(title: "Gender", value: character.gender.rawValue))
        details.append(CharacterDetail(title: "Origin", value: character.origin))
        details.append(CharacterDetail(title: "Location", value: character.location))
        details.append(CharacterDetail(title: "Episode Count", value: "\(character.episodesCount)"))
    }

    func getCharacterDetails() -> [CharacterDetail] {
        return details
    }
}
