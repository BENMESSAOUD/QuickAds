//
//  CategoryButton.swift
//  QuickAds
//
//  Created by Mahmoud BEN MESSAOUD on 11/10/2022.
//

import Foundation
import UIKit

class CategoryButton: UIView {
    private enum Constant {
        static let selectedColor = UIColor.blue
        static let deselectedColor = UIColor.lightGray
    }
    private let action: (Bool) -> Void
    private var button: UIButton
    override init(title: String, action: @escaping (Bool) -> Void) {
        self.action = action
        let button = UIButton(type: .custom)
        button.setTitle(title, for: .normal)
        button.titleEdgeInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
        button.backgroundColor = Constant.deselectedColor
        button.addTarget(self, action: #selector(didTouchUpInside), for: .touchUpInside)
        super.init(frame: .zero)
        addSubview(button)
        button.makeConstraintEqualToSuperview()
        prepareView()
    }
    
    private func prepareView() {
        layer.borderColor = UIColor.darkGray.cgColor
        layer.borderWidth = 1
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowRadius = 1
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height/2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func didTouchUpInside() {
        button.isSelected.toggle()
        button.backgroundColor = button.isSelected ? Constant.selectedColor : Constant.deselectedColor
        action(button.isSelected)
    }
}
