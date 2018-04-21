//
//  HomeViewController.swift
//  Franziskaner Munchen
//
//  Created by Dharani Reddy on 13/04/18.
//  Copyright © 2018 Integro Infotech. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

let screenWidth     = UIScreen.main.bounds.width
let screenHeight    = UIScreen.main.bounds.height
//let iPhoneX         = screenHeight == 812.0
let iPhonePlus      = screenHeight == 736.0

class DashboardViewController: UIViewController {
    
    // MARK:- Variables
    private var currentIndex = 0
    private var tabs: [UIViewController] = []
    
    // MARK:- IBOutlets
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var tabBarView: UIView!
    @IBOutlet private weak var indicatorLeadingConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.isNavigationBarHidden = true
        navigationController?.navigationBar.tintColor = .white
        tabs = [loadHome(), loadNews(), loadNotifications(), loadWeb()]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.isNavigationBarHidden = false
        containerView.isHidden = false
        tabBarView.isHidden = false
    }
    
    // MARK:- Bar Button Action
    @IBAction func menuButton_Tapped(_ sender: Any) {
        slideMenuController()?.changeLeftViewWidth(screenWidth-screenWidth/5)
        SlideMenuOptions.contentViewScale = 1
        (slideMenuController()?.leftViewController as! MenuViewController).shouldAnimate = true
        slideMenuController()?.openLeft()
    }
    
    // MARK:- IBActions
    @IBAction func tabBarButtons_Tapped(button: UIButton) {
        animateIndicator(position: CGFloat(button.tag) * button.frame.size.width)
        loadTabs(index: button.tag)
    }
    
    @IBAction func swipeGestureRecognizer(swipeGesture: UISwipeGestureRecognizer) {
        let direction = swipeGesture.direction
        if (indicatorLeadingConstraint.constant <= 0 && direction == .right) || (indicatorLeadingConstraint.constant >= screenWidth-screenWidth/4 && direction == .left) {
            return
        }
        let position = direction == .left ? indicatorLeadingConstraint.constant + screenWidth/4 : indicatorLeadingConstraint.constant - screenWidth/4
        animateIndicator(position: position)
        loadTabs(index: Int(roundf(Float(position/(screenWidth/4)))))
    }
    
    // MARK:- Private Methods
    private func animateIndicator(position: CGFloat) {
        UIView.animate(withDuration: 0.3, animations: {
            self.indicatorLeadingConstraint.constant = position
            self.view.layoutIfNeeded()
        })
    }
    
    private func loadTabs(index: Int) {
        guard index != currentIndex else {
            return
        }
        loadContainer(controller: tabs[index])
        currentIndex = index
    }
    
    private func loadHome() -> UIViewController {
        return UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: Constant.ViewControllerWithIdentifier.HomeViewController)
    }
    
    private func loadNews() -> UIViewController {
        return UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: Constant.ViewControllerWithIdentifier.NewsViewController)
    }
    
    private func loadNotifications() -> UIViewController {
        return UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: Constant.ViewControllerWithIdentifier.NotificationsViewController)
    }
    
    private func loadWeb() -> UIViewController {
        return UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: Constant.ViewControllerWithIdentifier.WebViewController)
    }
    
    private func loadContainer(controller: UIViewController) {
        addChildViewController(controller)
        view.addSubview(controller.view)
        controller.view.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight-60)
        controller.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        controller.didMove(toParentViewController: self)
    }
}
