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
        details = [
            CharacterDetail(title: "Status", value: character.status.rawValue),
            CharacterDetail(title: "Species", value: character.species),
            CharacterDetail(title: "Type", value: character.type),
            CharacterDetail(title: "Gender", value: character.gender.rawValue),
            CharacterDetail(title: "Origin", value: character.origin.name),
            CharacterDetail(title: "Location", value: character.location.name),
            CharacterDetail(title: "Episode Count", value: "\(character.episode.count)")
        ]
    }
    
    func getCharacterDetails() -> [CharacterDetail] {
        return details
    }
}

