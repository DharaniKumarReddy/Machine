//
//  HomeViewController.swift
//  Franziskaner Munchen
//
//  Created by Dharani Reddy on 13/04/18.
//  Copyright © 2018 Integro Infotech. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    // MARK:- Variables
    var coverPhotos: [Photo] = []
    // MARK:- IBoutlets
    @IBOutlet private weak var slidingImageView: UIImageView!
    
    // MARK:- Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        getDashboardCover()
        // Do any additional setup after loading the view.
    }
    
    // MARK:- Private Methods
    private func animateImageSlides(images: [UIImage]) {
        slidingImageView.animationImages = images
        slidingImageView.animationDuration = 6.0
        slidingImageView.startAnimating()
    }
    
    private func getDashboardCover() {
        APICaller.getInstance().getDashboardCover(onSuccess: { dashboardCover in
            self.coverPhotos = dashboardCover?.coverPhoto ?? []
            self.downloadImages()
        }, onError: { error in
            
        })
    }
    
    private func downloadImages() {
        var coverPhoto: [UIImage] = []
        for photo in coverPhotos {
            photo.img.downloadImage(completion: { image in
                coverPhoto.append(image)
                if coverPhoto.count == self.coverPhotos.count {
                    DispatchQueue.main.async {
                        self.animateImageSlides(images: coverPhoto)
                    }
                }
            })
        }
    }
}
