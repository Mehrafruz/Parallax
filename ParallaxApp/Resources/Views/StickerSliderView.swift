//
//  StickerSlider.swift
//  ParallaxApp
//
//  Created by Дадобоева Мехрафруз on 26.04.2022.
//

import UIKit

public class StickerSliderView: UIView {

    private lazy var bookImageView: UIImageView = {
        
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "book")
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var cyborgImageView: UIImageView = {
        
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "cyborg")
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var secondBookImageView: UIImageView = {
        
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "book")
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var mainStackView: UIStackView = {
        
        let stackView =  UIStackView(arrangedSubviews: [bookImageView,
                                                        cyborgImageView,
                                                        secondBookImageView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.isLayoutMarginsRelativeArrangement = true
        
        return stackView
    }()
    
    public override var intrinsicContentSize: CGSize {
        return CGSize(width: bounds.width, height: bounds.height)
    }
    
    public convenience init() {
        self.init(frame: .zero)
        setupConstraints()
    }
    
    private func setupConstraints() {
        
        addSubview(mainStackView)
        
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            mainStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            mainStackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
