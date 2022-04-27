//
//  UIColor+Extension.swift
//  ParallaxApp
//
//  Created by Mehrafruz on 07.04.2022.
//

import UIKit

public extension UIColor {
    convenience init(hex: UInt32, alpha: CGFloat = 1) {
        let red = CGFloat((hex & 0xFF0000) >> 16) / 255
        let green = CGFloat((hex & 0xFF00) >> 8) / 255
        let blue = CGFloat((hex & 0xFF)) / 255
        self.init(displayP3Red: red, green: green, blue: blue, alpha: alpha)
    }
    
    convenience init?(hex: String, alpha: CGFloat = 1.0) {
        let hexString = hex.hasPrefix("#") ? String(hex.dropFirst(1)) : hex
        guard let value = UInt32(hexString, radix: 16) else { return nil }
        self.init(hex: value, alpha: alpha)
    }
    
    var hexString: String {
        
        var cgColor = self.cgColor
        
        if cgColor.colorSpace?.name == CGColorSpace.extendedSRGB,
           let displayP3ColorSpace = CGColorSpace(name: CGColorSpace.displayP3),
           let convertedCGColor = cgColor.converted(to: displayP3ColorSpace,
                                                    intent: .defaultIntent,
                                                    options: nil) {
            
            cgColor = convertedCGColor
        }
        
        let components = cgColor.components
        let r: CGFloat = components?[0] ?? 0.0
        let g: CGFloat = components?[1] ?? 0.0
        let b: CGFloat = components?[2] ?? 0.0
        
        let hexString = String.init(format: "#%02lX%02lX%02lX", lroundf(Float(r * 255)), lroundf(Float(g * 255)), lroundf(Float(b * 255)))
        return hexString
    }
    
    ///  Метод позволяет расчитать промежуточный цвет
    ///
    /// - Parameters:
    ///   - color: цвет к которому стремимся
    ///   - percentage: процент стремления (от 0 до 1)
    ///
    ///   white.transition(to color: .black, percentage: 0.5) -> `gray`
    ///   white.transition(to color: .black, percentage: 0.25) -> `light gray`
    ///   white.transition(to color: .black, percentage: 0.75) -> `dark gray`
    func translated(to color: UIColor, percentage: CGFloat) -> UIColor {
        let percentage = max(min(percentage, 1), 0)
        switch percentage {
        case 0: return self
        case 1: return color
        default:
            var (r1, g1, b1, a1): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
            var (r2, g2, b2, a2): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
            guard self.getRed(&r1, green: &g1, blue: &b1, alpha: &a1) else { return self }
            guard color.getRed(&r2, green: &g2, blue: &b2, alpha: &a2) else { return self }

            return UIColor(red: CGFloat(r1 + (r2 - r1) * percentage),
                           green: CGFloat(g1 + (g2 - g1) * percentage),
                           blue: CGFloat(b1 + (b2 - b1) * percentage),
                           alpha: CGFloat(a1 + (a2 - a1) * percentage))
        }
    }
    
    var rgba: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        return (red, green, blue, alpha)
    }
    
    var isOpaque: Bool {
        
        rgba.alpha == 1.0
    }
}
