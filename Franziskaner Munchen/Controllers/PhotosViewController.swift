//
//  PhotosViewController.swift
//  Franziskaner Munchen
//
//  Created by Dharani Reddy on 20/04/18.
//  Copyright © 2018 Integro Infotech. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController {

    // MARK:- Variables
    private var photos: [Photo] = []
    
    // MARK:- IBOutlets
    @IBOutlet private weak var collectionView: UICollectionView!
    
    // MARK:- Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        getPhotos()
        navigationItem.addTitleView()
        // Do any additional setup after loading the view.
    }
    
    // MARK:- Private Methods
    private func getPhotos() {
        APICaller.getInstance().getPhotos(onSuccess: { photos in
            self.photos = photos?.gallery ?? []
            self.collectionView.reloadData()
        }, onError: {error in
            
        })
    }
}

extension PhotosViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: screenWidth/2 - 2, height: CGFloat(120))
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constant.CollectionViewCell.PhotosCollectionCell, for: indexPath) as! PhotosCollectionCell
        cell.photoImageView.downloadImageFrom(link: photos[indexPath.row].img, contentMode: .scaleToFill)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        collectionView.deselectItem(at: indexPath, animated: true)
        let imageString = photos[indexPath.row].img
        imageString.downloadImage(completion: { image in
            DispatchQueue.main.async {
                let newImageView = UIImageView(image: image)
                newImageView.frame = UIScreen.main.bounds
                newImageView.backgroundColor = .black
                newImageView.contentMode = .scaleAspectFit
                newImageView.isUserInteractionEnabled = true
                let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissFullscreenImage))
                newImageView.addGestureRecognizer(tap)
                self.view.addSubview(newImageView)
                self.navigationController?.isNavigationBarHidden = true
            }
        })
    }
    
    @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        sender.view?.removeFromSuperview()
    }
}

class PhotosCollectionCell: UICollectionViewCell {
    @IBOutlet internal weak var photoImageView: UIImageView!
}
