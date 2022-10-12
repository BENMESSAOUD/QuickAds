//
//  ViewFactory.swift
//  QuickAds
//
//  Created by Mahmoud BEN MESSAOUD on 09/10/2022.
//

import UIKit

/// This Factory provide a simpler way to create view and avoid code duplication.
struct ViewFactory {
    
    /// Creates an UILabel.
    ///
    /// - Parameters:
    ///   - size: The text size
    ///   - view: The font weight
    ///   - color: The text color
    ///
    /// - Returns A newly created UILabel
    func createLabel(size: CGFloat, weight: UIFont.Weight, color: UIColor) -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: size, weight: weight)
        label.textColor = color
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        label.lineBreakStrategy = .pushOut
        return label
    }
    
    /// Creates an UIImageView.
    ///
    /// - Parameters:
    ///   - image: The UIImage. nil by default
    ///
    /// - Returns A newly created UIImageView
    func createImage(image: UIImage? = nil) -> UIImageView {
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }
    
    /// Creates view that contains s separator.
    ///
    /// - Parameters:
    ///   - verticalPadding: The vertical padding of the separator from its superview. 8 by default.
    ///   - horizontalPadding: The horizontal padding of the separator from its superview. 8 by default.
    ///
    /// - Returns A newly created separator view.
    func createSeparatorView(
        verticalPadding: CGFloat = 8,
        horizontalPadding: CGFloat = 8
    ) -> UIView {
        let contentView = UIView()
        let lineView = UIView()
        lineView.backgroundColor = .lightGray
        contentView.addSubview(lineView)
        lineView.makeConstraintsToSuperview(constraints: [
            .top(.equals(verticalPadding)),
            .leading(.equals(horizontalPadding)),
            .centerX(),
            .centerY()
        ])
        lineView.makeConstraints(constraints: [.height(.equals(1))])
        return contentView
    }
    
    /// Creates a bordred view with rounded corners containing a given view inside.
    ///
    /// - Parameters:
    ///   - content: The view to insert inside the rounded view
    ///   - borderColor: The boder color. `Colors.primaryBlack` by default
    ///   - padding: The padding to apply between the view and its content. 3 By default
    ///
    /// - Returns A newly created rounded view.
    func createRoundedContainerView(
        content: UIView,
        borderColor: UIColor = Colors.primaryBlack,
        padding: CGFloat = 3
    ) -> UIView {
        let containerView = UIView()
        containerView.layer.borderColor = borderColor.cgColor
        containerView.layer.borderWidth = 1
        containerView.layer.cornerRadius = 3
        containerView.addSubview(content)
        content.makeConstraintsToSuperview(constraints: [
            .top(.equals(padding)),
            .leading(.equals(padding)),
            .centerX(),
            .centerY()
        ])
        
        return containerView
    }
}
