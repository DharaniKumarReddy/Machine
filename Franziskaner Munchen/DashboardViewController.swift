//
//  HomeViewController.swift
//  Franziskaner Munchen
//
//  Created by Dharani Reddy on 13/04/18.
//  Copyright © 2018 Integro Infotech. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

let screenWidth = UIScreen.main.bounds.width

class DashboardViewController: UIViewController {
    
    // MARK:- IBOutlets
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var tabBarView: UIView!
    @IBOutlet private weak var indicatorLeadingConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.isNavigationBarHidden = true
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
    }
    
    @IBAction func swipeGestureRecognizer(swipeGesture: UISwipeGestureRecognizer) {
        let direction = swipeGesture.direction
        if (indicatorLeadingConstraint.constant <= 0 && direction == .right) || (indicatorLeadingConstraint.constant >= screenWidth-screenWidth/4 && direction == .left) {
            return
        }
        let position = direction == .left ? indicatorLeadingConstraint.constant + screenWidth/4 : indicatorLeadingConstraint.constant - screenWidth/4
        animateIndicator(position: position)
    }
    
    // MARK:- Private Methods
    private func animateIndicator(position: CGFloat) {
        UIView.animate(withDuration: 0.3, animations: {
            self.indicatorLeadingConstraint.constant = position
            self.view.layoutIfNeeded()
        })
    }
    
    private func loadHome() {
        
    }
    
    private func loadNews() {
        
    }
    
    private func loadNotifications() {
        
    }
    
    private func loadWeb() {
        
    }
}
