//
//  AdTableViewCell.swift
//  QuickAds
//
//  Created by Mahmoud BEN MESSAOUD on 09/10/2022.
//

import UIKit

class AdCollectionViewCell: UICollectionViewCell {
    private let viewFactory = ViewFactory()
    private lazy var adImageView: UIImageView = viewFactory.createImage(image: UIImage(named: "noImage"))
    private lazy var adTitleLabel: UILabel = viewFactory.createLabel(size: 14, weight: .medium, color: .black)
    private lazy var adCategoryLabel: UILabel = viewFactory.createLabel(size: 11, weight: .regular, color: .darkGray)
    private lazy var adPriceLabel: UILabel = viewFactory.createLabel(size: 14, weight: .bold, color: .black)
    private lazy var adUrgentLabel: UILabel = viewFactory.createLabel(size: 11, weight: .regular, color: .red)
    private lazy var adDateLabel: UILabel = viewFactory.createLabel(size: 11, weight: .regular, color: .darkGray)
    private lazy var adUrgentView = RoundedView(color: .red, content: adUrgentLabel, padding: 3)
    private lazy var informationView: UIStackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    private func setupUI() {
        adUrgentLabel.text = "Urgent"
        adImageView.layer.cornerRadius = 3
        
        addSubview(adImageView)
        addSubview(informationView)
        informationView.distribution = .fill
        informationView.alignment = .leading
        informationView.axis = .vertical
        informationView.spacing = 2
        informationView.addArrangedSubview(adUrgentView)
        informationView.addArrangedSubview(adTitleLabel)
        informationView.addArrangedSubview(adPriceLabel)
        informationView.addArrangedSubview(adCategoryLabel)
        informationView.addArrangedSubview(adDateLabel)
        adUrgentView.sizeToFit()
        
        addConstraints()
    }
    
    private func addConstraints() {
        adImageView.makeConstraintsToSuperview(constraints: [
            .topToTop(),
            .leadingToLeading(),
            .trailingToTrailing(),
            .height(.equals(150))
        ])
        informationView.makeConstraintsToSuperview(constraints: [
            .leadingToLeading(),
            .trailingToTrailing(),
            .bottomToBottom()
        ])
        informationView.makeConstraints(constraints: [.topToBottom(.equals(4))], view: adImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with model: AdRow) {
        adImageView.asyncImage(url: model.image)
        adTitleLabel.text = model.title
        adCategoryLabel.text = model.category
        adPriceLabel.text = model.price
        adUrgentView.isHidden = !model.isUrgent
        adDateLabel.text = model.date
    }
}
