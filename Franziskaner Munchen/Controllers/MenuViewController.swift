//
//  MenuViewController.swift
//  Franziskaner Munchen
//
//  Created by Dharani Reddy on 13/04/18.
//  Copyright © 2018 Integro Infotech. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    // MARK:- IBOutlets
    @IBOutlet private weak var landscapeImageLeadingConstraint: NSLayoutConstraint!
    
    // MARK:- Variables
    internal var shouldAnimate = false
    private var isAnimating = false
    
    // MARK:- Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        shouldAnimate = false
    }
    
    // MARK:- Private Methods
    private func animation() {
        guard (shouldAnimate && landscapeImageLeadingConstraint.constant == 0 && !isAnimating) else {
            return
        }
        isAnimating = true
        UIView.animate(withDuration: 50, animations: {
            self.landscapeImageLeadingConstraint.constant = -623+screenWidth-screenWidth/5
            self.view.layoutIfNeeded()
        }, completion: { _ in
            guard self.landscapeImageLeadingConstraint.constant == -623+screenWidth-screenWidth/5 else {
                self.isAnimating = false
                return }
            UIView.animate(withDuration: 50, animations: {
                self.landscapeImageLeadingConstraint.constant = 0
                self.view.layoutIfNeeded()
            }, completion: { _ in
                self.isAnimating = false
                guard (self.landscapeImageLeadingConstraint.constant == 0 && self.shouldAnimate) else {
                    return }
                self.animation()
            })
        })
    }
    
    // MARK:- IBActions
    @IBAction private func direktorButton_Tapped() {
        openWebPage(url: "http://franciscansmunich.com/alfonsschumacher.html")
    }
    
    @IBAction private func missionTeamButton_Tapped() {
        openWebPage(url: Route.missionsTeam.absoluteURL.absoluteString)
    }
    
    @IBAction private func callButton_Tapped() {
        let number = "08921126110"
        if let url = URL(string: "telprompt:\(number)") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    @IBAction private func mailButton_Tapped(button: UIButton) {
        let email = "muenchen@franziskanermission.de"
        if let url = URL(string: "mailto:\(email)") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
}
