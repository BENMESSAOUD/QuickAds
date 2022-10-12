//
//  ConstraintMaker.swift
//  QuickAds
//
//  Created by Mahmoud BEN MESSAOUD on 09/10/2022.
//

import UIKit

/// ConstraintMaker provide a simpler way to make constraints between views.
struct ConstraintMaker {
    
    /// Enumeration of the different constant kind a constraint value could have.
    enum Constant {
        /// The constraint constant is equal to the given value.
        /// - Parameter value: The value of the constraint
        case equals(_ value: CGFloat)
        
        /// The constraint constant is greater or equal to the given value.
        /// - Parameter value: The value of the constraint
        case greaterThanOrEqualTo(_ value: CGFloat)
        
        /// The constraint constant is less or equal to the given value.
        /// - Parameter value: The value of the constraint
        case lessThanOrEqualTo(_ value: CGFloat)
    }
    
    /// Enumeration of the possible connections between tow views
    enum Constraint {
        /// A constraint that relies the top of the first view with the top of the second view
        /// - Parameter constant: the constant value kind of the constraint. By default it equal to `.equals(0)`
        case top(_ constant: Constant = .equals(0))
        
        /// A constraint that relies the top of the first view with the bottom of the second view
        /// - Parameter constant: the constant value kind of the constraint. By default it equal to `.equals(0)`
        case vertical(_ constant: Constant = .equals(0))
        
        /// A constraint that relies the leading edge of the first view with the leading edge of the second view
        /// - Parameter constant: the constant value kind of the constraint. By default it equal to `.equals(0)`
        case leading(_ constant: Constant = .equals(0))
        
        /// A constraint that relies the leading edge of the first view with the trailing edge of the second view
        /// - Parameter constant: the constant value kind of the constraint. By default it equal to `.equals(0)`
        case horizontal(_ constant: Constant = .equals(0))
        
        /// A constraint that relies the trailing edge of the first view with the leading edge of the second view
        /// - Parameter constant: the constant value kind of the constraint. By default it equal to `.equals(0)`
        case trailing(_ constant: Constant = .equals(0))
        
        /// A constraint that relies the bottom of the first view with the bottom of the second view
        /// - Parameter constant: the constant value kind of the constraint. By default it equal to `.equals(0)`
        case bottom(_ constant: Constant = .equals(0))
        
        /// A constraint that relies the X center of the first view with the X center of the second view
        /// - Parameter constant: the constant value kind of the constraint. By default it equal to `.equals(0)`
        case centerX(_ constant: Constant = .equals(0))
        
        /// A constraint that relies the Y center of the first view with the Y center of the second view
        /// - Parameter constant: the constant value kind of the constraint. By default it equal to `.equals(0)`
        case centerY(_ constant: Constant = .equals(0))
        
        /// This constraint kind could be used to define a height constraint for the same view or between two views
        /// - Parameter constant: the constant value kind of the constraint.
        case height(Constant)
        
        /// This constraint kind could be used to define a width constraint for the same view or between two views
        /// - Parameter constant: the constant value kind of the constraint.
        case width(Constant)
    }
    
    // MARK: - Private static methods
    
    /// Makes a constraint between two views
    /// - Parameters:
    ///   - constraint: The constraint kind create between the views
    ///   - firstView: The view that initiate the constraint creation call.
    ///   - secondView: The second view on which the constraint will be created
    private static func makeConstraint(
        constraint: Constraint,
        firstView: UIView,
        secondView: UIView
    ) {
        firstView.translatesAutoresizingMaskIntoConstraints = false
        switch constraint {
        case .top(let constant):
            makeConstraint(firstAnchor: firstView.topAnchor, secondAnchor: secondView.topAnchor, constant: constant).isActive = true
            
        case .vertical(let constant):
            makeConstraint(firstAnchor: firstView.topAnchor, secondAnchor: secondView.bottomAnchor, constant: constant).isActive = true
            
        case .leading(let constant):
            makeConstraint(firstAnchor: firstView.leadingAnchor, secondAnchor: secondView.leadingAnchor, constant: constant).isActive = true
            
        case .horizontal(let constant):
            makeConstraint(firstAnchor: firstView.leadingAnchor, secondAnchor: secondView.trailingAnchor, constant: constant).isActive = true
            
        case .trailing(let constant):
            makeConstraint(firstAnchor: firstView.trailingAnchor, secondAnchor: secondView.trailingAnchor, constant: constant).isActive = true
            
        case .bottom(let constant):
            makeConstraint(firstAnchor: firstView.bottomAnchor, secondAnchor: secondView.bottomAnchor, constant: constant).isActive = true

        case .centerX(let constant):
            makeConstraint(firstAnchor: firstView.centerXAnchor, secondAnchor: secondView.centerXAnchor, constant: constant).isActive = true

        case .centerY(let constant):
            makeConstraint(firstAnchor: firstView.centerYAnchor, secondAnchor: secondView.centerYAnchor, constant: constant).isActive = true

        case .height(let constant):
            makeDimensionConstraint(anchor: firstView.heightAnchor, constant: constant).isActive = true
            
        case .width(let constant):
            makeDimensionConstraint(anchor: firstView.widthAnchor, constant: constant).isActive = true
        }
    }
    
    /// Makes constraint between two `NSLayoutAnchor` with a given constant kind.
    ///
    /// - Parameters:
    ///   - firstAnchor: The layout anchor that initiate the constraint creation call.
    ///   - secondAnchor: The second anchor on which the constraint will be created
    ///   - constant: The constraint kind create between the views
    private static func makeConstraint<AnchorType: AnyObject>(
        firstAnchor: NSLayoutAnchor<AnchorType>,
        secondAnchor: NSLayoutAnchor<AnchorType>,
        constant: ConstraintMaker.Constant
    ) -> NSLayoutConstraint {
        switch constant {
        case let .equals(value):
            return firstAnchor.constraint(equalTo: secondAnchor, constant: value)
        case let .greaterThanOrEqualTo(value):
            return firstAnchor.constraint(greaterThanOrEqualTo: secondAnchor, constant: value)
        case let .lessThanOrEqualTo(value):
            return firstAnchor.constraint(lessThanOrEqualTo: secondAnchor, constant: value)
        }
    }
    
    /// Makes a dimension constraint between two `NSLayoutAnchor` with a given constant kind.
    ///
    /// - Parameters:
    ///   - firstAnchor: The layout anchor that initiate the constraint creation call.
    ///   - secondAnchor: The second anchor on which the constraint will be created
    ///   - constant: The constraint kind create between the views
    private static func makeDimensionConstraint(anchor: NSLayoutDimension ,constant: ConstraintMaker.Constant) -> NSLayoutConstraint {
        switch constant {
        case let .equals(value):
            return anchor.constraint(equalToConstant: value)
        case let .greaterThanOrEqualTo(value):
            return anchor.constraint(greaterThanOrEqualToConstant: value)
        case let .lessThanOrEqualTo(value):
            return anchor.constraint(lessThanOrEqualToConstant: value)
        }
    }
    
    // MARK: - Public static methods
    
    /// Makes a set of constraints between two views
    ///
    /// - Parameters:
    ///   - constraint: The set of constraints kind to create between the views
    ///   - firstView: The view that initiate the constraint creation call.
    ///   - secondView: The second view on which the constraint will be created
    static func makeConstraints(constraints: [Constraint], firstView: UIView, secondView: UIView) {
        constraints.forEach { makeConstraint(constraint: $0, firstView: firstView, secondView: secondView) }
    }
    
    /// Makes a set constraints on one view
    ///
    /// In this method, only the height constraint and the width constraints are handled. If another kind of constraint is passed in the set of the constraints, it will be ignored.
    ///
    /// - Parameters:
    ///   - constraint: The set of constraints kind to create between the views
    ///   - view: The view on which the constraints will applied.
    static func makeConstraints(constraints: [ConstraintMaker.Constraint], view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        constraints.forEach { constraint in
            switch constraint {
            case .height(let constant):
                makeDimensionConstraint(anchor: view.heightAnchor, constant: constant).isActive = true
                
            case .width(let constant):
                makeDimensionConstraint(anchor: view.widthAnchor, constant: constant).isActive = true
                
            default:
                break
            }
        }
    }
}
