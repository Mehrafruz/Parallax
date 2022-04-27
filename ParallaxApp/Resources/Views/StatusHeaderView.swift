//
//  StatusHeaderView.swift
//  ParallaxApp
//
//  Created by Mehrafruz on 07.04.2022.
//

import UIKit

public class StatusHeaderView: UIView {
    
    public lazy var imageView: UIImageView = {
        
        let view = UIImageView()
        view.contentMode = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    public lazy var titleLabel: UILabel = {
        
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        
        return label
    }()
    
    public lazy var containerView: UIView = {
        
        let view = UIView()
        view.isOpaque = false
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    public convenience init() {
        self.init(frame: .zero)
        addSubview(containerView)
        
        let containerToTop = containerView.topAnchor.constraint(equalTo: topAnchor, constant: 32)
        let containerToBottom = containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -32)
        
        [containerToTop,
         containerToBottom].forEach { $0.priority = .defaultLow }

        NSLayoutConstraint.activate([
            containerToTop, containerToBottom,
            containerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            heightAnchor.constraint(greaterThanOrEqualToConstant: 180)
        ])
        
        [imageView,
         titleLabel].forEach {
            containerView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 80),
            imageView.widthAnchor.constraint(equalToConstant: 96),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),

            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 62),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            titleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 0)
        ])
    }
    
    public func set(title: String, image: UIImage) {
        imageView.image = image
        titleLabel.text = title
    }
    
}

