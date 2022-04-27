//
//  ParallaxItemContainer.swift
//  ParallaxApp
//
//  Created by Mehrafruz on 07.04.2022.
//

import UIKit

final class ParallaxItemContainer: UIView {
    
    var item: ParallaxItemInternal
    var view: UIView
    var height: CGFloat
    var contentView: UIView { self }
    var viewConstraints: [NSLayoutConstraint] = []
    var topConstraint: NSLayoutConstraint?
    var heightConstraint: NSLayoutConstraint?
    
    init(item: ParallaxItemInternal) {
        self.item = item
        self.view = item.view
        self.height = item.height
        super.init(frame: .zero)
        clipsToBounds = true
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        layoutView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addToScrollView(_ scrollView: UIScrollView) {
        scrollView.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        
        let guide = scrollView.contentLayoutGuide
        let topConstraint = topAnchor.constraint(equalTo: guide.topAnchor, constant: item.y)
        let heightConstraint = heightAnchor.constraint(equalToConstant: height)
        
        self.topConstraint = topConstraint
        self.heightConstraint = heightConstraint
        
        NSLayoutConstraint.activate([
            topConstraint,
            heightConstraint,
            centerXAnchor.constraint(equalTo: scrollView.frameLayoutGuide.centerXAnchor),
            widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
        ])
    }
    
    func removeFromScrollView() {
        NSLayoutConstraint.deactivate(viewConstraints)
        removeFromSuperview()
    }
    
    func set(top: CGFloat, height: CGFloat) {
        topConstraint?.constant = top
        heightConstraint?.constant = height
    }
    
    func layoutView() {
        view.removeFromSuperview()
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        switch item.contentMode {
        case .fill:
            setFillModeConstraints(view)
        case .top:
            setTopModeConstraints(view)
        case .topFill:
            setTopFillModeConstraints(view)
        case .center:
            setCenterModeConstraints(view)
        case .centerFill:
            setCenterFillModeConstraints(view)
        case .bottom:
            setBottomModeConstraints(view)
        case .bottomFill:
            setBottomFillModeConstraints(view)
        }
        
        NSLayoutConstraint.activate(viewConstraints)
    }
    
    private func setFillModeConstraints(_ view: UIView) {
        viewConstraints = [
            view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            view.topAnchor.constraint(equalTo: contentView.topAnchor),
            view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ]
    }
    
    private func setTopModeConstraints(_ view: UIView) {
        viewConstraints = [
            view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            view.topAnchor.constraint(equalTo: contentView.topAnchor),
            view.heightAnchor.constraint(equalToConstant: height)
        ]
    }
    
    private func setTopFillModeConstraints(_ view: UIView) {
        let constraintToBottom = view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        constraintToBottom.priority = .defaultHigh
        viewConstraints = [
            view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            view.topAnchor.constraint(equalTo: contentView.topAnchor),
            view.heightAnchor.constraint(greaterThanOrEqualToConstant: height),
            constraintToBottom
        ]
    }
    
    private func setCenterModeConstraints(_ view: UIView) {
        viewConstraints = [
            view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            view.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            view.heightAnchor.constraint(equalToConstant: height)
        ]
    }
    
    private func setCenterFillModeConstraints(_ view: UIView) {
        let constraintToTop = view.topAnchor.constraint(equalTo: contentView.topAnchor)
        constraintToTop.priority = .defaultHigh
        let constraintToBottom = view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        constraintToBottom.priority = .defaultHigh
        
        viewConstraints = [
            view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            view.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            view.heightAnchor.constraint(greaterThanOrEqualToConstant: height),
            constraintToTop,
            constraintToBottom
        ]
    }
    
    private func setBottomModeConstraints(_ view: UIView) {
        viewConstraints = [
            view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            view.heightAnchor.constraint(equalToConstant: height)
        ]
    }
    
    private func setBottomFillModeConstraints(_ view: UIView) {
        let constraintToTop = view.topAnchor.constraint(equalTo: contentView.topAnchor)
        constraintToTop.priority = .defaultHigh
        viewConstraints = [
            view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            constraintToTop,
            view.heightAnchor.constraint(greaterThanOrEqualToConstant: height),
            view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ]
    }
    
}
