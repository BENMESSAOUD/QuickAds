//
//  CategoryButton.swift
//  QuickAds
//
//  Created by Mahmoud BEN MESSAOUD on 11/10/2022.
//

import UIKit

final class CategoryButton: UIView {
    // MARK: Constant
    private enum Constant {
        /// The color used for the selected stats
        static let selectedColor = Colors.primaryOrange
        /// The color used for the deselected stats
        static let deselectedColor = UIColor.clear
    }
    
    // MARK: Private properties
    private let action: (Bool) -> Void
    private var button: UIButton
    
    /// Determines wether the view is selected.
    ///
    /// Each time this property is changed, the view background color, the button title color, and the border appearance this view change according to the new value.
    private var isSelected: Bool {
        didSet {
            updateAppearance()
        }
    }
    
    // MARK: Init & override methods
    
    /// Creates a new instance of `CategoryButton`.
    ///
    /// - Parameter title: The title to display.
    /// - Parameter isSelected: Determines wether the view is selected.
    /// - Parameter action: The triggered action when the button is tapped.
    ///
    init(title: String, isSelected: Bool, action: @escaping (Bool) -> Void) {
        self.action = action
        self.isSelected = isSelected
        button = UIButton(type: .custom)
        super.init(frame: .zero)
        button.setTitle(title, for: .normal)
        button.addTarget(self, action: #selector(didTouchUpInside), for: .touchUpInside)
        addSubview(button)
        button.makeConstraintsToSuperview(constraints: [
            .top(.equals(2)),
            .leading(.equals(12)),
            .centerY(),
            .centerX()
        ])
        layer.borderColor = Colors.primaryBlack.cgColor
        updateAppearance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height/2
    }
    
    // MARK: Private methods
    
    @objc
    private func didTouchUpInside() {
        isSelected.toggle()
        action(isSelected)
    }
    
    /// Update view's looks and feel according to the selection stat
    private func updateAppearance() {
        backgroundColor = isSelected ? Constant.selectedColor : Constant.deselectedColor
        button.setTitleColor(isSelected ? .white : Colors.primaryBlack, for: .normal)
        layer.borderWidth = isSelected ? 0 : 1
    }
}
