//
//  RKPCharacterCell.swift
//  
//
//  Created by Tomas Martins on 30/06/23.
//

import UIKit

public class RKPCharacterCell: UICollectionViewListCell {
    static public let reuseIdentifier = "RKPCharacterCell"
    
    private var imageLoadTask: Task<Void, Error>?
    
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
    
    private func setupViews() {
        contentView.addSubview(characterImageView)
        contentView.addSubview(nameLabel)
        
        let heightAnchor = characterImageView.heightAnchor.constraint(equalTo: characterImageView.widthAnchor)
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func prepareForReuse() {
        super.prepareForReuse()
        cancelImageLoad()
    }
    
    private func cancelImageLoad() {
        imageLoadTask?.cancel()
        imageLoadTask = nil
    }
    
    public func configure(with name: String, imageURL: URL?) {
        nameLabel.text = name
        characterImageView.image = UIImage(named: "avatar")
        
        if let imageURL = imageURL {
            loadImage(from: imageURL)
        }
    }
    
    private func loadImage(from url: URL) {
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
        
        if let cachedResponse = URLCache.shared.cachedResponse(for: request),
           let image = UIImage(data: cachedResponse.data) {
            characterImageView.image = image
        } else {
            characterImageView.image = nil
            startImageLoad(with: request)
        }
    }
    
    private func startImageLoad(with request: URLRequest) {
        cancelImageLoad()
        
        let task = Task<Void, Error> {
            do {
                let (data, response) = try await URLSession.shared.data(for: request)
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    let cachedResponse = CachedURLResponse(response: httpResponse, data: data)
                    URLCache.shared.storeCachedResponse(cachedResponse, for: request)
                    if let image = UIImage(data: data) {
                        self.characterImageView.image = image
                    } else {
                        self.characterImageView.image = UIImage(named: "avatar")
                    }
                } else {
                    self.characterImageView.image = UIImage(named: "avatar")
                }
            } catch {
                self.characterImageView.image = UIImage(named: "avatar")
            }
        }
        
        imageLoadTask = task
    }
}
