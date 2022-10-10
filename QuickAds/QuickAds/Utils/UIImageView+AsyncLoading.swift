//
//  UIImageView+AsyncLoading.swift
//  QuickAds
//
//  Created by Mahmoud BEN MESSAOUD on 09/10/2022.
//

import Foundation
import UIKit

extension UIImageView {
    func asyncImage(url: URL?) {
        if let url = url{
            let loader = UIActivityIndicatorView(style: .medium)
            addSubview(loader)
            loader.makeConstraintsToSuperview(constraints: [.centerY(), .centerX()])
            loader.startAnimating()
            
            DispatchQueue.global(qos: .utility).async {
                do {
                    let data = try Data(contentsOf: url)
                    DispatchQueue.main.async {
                        self.image = UIImage(data: data)
                        loader.stopAnimating()
                        loader.removeFromSuperview()
                    }
                    
                } catch {
                    DispatchQueue.main.async {
                        loader.stopAnimating()
                        loader.removeFromSuperview()
                    }
                }
            }
        }
    }
}
