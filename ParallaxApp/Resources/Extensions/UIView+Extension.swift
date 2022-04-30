//
//  UIView+Extension.swift
//  ParallaxApp
//
//  Created by Мехрафруз on 28.04.2022.
//

import UIKit

//MARK: - Shadows
extension UIView {
    func applyShadow(shadowOffSet: CGSize = CGSize(width: 0, height: 0), shadowOpacity: Float = 12, shadowRadius: CGFloat = 12, color: UIColor = UIColor.gray.withAlphaComponent(0.18)) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius).cgPath
        layer.shadowOffset = shadowOffSet
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
    }
}
