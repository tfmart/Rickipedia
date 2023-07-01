//
//  RKPEmptyState.swift
//  
//
//  Created by Tomas Martins on 30/06/23.
//

import UIKit

public class RKPEmptyState: UIView {
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = .gray
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var retryButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Retry", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.addTarget(self, action: #selector(retryButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private var retryAction: (() -> Void)?
    
    public init(message: String, showRetry: Bool) {
        super.init(frame: .zero)
        
        messageLabel.text = message
        
        self.backgroundColor = .secondarySystemBackground
        
        addSubview(messageLabel)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            messageLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            messageLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
        
        if showRetry {
            addSubview(retryButton)
            retryButton.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                retryButton.centerXAnchor.constraint(equalTo: centerXAnchor),
                retryButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 16)
            ])
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func addRetryButton(action: @escaping () -> Void) {
        retryAction = action
    }
    
    @objc private func retryButtonTapped() {
        retryAction?()
    }
}
