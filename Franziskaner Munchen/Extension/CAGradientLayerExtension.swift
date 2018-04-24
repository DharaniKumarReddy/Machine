//
//  CAGradientLayerExtension.swift
//  Franziskaner Munchen
//
//  Created by Dharani Reddy on 21/04/18.
//  Copyright © 2018 Integro Infotech. All rights reserved.
//

import Foundation
import UIKit

extension CAGradientLayer {
    
    class func applyOverLay(bounds: CGRect, startColor: UIColor, endColor: UIColor, startPoint: CGPoint, endPoint: CGPoint) -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        return gradientLayer
    }
}
