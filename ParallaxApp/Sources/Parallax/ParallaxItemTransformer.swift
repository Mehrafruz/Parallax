//
//  ParallaxItemTransformer.swift
//  ParallaxApp
//
//  Created by Mehrafruz on 17.04.2022.
//

import Foundation
import UIKit

class ParallaxItemTransformer {
    
    var internalItems: [ParallaxItemInternal] = []
    
    func transform(items: [ParallaxItem], safeAreaTop: CGFloat) -> [ParallaxItemInternal] {
        
        defer {
            internalItems = []
        }
        
        items.forEach { item in
            let internalItem = transform(item: item, safeAreaTop: safeAreaTop)
            internalItems.append(internalItem)
        }
        
        return internalItems
    }
    
    func transform(item: ParallaxItem, safeAreaTop: CGFloat) -> ParallaxItemInternal {
        
        let y = calculateY(item: item, safeAreaTop: safeAreaTop)
        
        
        let safeAreaAddValue = item.isLimitsRelativeToSafeArea ? safeAreaTop : 0
        
        var minY = item.minY.map { $0 + safeAreaAddValue }
        var maxY = item.maxY.map { $0 + safeAreaAddValue }
        
        let height = item.height ?? item.view.systemLayoutSizeFitting(.zero).height
        let minHeight = item.minHeight
        
        if minHeight != nil && minY == nil {
            minY = y
        }
        
        if item.maxY == nil && ParallaxItemContentMode.fillingModes.contains(item.contentMode) {
            maxY = y
        }
        
        return ParallaxItemInternal(view: item.view,
                                    height: height,
                                    minHeight: minHeight,
                                    y: y,
                                    minY: minY,
                                    maxY: maxY,
                                    zIndex: item.zIndex,
                                    isPage: item.isPage,
                                    contentMode: item.contentMode,
                                    adjustsScrollViewTopInset: item.adjustsScrollViewTopInset,
                                    onHeightProgress: item.onHeightProgress,
                                    onYProgress: item.onYProgress)
    }
    
    func internalItem(for item: ParallaxItem) -> ParallaxItemInternal? {
        internalItems.first(where: { $0.view === item.view })
    }
    
    var lastItem: ParallaxItemInternal? {
        internalItems.last
    }
    
    func calculateY(item: ParallaxItem, safeAreaTop: CGFloat) -> CGFloat {
        
        if let anchorItem = item.anchorItem {
            if let anchor = internalItem(for: anchorItem) {
                return anchor.y + anchor.height + item.topMargin
            } else {
                assertionFailure("позиция anchorItem ещё не была рассчитана")
            }
        }
        
        if item.isPositionedRelativeToItemBefore {
            if let lastItem = lastItem {
                return lastItem.y + lastItem.height + item.topMargin
            } else {
                return item.topMargin
            }
        }
        
        if item.isYRelativeToSafeArea {
            return item.y + safeAreaTop
        }
        
        return item.y
    }
    
}
