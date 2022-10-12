//
//  UIView+ConstraintMaker.swift
//  QuickAds
//
//  Created by Mahmoud BEN MESSAOUD on 12/10/2022.
//

import UIKit

/// This extension provide a set of method to create constraints between two view by using the `ConstraintMaker` structure.
extension UIView {
    
    /// Makes a set constraints between the current view and another given view.
    ///
    /// - Parameters:
    ///   - constraints: The constraints set to create between the views
    ///   - view: The view on which the constraint will be created
    func makeConstraints(constraints: [ConstraintMaker.Constraint], view: UIView) {
        ConstraintMaker.makeConstraints(constraints: constraints, firstView: self, secondView: view)
    }
    
    /// Makes a set constraints between the current view and its  superview.
    ///
    /// - Parameters:
    ///   - constraints: the constraints set to create between the views
    ///   - view: The view on which the constraint will be created
    func makeConstraintsToSuperview(constraints: [ConstraintMaker.Constraint]) {
        guard let superview = superview else { return }
        makeConstraints(constraints: constraints, view: superview)
    }
    
    /// Makes a set constraints equals to the edges of the superview with a given padding
    ///
    /// - Parameters:
    ///   - padding: The padding to apply on constraints. 0 by default.
    func makeConstraintEqualToSuperview(padding: CGFloat = 0) {
        let constraints: [ConstraintMaker.Constraint] = [
            .top(.equals(padding)),
            .leading(.equals(padding)),
            .bottom(.equals(padding)),
            .trailing(.equals(padding))
        ]
        makeConstraintsToSuperview(constraints: constraints)
    }
    
    /// Makes a set constraints on the current view
    ///
    /// - Parameters:
    ///   - constraints: the constraints set to create.
    func makeConstraints(constraints: [ConstraintMaker.Constraint]) {
        ConstraintMaker.makeConstraints(constraints: constraints, view: self)
    }

}

