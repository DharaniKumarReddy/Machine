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
        let webViewController = UIStoryboard(name: Constant.StoryBoard.Main, bundle: Bundle.main).instantiateViewController(withIdentifier: String(describing: MyWebViewController.self)) as! MyWebViewController
        webViewController.webUrl = url
        (slideMenuController()?.mainViewController as! UINavigationController).pushViewController(webViewController, animated: true)
    }
}
