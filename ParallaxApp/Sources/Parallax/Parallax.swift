//
//  Parallax.swift
//  ParallaxApp
//
// Created by Mehrafruz on 17.04.2022.
//

import UIKit

public final class Parallax: NSObject {
    
    var externalItems: [ParallaxItem]
    var internalItems: [ParallaxItemInternal] = []
    var containers: [ParallaxItemContainer] = []
    var transformer: ParallaxItemTransformer = .init()
    
    var scrollView: UIScrollView
    var boundsObservation: NSKeyValueObservation?
    var savedSafeArea: CGFloat = 0
    var isScrollDirectionUp: Bool = true
    var isActive: Bool = false
    
    public init(scrollView: UIScrollView, items: [ParallaxItem]) {
        self.externalItems = items
        self.scrollView = scrollView
    }
    
    ///
    /// активирует механизм параллакса
    ///
    /// - проверяет наличие возможных ошибок в заданных параметрах `items`
    /// - рассчитывает дополнительные внутренние параметры
    /// - изменяет инсеты `scrollView`, добавляет в него айтемы и располагает их
    /// - подписывается на события скролла и изменения размеров `scrollView`
    ///
    public func activate() {
        isActive = true
        internalItems = transformer.transform(items: externalItems, safeAreaTop: scrollView.safeAreaInsets.top)
        adjustScrollView(scrollView, items: internalItems)
        addItemsToScrollView(items: internalItems)
        layoutContainers()
        activateKVO()
    }
    
    ///
    /// деактивирует параллакс
    /// - отписывается от событий
    /// - убирает из `scrollView` добавленные вьюхи и констрейнты
    /// - возвращает инсет и оффсет `scrollView` в ноль
    ///
    /// - Note: метод вызывается в `deinit`, вызывать его явно обычно нет необходимости
    ///
    public func deactivate() {
        isActive = false
        deactivateKVO()
        containers.forEach { $0.removeFromScrollView() }
        restoreScrollView(scrollView)
    }
    
    ///
    /// проверяет, изменились ли `scrollView.safeAreaInsets`
    /// и при необходимости производит перенастройку.
    ///
    /// - Note: может понадобиться вызов этого метода, если после вызова `activate`
    /// по какой-то причине `safeArea` изменилась, например при изменении `navigationItem.largeTitleDisplayMode`.
    /// в таком случае этот метод можно попробовать вызвать из
    /// `UIScrollViewDelegate.scrollViewDidChangeAdjustedContentInset(_ scrollView: UIScrollView)`
    ///
    public func applySafeAreaChangesIfNeeded() {
        guard savedSafeArea != scrollView.safeAreaInsets.top, isActive else { return }
        savedSafeArea = scrollView.safeAreaInsets.top
        internalItems = transformer.transform(items: externalItems, safeAreaTop: scrollView.safeAreaInsets.top)
        deactivate()
        activate()
    }
    
    func addItemsToScrollView(items: [ParallaxItemInternal]) {
        let sortedItems = items.reversed().sorted(by: \.zIndex, with: >)
        containers = sortedItems.map { ParallaxItemContainer(item: $0) }
        containers.forEach { $0.addToScrollView(scrollView) }
    }
    
    func layoutContainers() {
        containers.forEach { layoutContainer($0) }
    }
    
    func layoutContainer(_ container: ParallaxItemContainer) {
        
        var item = container.item
        
        let contentInsetTop = scrollView.adjustedContentInset.top
        let offsetY = scrollView.contentOffset.y + contentInsetTop
        
        var actualY = item.y - contentInsetTop
        var progressY: CGFloat = 1
        let defaultHeight = item.height
        var height = defaultHeight
        
        if let itemMinY = item.minY {
            let minY = itemMinY - contentInsetTop + offsetY
            let yDiff = actualY - minY
            progressY = yDiff / (item.y - itemMinY)
            
            actualY = max(minY, actualY)
            
            if let itemMinHeight = item.minHeight, yDiff < 0 {
                height = max(itemMinHeight, height + yDiff)
            }
        }
        
        if let itemMaxY = item.maxY {
            let maxY = itemMaxY - contentInsetTop + offsetY
            let yDiff = actualY - maxY
            progressY = yDiff / (item.y - itemMaxY)
            
            actualY = min(maxY, actualY)
            
            if yDiff > 0 {
                height = height + yDiff
            }
        }
        
        if !progressY.isNaN, !progressY.isInfinite {
            let progress = max(progressY, 0)
            
            if item.yProgress != progress {
                item.yProgress = progress
                item.onYProgress?(item.yProgress)
            }
        }
        
        let progressHeight = (height - defaultHeight) / (defaultHeight - (item.minHeight ?? 0))
        
        if !progressHeight.isNaN, !progressHeight.isInfinite {
            let progress = 1 + progressHeight
            
            if progress != item.heightProgress {
                item.heightProgress = progress
                item.onHeightProgress?(item.heightProgress)
            }
        }
        
        container.item = item
        
        scrollView.bringSubviewToFront(container)
        container.set(top: actualY, height: height)
    }
    
    func activateKVO() {
        boundsObservation = scrollView.observe(\.bounds, options: [.old, .new]) { [weak self] (_, change) in
            self?.applySafeAreaChangesIfNeeded()
            self?.layoutContainers()
            self?.isScrollDirectionUp = (change.oldValue?.minY ?? 0) < (change.newValue?.minY ?? 0)
        }
    }
    
    func deactivateKVO() {
        boundsObservation?.invalidate()
    }
    
    func restoreScrollView(_ scrollView: UIScrollView) {
        scrollView.contentOffset.y = -scrollView.safeAreaInsets.top
        scrollView.contentInset.top = scrollView.contentInsetAdjustmentBehavior == .never ? scrollView.safeAreaInsets.top : 0
    }
    
    func adjustScrollView(_ scrollView: UIScrollView, items: [ParallaxItemInternal]) {
        
        let maxInset = items.filter({ (item: ParallaxItemInternal) -> Bool in
            item.adjustsScrollViewTopInset
        }).map({ (item: ParallaxItemInternal) -> CGFloat in
            let inset = item.y + item.height
            return inset
        }).max(by: <) ?? 0
        
        let additionalSafeAreaInset = scrollView.contentInsetAdjustmentBehavior == .never ? 0 : scrollView.safeAreaInsets.top
        
        scrollView.contentOffset.y = -maxInset
        scrollView.contentInset.top = maxInset - additionalSafeAreaInset
    }
    
    deinit {
        deactivate()
    }
    
}

extension Parallax: UIScrollViewDelegate {
    
    var contentOffsetsUp: [CGFloat] {
        let contentOffsets: [CGFloat] = internalItems.filter { $0.isPage }.map { item in
            var offset = item.y - (item.minY ?? 0)
            if let minHeight = item.minHeight {
                offset += item.height - minHeight
            }
            return offset - scrollView.adjustedContentInset.top
        }
        return contentOffsets
    }
    
    var contentOffsetsDown: [CGFloat] {
        let contentOffsets: [CGFloat] = internalItems.filter { $0.isPage }.map { item in
            let offset = item.y
            return offset - scrollView.adjustedContentInset.top
        }
        return contentOffsets
    }
    
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let currentOffset = scrollView.contentOffset.y
        var targetOffset: CGFloat?
        
        if isScrollDirectionUp {
            targetOffset = contentOffsetsUp.first(where: {
                $0 > currentOffset
            })
        } else if currentOffset - (contentOffsetsDown.max() ?? 0) < 50 {
            targetOffset = contentOffsetsDown.last(where: {
                $0 < currentOffset
            })
        }
        
        guard let closestPoint = targetOffset else {
            return
        }
        targetContentOffset.pointee = scrollView.contentOffset
        let targetPoint = CGPoint(x: 0, y: closestPoint)
        scrollView.setContentOffset(targetPoint, animated: true)
    }
    
}
