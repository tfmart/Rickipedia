//
//  CharactersListViewController.swift
//  Rickipedia
//
//  Created by Tomas Martins on 28/06/23.
//

// swiftlint:disable line_length

import UIKit
import Combine
import RKPDesign

protocol CharactersListViewControllerDelegate: AnyObject {
    func didSelectCharacter(_ character: Character)
}

class CharactersListViewController: UIViewController {
    private let collectionView: UICollectionView
    private let viewModel: CharactersListViewModel
    private let searchController = UISearchController(searchResultsController: nil)

    private var loadingIndicator: UIView?
    private var cancellables = Set<AnyCancellable>()

    weak var delegate: CharactersListViewControllerDelegate?
    private var dataSource: UICollectionViewDiffableDataSource<Section, Character>!

    enum Section {
        case main
    }

    init(viewModel: CharactersListViewModel) {
        self.viewModel = viewModel
        var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        configuration.footerMode = .supplementary
        let layout = UICollectionViewCompositionalLayout.list(using: .init(appearance: .plain))
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(nibName: nil, bundle: nil)

        let menu = setupFilterButton()
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: .init(systemName: "line.3.horizontal.decrease.circle"),
            menu: menu
        )
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Characters"
        self.view.backgroundColor = .systemBackground
        setupCollectionView()
        configureDataSource()

        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                if isLoading {
                    self?.showLoadingIndicator()
                } else {
                    self?.hideLoadingIndicator()
                }
            }
            .store(in: &cancellables)

        Task {
            await viewModel.fetchCharacters()
            applySnapshot()
        }
    }

    private func showLoadingIndicator() {
        if loadingIndicator == nil {
            loadingIndicator = RKPLoadingIndicator()
            view.addSubview(loadingIndicator!)
            loadingIndicator!.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                loadingIndicator!.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
                loadingIndicator!.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor)
            ])
        }
        loadingIndicator?.isHidden = false
    }

    private func hideLoadingIndicator() {
        loadingIndicator?.isHidden = true
    }

    private func setupCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(RKPCharacterCell.self, forCellWithReuseIdentifier: RKPCharacterCell.reuseIdentifier)
        collectionView.delegate = self

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
                     handler: { _ in
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
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(
                image: .init(systemName: "line.3.horizontal.decrease.circle"),
                menu: menu
            )
            applySnapshot()
        }
    }

    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Character>(collectionView: collectionView) { collectionView, indexPath, character in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RKPCharacterCell.reuseIdentifier,
                                                                for: indexPath) as? RKPCharacterCell else {
                fatalError("Failed to dequeue CharacterCell")
            }

            cell.configure(with: character.name, imageURL: character.imageURL)
            cell.accessories = [.disclosureIndicator()]

            return cell
        }
    }

    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Character>()
        snapshot.appendSections([.main])
        snapshot.appendItems(viewModel.characters, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension CharactersListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        viewModel.didUpdateSearchBar(searchText) {
            self.applySnapshot()
        }
    }
}

extension CharactersListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        let lastItem = viewModel.characters.count - 1
        if indexPath.item == lastItem {
            Task {
                if viewModel.isSearching {
                    await viewModel.searchCharacters(searchController.searchBar.text,
                                                     status: viewModel.currentStateFilter)
                } else {
                    await viewModel.fetchCharacters()
                }
                applySnapshot()
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let character = dataSource.itemIdentifier(for: indexPath) else { return }
        delegate?.didSelectCharacter(character)
    }
}
// swiftlint:enable line_length
