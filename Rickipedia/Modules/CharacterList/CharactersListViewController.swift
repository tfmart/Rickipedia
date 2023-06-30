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
    private let searchController = UISearchController(searchResultsController: nil)

    weak var delegate: CharactersListViewControllerDelegate?
    
    init(viewModel: CharactersListViewModel) {
        self.viewModel = viewModel
        var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        configuration.footerMode = .supplementary
        let layout = UICollectionViewCompositionalLayout.list(using: UICollectionLayoutListConfiguration(appearance: .plain))
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(nibName: nil, bundle: nil)
        
        setupCollectionView()
        let menu = setupFilterButton()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: .init(systemName: "line.3.horizontal.decrease.circle"), menu: menu)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Characters"
        self.view.backgroundColor = .systemBackground
        Task {
            await viewModel.fetchCharacters()
            self.collectionView.reloadData()
        }
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CharacterCell.self, forCellWithReuseIdentifier: CharacterCell.reuseIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Characters"
        searchController.hidesNavigationBarDuringPresentation = false
        navigationItem.searchController = searchController
        definesPresentationContext = true

        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupFilterButton() -> UIMenu {
        let menuItems: [UIAction] = [
            UIAction(title: "Alive",
                     image: UIImage(systemName: "person.2.fill"),
                     state: viewModel.currentStateFilter == .alive ? .on : .off,
                     handler: { action in
                         self.didApplyStatusFilter(.alive)
                     }),
            UIAction(title: "Dead",
                     image: UIImage(systemName: "person.2.slash"),
                     state: viewModel.currentStateFilter == .dead ? .on : .off,
                     handler: { _ in
                         self.didApplyStatusFilter(.dead)
                     }),
            UIAction(title: "Unknown",
                     image: UIImage(systemName: "questionmark.circle"),
                     state: viewModel.currentStateFilter == .unknown ? .on : .off,
                     handler: { _ in
                         self.didApplyStatusFilter(.unknown)
                     })
        ]
        
        return UIMenu(title: "Status", children: menuItems)
    }
    
    func didApplyStatusFilter(_ status: CharacterStatus) {
        Task {
            var statusToApply: CharacterStatus? = status
            if status == viewModel.currentStateFilter {
                statusToApply = nil
            }
            await self.viewModel.searchCharacters(searchController.searchBar.text, status: statusToApply)
            let menu = self.setupFilterButton()
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: .init(systemName: "line.3.horizontal.decrease.circle"), menu: menu)
            self.collectionView.reloadData()
        }
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
            Task {
                await viewModel.fetchCharacters()
                collectionView.reloadData()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let character = viewModel.characters[indexPath.item]
        delegate?.didSelectCharacter(character)
    }
}

extension CharactersListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        Task {
            await viewModel.searchCharacters(searchText, status: viewModel.currentStateFilter)
            collectionView.reloadData()
        }
    }
}
