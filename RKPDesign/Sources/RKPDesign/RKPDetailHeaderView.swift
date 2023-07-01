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

    private let imageView: UIImageView = {
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
        addSubview(imageView)
        addSubview(nameLabel)

        // Configure layout constraints
        imageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 120),
            imageView.heightAnchor.constraint(equalToConstant: 120),

            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }

    public func configure(with name: String, image: URL?) {
        nameLabel.text = name
        if let imageURL = image {
            let request = URLRequest(url: imageURL, cachePolicy: .returnCacheDataElseLoad)
            Task {
                if let (data, _) = try? await URLSession.shared.data(for: request),
                   let image = UIImage(data: data) {
                    self.imageView.image = image
                }
            }
        }
    }
}
