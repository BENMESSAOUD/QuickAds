//
//  CategoriesView.swift
//  QuickAds
//
//  Created by Mahmoud BEN MESSAOUD on 10/10/2022.
//

import Foundation
import UIKit

struct CategoriesFilterRow {
    let id: Int64
    let name: String
}

protocol CategoriesViewDelegate: AnyObject {
    func didSelectCategory(id: Int64)
    func didDeselectCategory(id: Int64)
}

final class CategoriesFilterView: UIScrollView {
    private lazy var stackView: UIStackView = UIStackView()
    weak var categoriesDelegate: CategoriesViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    private func setupUI() {
        stackView.spacing = 10
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .leading
        addSubview(stackView)
        stackView.makeConstraintsToSuperview(constraints: [
            .topToTop(),
            .leadingToLeading(),
            .bottomToBottom()]
        )
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(rows: [CategoriesFilterRow]) {
        stackView.arrangedSubviews.forEach({ $0.removeFromSuperview() })
        rows.forEach({ row in
            let button = CategoryButton(
                title: row.name,
                action: { [weak self] isSelected in
                    if isSelected {
                        self?.categoriesDelegate?.didSelectCategory(id: row.id)
                    } else {
                        self?.categoriesDelegate?.didDeselectCategory(id: row.id)
                    }
                }
            )
            self.stackView.addArrangedSubview(button)
        })
    }
    
    @objc
    func didTapOnCategory(index: Int) {
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentSize = stackView.intrinsicContentSize
    }
}
