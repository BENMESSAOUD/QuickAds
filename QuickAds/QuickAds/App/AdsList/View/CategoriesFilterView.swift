//
//  CategoriesView.swift
//  QuickAds
//
//  Created by Mahmoud BEN MESSAOUD on 10/10/2022.
//

import UIKit

/// This model is used to configure a category filter view.
struct CategoriesFilterRow {
    /// The category's id
    let id: Int64
    /// The category's name
    let name: String
    /// Determines whether the filter is selected.
    let isSelected: Bool
}

/// This protocol is used to notify other objects when the categories filter is changed.
protocol CategoriesViewDelegate: AnyObject {
    /// Notifies delegate that a new category filter has been selected.
    /// - Parameter id: The id of the selected category
    func didSelectCategory(id: Int64)
    
    /// Notifies delegate that a category filter has been deselected.
    /// - Parameter id: The id of the deselected category
    func didDeselectCategory(id: Int64)
}

final class CategoriesFilterView: UIScrollView {
    // MARK: Public properties
    weak var categoriesDelegate: CategoriesViewDelegate?
    
    // MARK: Private Properties
    private lazy var stackView: UIStackView = UIStackView()
    
    // MARK: Override methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentSize = stackView.bounds.size
    }
    
    // MARK: Private methods
    private func setupUI() {
        backgroundColor = Colors.secondaryContainer
        showsHorizontalScrollIndicator = false
        stackView.spacing = 10
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .fill
        addSubview(stackView)
        stackView.makeConstraintsToSuperview(constraints: [
            .top(.equals(10)),
            .leading(.equals(10)),
            .bottom(.equals(10))]
        )
    }
    
    // MARK: Public methods
    
    /// Configures the current view with a given filter array.
    /// - Parameter rows: The Categories filter array to display.
    func configure(rows: [CategoriesFilterRow]) {
        stackView.arrangedSubviews.forEach({ $0.removeFromSuperview() })
        rows.forEach({ row in
            let button = CategoryButton(
                title: row.name,
                isSelected: row.isSelected,
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
}
