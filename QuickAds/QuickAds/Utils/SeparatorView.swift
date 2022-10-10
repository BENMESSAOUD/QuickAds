//
//  SeparatorView.swift
//  QuickAds
//
//  Created by Mahmoud BEN MESSAOUD on 10/10/2022.
//

import Foundation
import UIKit

class SeparatorView: UIView {
    init(verticalPadding: CGFloat = 8, horizontalPadding: CGFloat = 8) {
        super.init(frame: .zero)
        let lineView = UIView()
        lineView.backgroundColor = .lightGray
        addSubview(lineView)
        lineView.makeConstraintsToSuperview(constraints: [
            .topToTop(.equals(verticalPadding)),
            .leadingToLeading(.equals(horizontalPadding)),
            .centerX(),
            .centerY(),
            .height(.equals(1))
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
