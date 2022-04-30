//
//  ViewController.swift
//  ParallaxApp
//
//  Created by Mehrafruz on 07.04.2022.
//

import UIKit

/// Пример применения
/// Cмотрите makeParallax
class ViewController: UIViewController {
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.bounds, style: .grouped)
        tableView.estimatedRowHeight = 70
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.register(LessonTableViewCell.self, forCellReuseIdentifier: "LessonTableViewCell")
        tableView.backgroundColor = UIColor.white
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    lazy var dragIndicatorContainer: RoundedDragIndicatorView = {
        
        let indicatorView = RoundedDragIndicatorView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 16))
        indicatorView.mainBackgroundColor = .white
        
        return indicatorView
    }()
    
    lazy var statusView: StatusHeaderView = {
        let view = StatusHeaderView()
        return view
    }()
    
    lazy var cardSlider: UIView = {
        
        let cardSlider = StickerSliderView()
        cardSlider.translatesAutoresizingMaskIntoConstraints = false
        cardSlider.frame.size = CGSize(width: 50, height: 150)
        cardSlider.backgroundColor = .yellow
        
        return cardSlider
    }()
    
    lazy var cardSliderItem: UIImageView = {
        
        let view = UIImageView()
        view.image = UIImage(named: "book")
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        view.frame = cardSlider.frame.insetBy(dx: 180, dy: 180)
        view.frame.size = CGSize(width: 70, height: 70)
        
        return view
    }()
    
    lazy var navigationBarView: UIView = {
        
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    lazy var parallax: Parallax = makeParallax()
    var parallaxProgress: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        [tableView,
         statusView].forEach {
            view.addSubview($0)
        }
        
        navigationItem.titleView = navigationBarView
        
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 44))
        view.addSubview(navBar)

        let navItem = UINavigationItem(title: "SomeTitle")

        navBar.setItems([navItem], animated: false)

        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
        navigationController?.navigationBar.isTranslucent = false
        
        statusView.set(title: "Hello word!",
                       image: UIImage(named: "robot") ?? UIImage())
        addConstraint()
        setupParallax()
    }
    
    func addConstraint() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
        ])
    }
    
    func setupParallax() {
        parallax = makeParallax()
        parallax.activate()
    }
    
    func makeParallax() -> Parallax {
        let cardsItemMinY: CGFloat = 43
        let navigationBarHeight = navigationController?.navigationBar.frame.maxY ?? 0
        let statusViewHeight: CGFloat = statusView.systemLayoutSizeFitting(.zero).height
        
        let headerItem = ParallaxItem.view(statusView)
            .set(fixedY: navigationBarHeight)
            .contentMode(.topFill)
            .set(height: statusViewHeight, minHeight: cardsItemMinY, onHeightProgress: { [weak self] (progress) in
                self?.updateParallax(progress: progress)
            })
        
        let cardsItem = ParallaxItem.view(cardSlider)
            .set(minY: cardsItemMinY, isRelativeToSafeArea: false)
        
        let dragIndicatorItem = ParallaxItem.view(dragIndicatorContainer)
        
        return Parallax(scrollView: tableView, items: [headerItem, cardsItem, dragIndicatorItem])
    }
    
    func updateParallax(progress: CGFloat) {
        self.parallaxProgress = progress
        let resolvedSecondaryColor = UIColor(hex: "DFCAE4") ?? UIColor.gray
        let resolvedTableColor = UIColor.white
        let backgroundColor = resolvedSecondaryColor.translated(to: resolvedTableColor,
                                                                percentage: 1 - progress)
        
        statusView.superview?.backgroundColor = backgroundColor
        cardSlider.backgroundColor = backgroundColor
        dragIndicatorContainer.dragIndicatorView.alpha = progress
        dragIndicatorContainer.backgroundColor = backgroundColor
        statusView.alpha = progress
        let scaleProgress = 0.5 + progress * 0.5
        statusView.transform = CGAffineTransform.identity.scaledBy(x: scaleProgress, y: scaleProgress)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LessonTableViewCell", for: indexPath) as? LessonTableViewCell else {
                   return .init()
               }
        
        let model = LessonTableViewCellModel(title: "Lesson №\(indexPath.item+1)", subTitle: "Some subtitle", time: 10, icon: "elearning")
        cell.configure(with: model)
                return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
          150
      }
}
