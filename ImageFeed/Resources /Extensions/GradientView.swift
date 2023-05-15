//
//  GradientService.swift
//  ImageFeed
//
//  Created by Alexey on 24.04.2023.
//

import UIKit

extension UIView {
    func addGradient(topColor: UIColor, botColor: UIColor, gradientLayer: CAGradientLayer) {
        
        let height = self.bounds.height
        let widht = self.bounds.width
        
        gradientLayer.frame  = CGRect(x: 0, y: 0, width: widht, height: height)
        gradientLayer.colors = [topColor.cgColor, botColor.cgColor]
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}
