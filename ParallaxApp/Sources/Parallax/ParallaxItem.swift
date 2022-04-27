//
//  ParallaxItemBuilder.swift
//  ParallaxApp
//
//  Created by Mehrafruz on 07.04.2022.
//

import Foundation
import UIKit

public final class ParallaxItem {
    
    var view: UIView

    var contentMode: ParallaxItemContentMode = .top
     
    var height: CGFloat?
     
    var minHeight: CGFloat?
     
    var y: CGFloat = 0
     
    var minY: CGFloat?
     
    var maxY: CGFloat?
    
    var zIndex: Int = 0
    
    var isPage: Bool = false
    
    weak var anchorItem: ParallaxItem?
    
    var topMargin: CGFloat = 0
    
    var isPositionedRelativeToItemBefore: Bool = true
    
    var adjustsScrollViewTopInset: Bool = true
    
    var isYRelativeToSafeArea: Bool = false
    
    var isLimitsRelativeToSafeArea: Bool = false
    
    var onHeightProgress: ((_ progress: CGFloat) -> Void)?
    
    var onYProgress: ((_ progress: CGFloat) -> Void)?
    
    required init(view: UIView) {
        self.view = view
    }
    
}

public extension ParallaxItem {
    
    /// инциализирует айтем, устанавливая ему `view`
    static func view(_ view: UIView) -> Self {
        Self.init(view: view)
    }
    
    /// устанавливает положение `view` относительно другого айтема
    /// - Parameters:
    ///   - topMargin: расстояние между низом другого айтема и верхом этого. по умолчанию `0`
    ///   - anchorItem: айтем, относительно которого хотим расположить `view`. если `nil`, то айтем располагается относительно верха контента `scrollView`
    /// - Returns: обновленный айтем
    func set(topMargin: CGFloat? = nil, toItem anchorItem: ParallaxItem? = nil) -> Self {
        let model = self
        model.topMargin = topMargin ?? 0
        model.anchorItem = anchorItem
        model.isPositionedRelativeToItemBefore = false
        return model
    }
    
    /// устанавливает положение `view` относительно предыдущего айтема
    /// - Parameters:
    ///   - topMarginToItemBefore: расстояние между низом другого айтема и верхом этого. по умолчанию `0`
    /// - Returns: обновленный айтем
    func set(topMarginToItemBefore: CGFloat = 0) -> Self {
        let model = self
        model.topMargin = topMargin
        model.isPositionedRelativeToItemBefore = true
        return model
    }
    
    /// устанавливает свойства айтема таким образом, чтобы при скролле `view` всегда оставалась неподвижной по координате `y`
    /// - Parameter fixedY: установится в `y`, `minY` и `maxY`
    /// - Parameter isRelativeToSafeArea: по умолчанию `false`
    /// - Returns: обновлённый айтем
    func set(fixedY: CGFloat, isRelativeToSafeArea: Bool = false) -> Self {
        let model = self
        model.y = fixedY
        model.minY = fixedY
        model.maxY = fixedY
        model.isYRelativeToSafeArea = isRelativeToSafeArea
        model.isLimitsRelativeToSafeArea = isRelativeToSafeArea
        model.isPositionedRelativeToItemBefore = false
        return model
    }
    
    /// устанавливает параметры положения `view` при скролле
    /// - Parameters:
    ///   - minY: минимальное разрешённое расстояние по оси `y` от верха `scrollView.frame`.
    ///   можно использовать для реализации поведения *sticky header* или *floating button*
    ///   - maxY: максимальное разрешённое расстояние по оси `y` от верха `scrollView.frame`
    ///   можно использовать для реализации растягивающихся хедеров.
    ///   - Parameter isRelativeToSafeArea: по умолчанию `false`
    ///   если `true`, то `y`, `minY` и `maxY` считаются относительно `scrollView.safeAreaInset.top`.
    ///   иначе относительно верха фрейма `scrollView`
    ///   по умолчанию `false`.
    ///   - onYProgress:
    ///   прогресс изменения координаты `y`. `0`, когда значение высоты достигает `minY`; `>=1`, когда значение высоты достигает `y` и выше.
    ///   если `minY` не задан, то значение всегда больше или равно `1`.
    /// - Returns: обновлённый айтем
    func set(minY: CGFloat? = nil,
             maxY: CGFloat? = nil,
             isRelativeToSafeArea: Bool = false,
             onYProgress: ((CGFloat) -> Void)? = nil) -> Self {
        let model = self
        model.minY = minY
        model.maxY = maxY
        model.isLimitsRelativeToSafeArea = isRelativeToSafeArea
        model.onYProgress = onYProgress
        return model
    }
    
    /// устанавливает свойства высоты айтема
    /// - Parameters:
    ///   - height: высота `view` в положении нулевого скролла.
    ///   если указать `nil`, то она будет рассчитана методом `view.systemLayoutSizeFitting(.zero)`
    ///   - minHeight: высота, до которой `view` будет сжиматься при достяжении `minY`, если он указан.
    ///   по умолчанию `nil`
    ///   - onHeightProgress: вызывается при изменении прогресса текущей высоты `view` относительно `minHeight`
    /// - Returns: обновлённый айтем
    func set(height value: CGFloat?,
             minHeight: CGFloat? = nil,
             onHeightProgress: ((CGFloat) -> Void)? = nil) -> Self {
        let model = self
        model.height = value
        model.minHeight = minHeight
        model.onHeightProgress = onHeightProgress
        return model
    }
    
    /// устанавливает `zIndex` айтему. айтемы, у которых `zIndex` больше, располагаются в иерархии вью выше,
    /// таким образом последующие айтемы будут проскролливаться под ними
    /// - Parameter index:
    /// способ расположения вью внутри контейнера.
    /// по умолчанию `0`
    /// - Returns: обновленный айтем
    func zIndex(_ index: Int) -> Self {
        let model = self
        model.zIndex = index
        return model
    }
    
    /// устанавливает айтему `ParallaxItemContentMode`
    /// - Parameter mode:
    /// способ расположения вью внутри контейнера.
    /// по умолчанию `.top`
    /// - Returns: обновленный айтем
    func contentMode(_ mode: ParallaxItemContentMode) -> Self {
        let model = self
        model.contentMode = mode
        return model
    }
    
    /// если установить, то при остановке скролла в направлении к этому айтему произойдёт доскролл до этого айтема.
    /// поведение похожее на `isPagingEnabled`.
    /// - Returns: обновленный айтем
    func setPage() -> Self {
        let model = self
        model.isPage = true
        return model
    }
    
    /// если `true`, то к `scrollView.contentInsets.top` добавляется значение равное `item.y + item.height`.
    /// по умолчанию это свойство `true`, поэтому этот метод имеет смысл использовать только, чтобы выставить его в `false`
    /// - Parameter value: значение
    /// - Returns: обновлённый айтем
    func adjustingScrollViewTopInset(_ value: Bool) -> Self {
        let model = self
        model.adjustsScrollViewTopInset = value
        return model
    }
    
}
