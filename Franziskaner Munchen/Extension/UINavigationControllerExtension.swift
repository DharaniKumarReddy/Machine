//
//  UINavigationControllerExtension.swift
//  Franziskaner Munchen
//
//  Created by Dharani Reddy on 21/04/18.
//  Copyright © 2018 Integro Infotech. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationItem {
    func addTitleView() {
        let logoImageView = UIImageView(image: #imageLiteral(resourceName: "logo"))
        titleView = logoImageView
    }
}
