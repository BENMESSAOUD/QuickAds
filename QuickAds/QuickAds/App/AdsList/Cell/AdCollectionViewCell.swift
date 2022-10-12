//
//  AdTableViewCell.swift
//  QuickAds
//
//  Created by Mahmoud BEN MESSAOUD on 09/10/2022.
//

import UIKit

class AdCollectionViewCell: UICollectionViewCell {
    // MARK: Private properties
    private let viewFactory = ViewFactory()
    
    // MARK: UI Components
    private lazy var adImageView: UIImageView = viewFactory.createImage(image: UIImage(named: "noImage"))
    private lazy var adTitleLabel: UILabel = viewFactory.createLabel(size: 14, weight: .medium, color: Colors.primaryBlue)
    private lazy var adCategoryLabel: UILabel = viewFactory.createLabel(size: 11, weight: .regular, color: Colors.primaryGray)
    private lazy var adPriceLabel: UILabel = viewFactory.createLabel(size: 14, weight: .bold, color: Colors.primaryOrange)
    private lazy var adUrgentLabel: UILabel = viewFactory.createLabel(size: 11, weight: .regular, color: .red)
    private lazy var adDateLabel: UILabel = viewFactory.createLabel(size: 11, weight: .regular, color: Colors.primaryGray)
    private lazy var adUrgentView = viewFactory.createRoundedContainerView(content: adUrgentLabel, borderColor: .red)
    private lazy var informationView: UIStackView = UIStackView()
    
    // MARK: Inits
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Private methods

    private func setupUI() {
        adUrgentLabel.text = "Urgent"
        adImageView.layer.cornerRadius = 5
        
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
        
        addConstraints()
    }
    
    /// Add constraint between diffrent components
    private func addConstraints() {
        adImageView.makeConstraintsToSuperview(constraints: [
            .top(),
            .leading(),
            .trailing()
        ])
        adImageView.makeConstraints(constraints: [.height(.equals(150))])
        informationView.makeConstraintsToSuperview(constraints: [
            .leading(),
            .trailing(),
            .bottom()
        ])
        informationView.makeConstraints(constraints: [.vertical(.equals(4))], view: adImageView)
    }

    // MARK: Public methods
    
    /// Configures the collection view cell with a given `AdRow` model
    /// - Parameter model: The ad row model.
    func configure(with model: AdRow) {
        adImageView.asyncImage(url: model.image)
        adTitleLabel.text = model.title
        adCategoryLabel.text = model.category
        adPriceLabel.text = model.price
        adUrgentView.isHidden = !model.isUrgent
        adDateLabel.text = model.date
    }
}
