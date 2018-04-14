//
//  HomeViewController.swift
//  Franziskaner Munchen
//
//  Created by Dharani Reddy on 13/04/18.
//  Copyright © 2018 Integro Infotech. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    // MARK:- IBoutlets
    @IBOutlet private weak var slidingImageView: UIImageView!
    
    // MARK:- Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateImageSlides()
    }
    
    private func animateImageSlides() {
        slidingImageView.animationImages = [#imageLiteral(resourceName: "Stone"), #imageLiteral(resourceName: "Woman_slide"), #imageLiteral(resourceName: "Coffee")]
        slidingImageView.animationDuration = 6.0
        slidingImageView.startAnimating()
    }
}
