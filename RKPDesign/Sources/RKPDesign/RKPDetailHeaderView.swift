//
//  RKPDetailHeaderView.swift
//  
//
//  Created by Tomas Martins on 30/06/23.
//

import Foundation

import UIKit

public class RKPDetailHeaderView: UICollectionReusableView {
    public static let reuseIdentifier = "RKPDetailHeaderView"
    
    private var imageLoadTask: Task<Void, Error>?

    private let characterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textAlignment = .center
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        addSubview(characterImageView)
        addSubview(nameLabel)

        // Configure layout constraints
        characterImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            characterImageView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            characterImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            characterImageView.widthAnchor.constraint(equalToConstant: 120),
            characterImageView.heightAnchor.constraint(equalToConstant: 120),

            nameLabel.topAnchor.constraint(equalTo: characterImageView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }

    public func configure(with name: String, imageURL: URL?) {
        nameLabel.text = name
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
    
    private func cancelImageLoad() {
        imageLoadTask?.cancel()
        imageLoadTask = nil
    }
}
