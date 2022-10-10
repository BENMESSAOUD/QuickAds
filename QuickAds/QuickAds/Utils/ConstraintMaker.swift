//
//  ConstraintMaker.swift
//  QuickAds
//
//  Created by Mahmoud BEN MESSAOUD on 09/10/2022.
//

import Foundation
import UIKit

struct ConstraintMaker {
    
    enum Constant {
        case equals(_ constant: CGFloat)
        case greaterThanOrEqualTo(_ constant: CGFloat)
        case lessThanOrEqualTo(_ constant: CGFloat)
    }
    
    enum Constraint {
        case topToTop(_ constant: Constant = .equals(0))
        case topToBottom(_ constant: Constant = .equals(0))
        case leadingToLeading(_ constant: Constant = .equals(0))
        case leadingToTrailing(_ constant: Constant = .equals(0))
        case trailingToLeading(_ constant: Constant = .equals(0))
        case trailingToTrailing(_ constant: Constant = .equals(0))
        case bottomToTop(_ constant: Constant = .equals(0))
        case bottomToBottom(_ constant: Constant = .equals(0))
        case centerX(_ constant: Constant = .equals(0))
        case centerY(_ constant: Constant = .equals(0))
        case height(Constant)
        case width(Constant)
    }
    
    private static func makeConstraint(constraint: Constraint, firstView:UIView, secondView: UIView) {
        firstView.translatesAutoresizingMaskIntoConstraints = false
        switch constraint {
        case .topToTop(let constant):
            makeConstraint(firstAnchor: firstView.topAnchor, secondAnchor: secondView.topAnchor, constant: constant).isActive = true
            
        case .topToBottom(let constant):
            makeConstraint(firstAnchor: firstView.topAnchor, secondAnchor: secondView.bottomAnchor, constant: constant).isActive = true
            
        case .leadingToLeading(let constant):
            makeConstraint(firstAnchor: firstView.leadingAnchor, secondAnchor: secondView.leadingAnchor, constant: constant).isActive = true
            
        case .leadingToTrailing(let constant):
            makeConstraint(firstAnchor: firstView.leadingAnchor, secondAnchor: secondView.trailingAnchor, constant: constant).isActive = true
            
        case .trailingToLeading(let constant):
            makeConstraint(firstAnchor: firstView.trailingAnchor, secondAnchor: secondView.leadingAnchor, constant: constant).isActive = true
            
        case .trailingToTrailing(let constant):
            makeConstraint(firstAnchor: firstView.trailingAnchor, secondAnchor: secondView.trailingAnchor, constant: constant).isActive = true
            
        case .bottomToTop(let constant):
            makeConstraint(firstAnchor: firstView.bottomAnchor, secondAnchor: secondView.topAnchor, constant: constant).isActive = true
            
        case .bottomToBottom(let constant):
            makeConstraint(firstAnchor: firstView.bottomAnchor, secondAnchor: secondView.bottomAnchor, constant: constant).isActive = true

        case .centerX(let constant):
            makeConstraint(firstAnchor: firstView.centerXAnchor, secondAnchor: secondView.centerXAnchor, constant: constant).isActive = true

        case .centerY(let constant):
            makeConstraint(firstAnchor: firstView.centerYAnchor, secondAnchor: secondView.centerYAnchor, constant: constant).isActive = true

        case .height(let constant):
            makeDemensionConstraint(anchor: firstView.heightAnchor, constant: constant).isActive = true
            
        case .width(let constant):
            makeDemensionConstraint(anchor: firstView.widthAnchor, constant: constant).isActive = true
        }
    }
    
    private static func makeConstraint<AnchorType: AnyObject>(firstAnchor: NSLayoutAnchor<AnchorType>, secondAnchor: NSLayoutAnchor<AnchorType> ,constant: ConstraintMaker.Constant) -> NSLayoutConstraint {
        switch constant {
        case let .equals(value):
            return firstAnchor.constraint(equalTo: secondAnchor, constant: value)
        case let .greaterThanOrEqualTo(value):
            return firstAnchor.constraint(greaterThanOrEqualTo: secondAnchor, constant: value)
        case let .lessThanOrEqualTo(value):
            return firstAnchor.constraint(lessThanOrEqualTo: secondAnchor, constant: value)
        }
    }
    
    private static func makeDemensionConstraint(anchor: NSLayoutDimension ,constant: ConstraintMaker.Constant) -> NSLayoutConstraint {
        switch constant {
        case let .equals(value):
            return anchor.constraint(equalToConstant: value)
        case let .greaterThanOrEqualTo(value):
            return anchor.constraint(greaterThanOrEqualToConstant: value)
        case let .lessThanOrEqualTo(value):
            return anchor.constraint(lessThanOrEqualToConstant: value)
        }
    }
    
    static func makeConstraints(constraints: [Constraint], firstView:UIView, secondView: UIView) {
        constraints.forEach { makeConstraint(constraint: $0, firstView: firstView, secondView: secondView) }
    }
}

extension UIView {
    func makeConstraints(constraints: [ConstraintMaker.Constraint], view: UIView) {
        ConstraintMaker.makeConstraints(constraints: constraints, firstView: self, secondView: view)
    }
    
    func makeConstraintsToSuperview(constraints: [ConstraintMaker.Constraint]) {
        guard let superview = superview else { return }
        makeConstraints(constraints: constraints, view: superview)
    }
    
    func makeConstraintEqualToSuperview(padding: CGFloat = 0) {
        let constraints: [ConstraintMaker.Constraint] = [
            .topToTop(.equals(padding)),
            .leadingToLeading(.equals(padding)),
            .bottomToBottom(.equals(padding)),
            .trailingToTrailing(.equals(padding))
        ]
        makeConstraintsToSuperview(constraints: constraints)
    }

}
