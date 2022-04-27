//
//  ParallaxItemInternal.swift
//  ParallaxApp
//
//  Created by Mehrafruz on 07.04.2022.
//

import Foundation
import UIKit

struct ParallaxItemInternal {
    
    var view: UIView
     
    var height: CGFloat
     
    var minHeight: CGFloat?
     
    var y: CGFloat
     
    var minY: CGFloat?
     
    var maxY: CGFloat?
    
    var zIndex: Int = 0
    
    var isPage: Bool = false
    
    var contentMode: ParallaxItemContentMode
    
    var adjustsScrollViewTopInset: Bool
    
    var onHeightProgress: ((_ progress: CGFloat) -> Void)?
    
    var onYProgress: ((_ progress: CGFloat) -> Void)?
    
    var yProgress: CGFloat = 0
    var heightProgress: CGFloat = 0
    
}
