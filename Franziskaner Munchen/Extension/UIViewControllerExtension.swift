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
    
    func openMagazines(_ magazines : [Magazine]) {
        let magazineController = UIStoryboard(name: Constant.StoryBoard.Main, bundle: Bundle.main).instantiateViewController(withIdentifier: String(describing: MagazinesViewController.self)) as! MagazinesViewController
        magazineController.magazines = magazines
        navigationController?.pushViewController(magazineController, animated: true)
    }
    
    func showAlertViewController(_ title: String, message: String, cancelButton: String, destructiveButton: String!, otherButtons:String!, onDestroyAction: @escaping OnDestroySuccess, onCancelAction: @escaping OnCancelSuccess) {
        
        let alertController = UIAlertController(title: NSLocalizedString(title, comment: ""), message: NSLocalizedString(message, comment: ""), preferredStyle: .alert)
        let cancelAction    = UIAlertAction(title: NSLocalizedString(cancelButton, comment: ""), style: .cancel) { alertAction in
            onCancelAction()
        }
        alertController.addAction(cancelAction)
        
        var alertAction:UIAlertAction!
        
        if let nonDestructiveButton = otherButtons {
            alertAction = UIAlertAction(title: nonDestructiveButton, style: .default) { alertAction in
                onDestroyAction()
            }
            alertController.addAction(alertAction)
        } else if let destructiveButton = destructiveButton {
            // Apple says when most likely button is destructive it should be on the left
            alertAction = UIAlertAction(title: NSLocalizedString(destructiveButton, comment: ""), style: .destructive) { alertAction in
                onDestroyAction()
            }
            alertController.addAction(alertAction)
        }
        
        if let topViewController = UIApplication.topViewController() {
            topViewController.present(alertController, animated: true)
        }
    }
}
