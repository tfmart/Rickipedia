//
//  RKPCharacterDetailCell.swift
//  
//
//  Created by Tomas Martins on 30/06/23.
//

import UIKit

public class RKPCharacterDetailCell: UICollectionViewCell {
    public static let reuseIdentifier = "RKPCharacterDetailCell"

    private let titleLabel: UILabel
    private let valueLabel: UILabel

    override init(frame: CGRect) {
        self.titleLabel = UILabel()
        self.valueLabel = UILabel()

        super.init(frame: frame)

        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        titleLabel.textColor = .secondaryLabel

        valueLabel.font = UIFont.systemFont(ofSize: 16)
        valueLabel.textColor = .label

        contentView.addSubview(titleLabel)
        contentView.addSubview(valueLabel)
    }

    private func setupConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            valueLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            valueLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            valueLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            valueLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }

    public func configure(title: String, value: String) {
        titleLabel.text = title
        valueLabel.text = value
    }
}
