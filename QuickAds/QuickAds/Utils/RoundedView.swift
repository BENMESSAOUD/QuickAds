//
//  RoundedView.swift
//  QuickAds
//
//  Created by Mahmoud BEN MESSAOUD on 10/10/2022.
//

import Foundation
import UIKit

class RoundedView: UIView {
    init(color: UIColor, content: UIView?,  padding: CGFloat = 0) {
        super.init(frame: .zero)
        layer.borderColor = color.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 3
        if let content = content {
            addSubview(content)
            content.makeConstraintsToSuperview(constraints: [
                .topToTop(.equals(padding)),
                .leadingToLeading(.equals(padding)),
                .centerX(),
                .centerY()
            ])
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        sizeToFit()
    }
}
