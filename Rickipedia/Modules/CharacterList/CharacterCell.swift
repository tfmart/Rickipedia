//
//  CharacterCell.swift
//  Rickipedia
//
//  Created by Tomas Martins on 28/06/23.
//

import UIKit

class CharacterCell: UICollectionViewListCell {
    static let reuseIdentifier = "CharacterCell"
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let characterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 4
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.quaternaryLabel.cgColor
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isAccessibilityElement = false
        return imageView
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(characterImageView)
        contentView.addSubview(nameLabel)
        
        let heightAnchor = characterImageView.heightAnchor.constraint(equalToConstant: 60)
        let bottomImageConstraint = characterImageView.bottomAnchor.constraint(equalTo: separatorLayoutGuide.bottomAnchor, constant: 16)
        heightAnchor.priority = .defaultHigh
        bottomImageConstraint.priority = .defaultHigh
        
        NSLayoutConstraint.activate([
            characterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            characterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            characterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            bottomImageConstraint,
            characterImageView.widthAnchor.constraint(equalToConstant: 60),
            heightAnchor,
            
            nameLabel.leadingAnchor.constraint(equalTo: characterImageView.trailingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            separatorLayoutGuide.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor)
        ])
    }

    
    func configure(with character: Character) {
        nameLabel.text = character.name
        
        if let imageURL = URL(string: character.image) {
            let request = URLRequest(url: imageURL, cachePolicy: .returnCacheDataElseLoad)
            Task {
                if let (data, _) = try? await URLSession.shared.data(for: request),
                   let image = UIImage(data: data) {
                    self.characterImageView.image = image
                } else {
                    characterImageView.image = UIImage(named: "placeholder_avatar")
                }
            }
        } else {
            characterImageView.image = UIImage(named: "placeholder_avatar")
        }
    }
}
