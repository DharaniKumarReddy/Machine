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
    @IBOutlet private weak var bottomHalfTopConstrait: NSLayoutConstraint!
    
    // MARK:- Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        getDashboardCover()
        bottomHalfTopConstrait.constant = iPhonePlus ? 30 : 16
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
    
    // MARK:- IBActions
    @IBAction private func galleryButton_Tapped() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        let photoAction = UIAlertAction(title: "Photo", style: .default) { action in
            let photoController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PhotosViewController")
            self.navigationController?.pushViewController(photoController, animated: true)
        }
        actionSheet.addAction(photoAction)
        let videoAction = UIAlertAction(title: "Video", style: .default) { action in
            let videoController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "VideosViewController")
            self.navigationController?.pushViewController(videoController, animated: true)
        }
        actionSheet.addAction(videoAction)
        present(actionSheet, animated: true, completion: nil)
    }
    
    @IBAction private func enquiryButton_Tapped() {
        openWebPage(url: "http://testlink4clients.com/testlink/franziskaner/contact.php")
    }
    
}
