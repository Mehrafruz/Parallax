//
//  TableViewCell.swift
//  ParallaxApp
//
//  Created by Mehrafruz on 07.04.2022.
//

import UIKit

struct LessonTableViewCellModel {//CityTableViewCellModel
    let title: String
    let subTitle: String
    let time: Int
    let icon: String
}

class LessonTableViewCell: UITableViewCell {
    
    private lazy var iconImageView: UIImageView = {
        
        var view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 28, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var subTitleLabel: UILabel = {
        
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var timeLabel: UILabel = {
        
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .darkGray
        
        return label
    }()
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    private func setup() {
        
        [iconImageView,
         titleLabel,
         subTitleLabel,
         timeLabel].forEach {
            contentView.addSubview($0) }
        
        addConstraint()
    }
    
    func addConstraint () {
   
        NSLayoutConstraint.activate([
            iconImageView.widthAnchor.constraint(equalToConstant: 100),
            iconImageView.heightAnchor.constraint(equalToConstant: 100),
            iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            iconImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            
            titleLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width-150),
            titleLabel.heightAnchor.constraint(equalToConstant: 30),
            titleLabel.leftAnchor.constraint(equalTo: iconImageView.rightAnchor, constant: 30),
            titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            
            subTitleLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width-150),
            subTitleLabel.heightAnchor.constraint(equalToConstant: 30),
            subTitleLabel.leftAnchor.constraint(equalTo: iconImageView.rightAnchor, constant: 30),
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            
            timeLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width-150),
            timeLabel.heightAnchor.constraint(equalToConstant: 30),
            timeLabel.leftAnchor.constraint(equalTo: iconImageView.rightAnchor, constant: 30),
            timeLabel.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 10)
        ])
    }
    
    func configure(with model: LessonTableViewCellModel) {
        
        iconImageView.image = UIImage(named: model.icon)
        titleLabel.text = model.title
        subTitleLabel.text = model.subTitle
        timeLabel.text = "\(model.time) pm"
    }
}
