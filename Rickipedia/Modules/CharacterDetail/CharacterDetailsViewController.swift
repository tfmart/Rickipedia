//
//  CharacterDetailsViewController.swift
//  Rickipedia
//
//  Created by Tomas Martins on 29/06/23.
//

import UIKit

class CharacterDetailsViewController: UIViewController {
    private var viewModel: CharacterDetailsViewModel
    
    private let collectionView: UICollectionView
    private var dataSource: UICollectionViewDiffableDataSource<CharacterDetailSection, CharacterDetail>!
    
    init(viewModel: CharacterDetailsViewModel) {
        self.viewModel = viewModel
        
        var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        configuration.headerMode = .supplementary
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = viewModel.character.name
        
        setupCollectionView()
        setupNavigationBar()
        updateCollectionView()
    }
    
    private func setupCollectionView() {
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        collectionView.register(CharacterDetailCell.self, forCellWithReuseIdentifier: CharacterDetailCell.reuseIdentifier)
        collectionView.register(CharacterDetailsHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CharacterDetailsHeaderView.reuseIdentifier)
        
        dataSource = UICollectionViewDiffableDataSource<CharacterDetailSection, CharacterDetail>(collectionView: collectionView) { collectionView, indexPath, detail in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterDetailCell.reuseIdentifier, for: indexPath) as! CharacterDetailCell
            cell.configure(title: detail.title, value: detail.value)
            cell.backgroundConfiguration = .listGroupedCell()
            return cell
        }
        
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionHeader else {
                return nil
            }
            
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CharacterDetailsHeaderView.reuseIdentifier, for: indexPath) as! CharacterDetailsHeaderView
            headerView.configure(with: self.viewModel.character)
            return headerView
        }
    }
    
    private func setupNavigationBar() {
        // Configure navigation bar if needed
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<CharacterDetailSection, CharacterDetail>(collectionView: collectionView) { collectionView, indexPath, detail in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterDetailCell.reuseIdentifier, for: indexPath) as! CharacterDetailCell
            cell.configure(title: detail.title, value: detail.value)
            cell.backgroundConfiguration = .listGroupedCell()
            return cell
        }

        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionHeader else {
                return nil
            }

            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CharacterDetailsHeaderView.reuseIdentifier, for: indexPath) as! CharacterDetailsHeaderView
            headerView.configure(with: self.viewModel.character)
            return headerView
        }
    }

    
    private func updateCollectionView() {
        var snapshot = NSDiffableDataSourceSnapshot<CharacterDetailSection, CharacterDetail>()
        snapshot.appendSections([.details])
        
        let details = viewModel.getCharacterDetails()
        snapshot.appendItems(details, toSection: .details)
        dataSource.apply(snapshot, animatingDifferences: true)
    }

}
