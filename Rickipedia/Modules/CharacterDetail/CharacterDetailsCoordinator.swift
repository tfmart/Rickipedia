//
//  CharacterDetailsCoordinator.swift
//  Rickipedia
//
//  Created by Tomas Martins on 29/06/23.
//

import UIKit

class CharacterDetailsCoordinator: Coordinator {
    private let character: Character
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController, character: Character) {
        self.navigationController = navigationController
        self.character = character
    }
    
    func start() {
        let characterDetailsViewModel = CharacterDetailsViewModel(character: character)
        let characterDetailsViewController = CharacterDetailsViewController(viewModel: characterDetailsViewModel)
        navigationController.pushViewController(characterDetailsViewController, animated: true)
    }
}
