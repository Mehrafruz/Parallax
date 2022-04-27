//
//  CGFloat+Extension.swift
//  ParallaxApp
//
//  Created by Mehrafruz on 07.04.2022.
//

import UIKit

open class FontMetricsProvider {
    
    open class var defaultMetrics: UIFontMetrics {
        
        UIFontMetrics.default
    }
}

/// Расширение  для работы с механизмом Dynamic Type.
/// Позволяет удобнее создавать динамические значения для шрифтов.
public extension CGFloat {
    
    /// Получить динамическое значение от текущего на основе UIFontMetrics.
    /// - Parameters:
    ///   - fontMetrics: UIFontMetrics.
    ///   - maximumValue: Максимальное значение.
    /// - Returns: Динамический CGFloat.
    func scaled(with fontMetrics: UIFontMetrics = FontMetricsProvider.defaultMetrics,
                maximumValue: CGFloat? = nil) -> CGFloat {
        
    /// Тут можно привязатся к флагу чтобы с сервера говорили шрифт может менятся или нет
        
        let scaledValue = fontMetrics.scaledValue(for: self)
        
        guard let maximumValue = maximumValue,
              scaledValue > maximumValue else {
            
            return scaledValue
        }
        
        return maximumValue
    }
    
    /// Получить динамическое значение от текущего на основе UIFontMetrics, совместимый с конкретной UITraitCollection.
    /// - Parameters:
    ///   - fontMetrics: UIFontMetrics.
    ///   - maximumValue: Максимальное значение.
    ///   - traitCollection: UITraitCollection, для которой нужно получить значение.
    /// - Returns: Динамический CGFloat.
    func scaled(with fontMetrics: UIFontMetrics = FontMetricsProvider.defaultMetrics,
                maximumValue: CGFloat? = nil,
                traitCollection: UITraitCollection) -> CGFloat {
        
        /// Тут можно привязатся к флагу чтобы с сервера говорили шрифт может менятся или нет
        
        let scaledValue = fontMetrics.scaledValue(for: self, compatibleWith: traitCollection)
        
        guard let maximumValue = maximumValue,
              scaledValue > maximumValue else {
            
            return scaledValue
        }
        
        return maximumValue
    }
}
