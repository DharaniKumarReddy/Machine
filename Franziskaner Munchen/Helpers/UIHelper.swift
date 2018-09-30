//
//  UIHelper.swift
//  Franziskaner Munchen
//
//  Created by Dharani Reddy on 27/09/18.
//  Copyright © 2018 Integro Infotech. All rights reserved.
//

import Foundation
import UIKit

class UIHelper {
    static let shared = UIHelper()
    
    private let window = UIApplication.shared.keyWindow
    
    private let navigationBarHeight: CGFloat = 40
    private let tabBarHeight: CGFloat = 60
    
    private func topSareArea(_ view: UIView) -> CGFloat {
        if #available(iOS 11.0, *) {
            return window?.safeAreaInsets.top ?? 20
        } else {
            return view.layoutMargins.top
        }
    }
    
    private func bottomSareArea(_ view: UIView) -> CGFloat {
        if #available(iOS 11.0, *) {
            return window?.safeAreaInsets.bottom ?? 0
        } else {
            return view.layoutMargins.bottom
        }
    }
    
    internal func getDashboardContainerHeight(_ view: UIView) -> CGFloat {
        return screenHeight - (topSareArea(view) + navigationBarHeight + tabBarHeight + bottomSareArea(view))
    }
}
