//
//  CharactersListViewController.swift
//  Rickipedia
//
//  Created by Tomas Martins on 28/06/23.
//

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

    private lazy var loadingIndicator: UIView = {
        let backgroundView = UIView()
        let loadingIndicator = RKPLoadingIndicator()
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false

        backgroundView.backgroundColor = .black.withAlphaComponent(0.5)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false

        backgroundView.addSubview(loadingIndicator)
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor)
        ])
        return backgroundView
    }()

    private var emptyState: RKPEmptyState?
    private var isRetrySectionVisible = false
    private var cancellables = Set<AnyCancellable>()

    weak var delegate: CharactersListViewControllerDelegate?
    private var dataSource: UICollectionViewDiffableDataSource<Section, Character.ID>!

    init(viewModel: CharactersListViewModel) {
        self.viewModel = viewModel
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
        setupSearchBar()

        viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                switch state {
                case .loaded: self?.showLoadedState()
                case .loading: self?.showLoadingState()
                case .empty(let error): self?.showEmptyState(error)
                case .failedToLoadPage: self?.showRetryState()
                }
            }
            .store(in: &cancellables)

        Task {
            await viewModel.fetchCharacters()
            applySnapshot()
        }
    }

    private func showLoadingIndicator() {
        if loadingIndicator.isHidden {
            view.addSubview(loadingIndicator)
            loadingIndicator.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                loadingIndicator.topAnchor.constraint(equalTo: collectionView.topAnchor),
                loadingIndicator.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor),
                loadingIndicator.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor),
                loadingIndicator.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor)
            ])
        }
        loadingIndicator.isHidden = false
    }

    private func hideLoadingIndicator() {
        loadingIndicator.isHidden = true
    }

    func showLoadedState() {
        hideLoadingIndicator()
        hideEmptyStaete()
        toggleRetrySectionVisibility(false)
    }

    func showLoadingState() {
        showLoadingIndicator()
        hideEmptyStaete()
        toggleRetrySectionVisibility(false)
    }

    func showEmptyState(_ error: Error) {
        setupEmptyState(for: error)
        toggleRetrySectionVisibility(false)
    }

    func showRetryState() {
        hideEmptyStaete()
        hideLoadingIndicator()
        toggleRetrySectionVisibility(true)
    }
}

// MARK: - Collection View Setup
extension CharactersListViewController {
    private func setupCollectionView() {
        collectionView.keyboardDismissMode = .onDrag
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(RKPCharacterCell.self, forCellWithReuseIdentifier: RKPCharacterCell.reuseIdentifier)
        collectionView.register(RKPRetryFooter.self, forCellWithReuseIdentifier: RKPRetryFooter.reuseIdentifier)
        collectionView.delegate = self

        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Character.ID>(
            collectionView: collectionView
        ) { collectionView, indexPath, itemID in
            if let character = self.viewModel.character(for: itemID) {
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: RKPCharacterCell.reuseIdentifier,
                    for: indexPath
                ) as? RKPCharacterCell
                guard let cell else { return nil }
                cell.configure(with: character.name, imageURL: character.imageURL)
                cell.accessories = [.disclosureIndicator()]
                return cell
            } else if indexPath.section == 1 {
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: RKPRetryFooter.reuseIdentifier,
                    for: indexPath
                ) as? RKPRetryFooter
                guard let cell else { return nil }
                cell.configure(message: "Failed to load next page", action: {
                    Task {
                        await self.viewModel.retry()
                    }
                })
                return cell
            }
            fatalError("Unknown cell type")
        }
    }

    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Character.ID>()
        snapshot.appendSections([.main])
        let characterIDs = viewModel.characters.map { $0.id }
        snapshot.appendItems(characterIDs, toSection: .main)

        if isRetrySectionVisible {
            snapshot.appendSections([.retry])
            snapshot.appendItems([-99], toSection: .retry)
        } else {
            snapshot.deleteSections([.retry])
        }

        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension CharactersListViewController {
    enum Section {
        case main
        case retry
    }
}

extension CharactersListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        guard !viewModel.isShowingFooter else { return }
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
        guard let characterID = dataSource.itemIdentifier(for: indexPath),
        let character = viewModel.character(for: characterID) else { return }
        delegate?.didSelectCharacter(character)
    }
}

// MARK: - Search Bar and Filter Button setup
extension CharactersListViewController {
    func setupSearchBar() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Characters"
        searchController.hidesNavigationBarDuringPresentation = false
        navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
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
}

extension CharactersListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        viewModel.didUpdateSearchBar(searchText) {
            DispatchQueue.main.async {
                self.applySnapshot()
            }
        }
    }
}

// MARK: - Error views setup
extension CharactersListViewController {
    private func setupEmptyState(for error: Error) {
        emptyState = .init(message: viewModel.errorMessage(for: error),
                           showRetry: viewModel.shouldShowRetryButton(for: error))
        emptyState?.addRetryButton {
            Task {
                await self.viewModel.retry()
            }
        }

        if let emptyState {
            view.addSubview(emptyState)
            emptyState.isHidden = false
            emptyState.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                emptyState.topAnchor.constraint(equalTo: collectionView.topAnchor),
                emptyState.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor),
                emptyState.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor),
                emptyState.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor)
            ])
            emptyState.isHidden = false
        }
    }

    private func hideEmptyStaete() {
        emptyState?.isHidden = true
    }

    func toggleRetrySectionVisibility(_ show: Bool) {
        isRetrySectionVisible = show
        applySnapshot()
    }
}
