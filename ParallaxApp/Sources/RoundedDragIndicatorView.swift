//
//  RoundedDragIndicatorView.swift
//  ParallaxApp
//
//  Created by Mehrafruz on 17.04.2022.
//

import CoreGraphics
import UIKit

public final class RoundedDragIndicatorView: UIView {
    
    let dragIndicatorSize = CGSize(width: 34.0, height: 4.0)
    
    public var mainBackgroundColor: UIColor = UIColor.white {
        didSet {
            roundedView.backgroundColor = mainBackgroundColor
        }
    }
    var graySection: UIColor = .gray
    private var secondaryBackgroundColor: UIColor {
        graySection
    }
    
    public lazy var dragIndicatorView: UIView = {
        
        let view = UIView()
        view.backgroundColor = graySection.withAlphaComponent(0.7)
        view.layer.cornerRadius = dragIndicatorSize.height / 2.0
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var roundedView: UIView = {
        
        let offsetX: CGFloat = 2
        let roundedView = UIView(frame: CGRect(x: -offsetX, y: 0, width: bounds.width + 2 * offsetX, height: 16))
        roundedView.backgroundColor = mainBackgroundColor
        roundedView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        roundedView.layer.cornerRadius = 16
        roundedView.layer.masksToBounds = true
        roundedView.layer.contentsScale = UIScreen.main.scale
        
        return roundedView
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        
        backgroundColor = secondaryBackgroundColor
        
        [roundedView,
         dragIndicatorView].forEach {
            addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            dragIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor),
            dragIndicatorView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            dragIndicatorView.widthAnchor.constraint(equalToConstant: dragIndicatorSize.width),
            dragIndicatorView.heightAnchor.constraint(equalToConstant: dragIndicatorSize.height),
            
            roundedView.leadingAnchor.constraint(equalTo: leadingAnchor),
            roundedView.trailingAnchor.constraint(equalTo: trailingAnchor),
            roundedView.topAnchor.constraint(equalTo: topAnchor),
            roundedView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            heightAnchor.constraint(equalToConstant: 16)
        ])
    }
}
