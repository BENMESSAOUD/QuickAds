//
//  ViewFactory.swift
//  QuickAds
//
//  Created by Mahmoud BEN MESSAOUD on 09/10/2022.
//

import Foundation
import UIKit

struct ViewFactory {
    
    func createLabel(size: CGFloat, weight: UIFont.Weight, color: UIColor) -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: size, weight: weight)
        label.textColor = color
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        label.lineBreakStrategy = .pushOut
        return label
    }
    
    func createImage(image: UIImage? = nil) -> UIImageView {
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }
}
