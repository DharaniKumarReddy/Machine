//
//  UIViewControllerExtension.swift
//  Franziskaner Munchen
//
//  Created by Dharani Reddy on 20/04/18.
//  Copyright © 2018 Integro Infotech. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func openWebPage(url: String?) {
        slideMenuController()?.closeLeft()
        let webViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: Constant.ViewControllerWithIdentifier.WebViewController) as! WebViewController
        webViewController.webUrl = url
        (slideMenuController()?.mainViewController as! UINavigationController).pushViewController(webViewController, animated: true)
    }
}
