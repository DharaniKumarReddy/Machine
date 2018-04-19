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
}
