//
//  UIViewExtension.swift
//  Franziskaner Munchen
//
//  Created by Dharani Reddy on 21/04/18.
//  Copyright © 2018 Integro Infotech. All rights reserved.
//

import Foundation
import UIKit

class GrayBorderView: UIView {
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.borderWidth = 3
        layer.borderColor = UIColor(red: 191/255, green: 191/255, blue: 191/255, alpha: 1.0).cgColor
    }
}

extension UIView {
    func addBorder(color: CGColor) {
        layer.borderColor = color
        layer.borderWidth = 3
    }
}
