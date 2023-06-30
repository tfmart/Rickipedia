//
//  CharacterDetailsViewModel.swift
//  Rickipedia
//
//  Created by Tomas Martins on 29/06/23.
//

import UIKit

class CharacterDetailsViewModel {
    var character: Character
    
    init(character: Character) {
        self.character = character
    }
    
    func backgroundColor(for image: UIImage) -> UIColor {
        guard let color = image.averageColor else {
            return .systemGroupedBackground
        }
        return color
    }
    
    var backgroundColor: UIColor {
        guard let imageUrl = URL(string: character.image),
              let imageData = try? Data(contentsOf: imageUrl),
              let image = UIImage(data: imageData),
              let color = image.averageColor else {
            return .systemGroupedBackground
        }
        return color
    }
}
