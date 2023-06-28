//
//  CharactersListCoordinator.swift
//  Rickipedia
//
//  Created by Tomas Martins on 28/06/23.
//

import UIKit

class CharactersListCoordinator: Coordinator {
    private let navigationController: UINavigationController
    private let charactersListViewModel: CharactersListViewModel
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.charactersListViewModel = CharactersListViewModel()
    }
    
    func start() {
        let charactersListViewController = CharactersListViewController(viewModel: charactersListViewModel)
        charactersListViewController.delegate = self
        navigationController.pushViewController(charactersListViewController, animated: true)
    }
    
    func showCharacterDetails(_ character: Character) {
        // TO-DO: Implement navigation to detail view
    }
}

extension CharactersListCoordinator: CharactersListViewControllerDelegate {
    func didSelectCharacter(_ character: Character) {
        showCharacterDetails(character)
    }
}
