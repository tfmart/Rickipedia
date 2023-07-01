//
//  RKPLoadingIndicator.swift
//  
//
//  Created by Tomas Martins on 30/06/23.
//

import UIKit
import FLAnimatedImage

public class RKPLoadingIndicator: UIView {
    private let animatedImageView: FLAnimatedImageView = {
        let imageView = FLAnimatedImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        if let url = Bundle.module.url(forResource: "portal", withExtension: "gif"),
           let data = try? Data(contentsOf: url) {
            imageView.animatedImage = FLAnimatedImage(gifData: data)
        }
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        addSubview(animatedImageView)
        
        NSLayoutConstraint.activate([
            animatedImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            animatedImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            animatedImageView.topAnchor.constraint(equalTo: topAnchor),
            animatedImageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
