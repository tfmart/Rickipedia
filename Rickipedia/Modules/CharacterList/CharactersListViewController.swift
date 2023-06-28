//
//  CharactersListViewController.swift
//  Rickipedia
//
//  Created by Tomas Martins on 28/06/23.
//

import UIKit

protocol CharactersListViewControllerDelegate: AnyObject {
    func didSelectCharacter(_ character: Character)
}

class CharactersListViewController: UIViewController {
    private let collectionView: UICollectionView
    private let viewModel: CharactersListViewModel
    weak var delegate: CharactersListViewControllerDelegate?
    
    init(viewModel: CharactersListViewModel) {
        self.viewModel = viewModel
        let layout = UICollectionViewCompositionalLayout.list(using: UICollectionLayoutListConfiguration(appearance: .plain))
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(nibName: nil, bundle: nil)
        
        setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Characters"
        viewModel.fetchCharacters()
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CharacterCell.self, forCellWithReuseIdentifier: CharacterCell.reuseIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension CharactersListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.characters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterCell.reuseIdentifier, for: indexPath) as? CharacterCell else {
            fatalError("Failed to dequeue CharacterCell")
        }
        
        let character = viewModel.characters[indexPath.item]
        cell.configure(with: character)
        
        return cell
    }
}

extension CharactersListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let lastItem = viewModel.characters.count - 1
        if indexPath.item == lastItem && viewModel.hasNextPage {
            viewModel.fetchCharacters()
            collectionView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let character = viewModel.characters[indexPath.item]
        delegate?.didSelectCharacter(character)
    }
}
