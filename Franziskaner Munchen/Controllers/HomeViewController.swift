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
    private var coverPhotos: [Photo] = []
    private var magazines: [Magazine] = []
    
    // MARK:- IBoutlets
    @IBOutlet private weak var slidingImageView: UIImageView!
    @IBOutlet private weak var magazineButton: UIButton!
    @IBOutlet private weak var logoHalfTopConstrait: NSLayoutConstraint!
    @IBOutlet private weak var magazineTopConstrait: NSLayoutConstraint!
    @IBOutlet private weak var bottomHalfTopConstrait: NSLayoutConstraint!
    @IBOutlet private weak var logoHalfBottomConstrait: NSLayoutConstraint!
    @IBOutlet private weak var slidingImageViewHeightConstrait: NSLayoutConstraint!
    
    // MARK:- Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        getDashboardCover()
        getMagazines()
        bottomHalfTopConstrait.constant = iPhonePlus ? 30 : 16
        magazineTopConstrait.constant = iPhoneX ? 5 : 1.5
        if iPhoneSE {
            logoHalfTopConstrait.constant = -4
            logoHalfBottomConstrait.constant = -4
            slidingImageViewHeightConstrait.constant = 220
            bottomHalfTopConstrait.constant = 9
            magazineTopConstrait.constant = 2
        }
        magazineButton.addBorder(color: UIColor.white.cgColor)
        // Do any additional setup after loading the view.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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
    
    private func getMagazines() {
        APICaller.getInstance().getMagazines(onSuccess: { magazines in
            self.magazines = magazines?.magazines ?? []
            self.magazines.sort{ $0.date.compare($1.date) == .orderedDescending }
            self.magazines.first?.image.downloadImage(completion: { image in
                DispatchQueue.main.async {
                    self.magazineButton.setImage(image, for: .normal)
                }
            })
        }, onError: { error in
            
        })
    }
    
    // MARK:- IBActions
    @IBAction private func galleryButton_Tapped() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        let photoAction = UIAlertAction(title: "Fotos", style: .default) { action in
            let photoController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PhotosViewController")
            self.navigationController?.pushViewController(photoController, animated: true)
        }
        actionSheet.addAction(photoAction)
        let videoAction = UIAlertAction(title: "Video", style: .default) { action in
            let videoController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "VideosViewController")
            self.navigationController?.pushViewController(videoController, animated: true)
        }
        actionSheet.addAction(videoAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {_ in
            
        })
        actionSheet.addAction(cancelAction)
        present(actionSheet, animated: true, completion: nil)
    }
    
    @IBAction private func enquiryButton_Tapped() {
        openWebPage(url: "http://testlink4clients.com/testlink/franziskaner/contact.php")
    }
    
    @IBAction private func spendenButton_Tapped() {
        openWebPage(url: "http://franciscansmunich.com/donate.html")
    }
    
    @IBAction private func magazineButton_Tapped() {
        openMagazines(self.magazines)
    }
    
    @IBAction private func socialButton_Tapped() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        let facebookAction = UIAlertAction(title: "Facebook", style: .default, handler: { _ in
            self.openWebPage(url: "https://www.facebook.com/Franziskanermissionmuenchen/?ref=hl")
        })
        facebookAction.setValue(#imageLiteral(resourceName: "facebook"), forKey: "image")
        alert.addAction(facebookAction)
        
        let twitterAction = UIAlertAction(title: "Twitter", style: .default, handler: { _ in
            
        })
        twitterAction.setValue(#imageLiteral(resourceName: "twitter"), forKey: "image")
        alert.addAction(twitterAction)
        
        let youtubeAction = UIAlertAction(title: "Youtube", style: .default, handler: { _ in
            
        })
        youtubeAction.setValue(#imageLiteral(resourceName: "youtube"), forKey: "image")
        alert.addAction(youtubeAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            
        })
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    // MARK:- Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationController = segue.destination as! ProjectViewController
        switch segue.identifier ?? "" {
        case "Project":
            destinationController.projectType = .project
        case "Bolivien":
            destinationController.projectType = .bolivien
        default:
            destinationController.projectType = .mission
        }
    }
}
