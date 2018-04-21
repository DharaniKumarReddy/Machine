//
//  VideosViewController.swift
//  Franziskaner Munchen
//
//  Created by Dharani Reddy on 20/04/18.
//  Copyright © 2018 Integro Infotech. All rights reserved.
//

import UIKit
import YouTubePlayer

class VideosViewController: UIViewController {

    // MARK:- Variables
    private var videos: [Video] = []
    
    // MARK:- IBOutlets
    @IBOutlet private weak var collectionView: UICollectionView!
    
    // MARK:- Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        getVideos()
        navigationItem.addTitleView()
        // Do any additional setup after loading the view.
    }
    
    private func getVideos() {
        APICaller.getInstance().getVideos(onSuccess: { videos in
            self.videos = videos?.video ?? []
            self.collectionView.reloadData()
        }, onError: { error in
            
        })
    }
}

extension VideosViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: screenWidth/2 - 2, height: CGFloat(130))
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constant.CollectionViewCell.VideosCollectionCell, for: indexPath) as! VideosCollectionCell
        cell.loadData(video: videos[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let youtubePlayer = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: Constant.ViewControllerWithIdentifier.YoutubePlayerViewController) as! YoutubePlayerViewController
        youtubePlayer.videoId = videos[indexPath.row].vId
        navigationController?.pushViewController(youtubePlayer, animated: true)
    }
}

class VideosCollectionCell: PhotosCollectionCell {
    @IBOutlet private weak var videoTitleLabel: UILabel!
    @IBOutlet private weak var overlayView: UIView!
    
    fileprivate func loadData(video: Video) {
        videoTitleLabel.text = video.vTitle
        photoImageView.downloadImageFrom(link: "https://img.youtube.com/vi/\(video.vId)/hqdefault.jpg", contentMode: .scaleToFill)
        self.layoutIfNeeded()
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        if let _ = overlayView {
            overlayView.layer.sublayers?.forEach({ $0.removeFromSuperlayer() })
            let topColor = UIColor.clear
            let bottomColor = UIColor.blue.withAlphaComponent(0.75)
            overlayView.layer.addSublayer(CAGradientLayer.applyOverLay(bounds: overlayView.bounds, startColor: topColor, endColor: bottomColor, startPoint: CGPoint.zero, endPoint: CGPoint(x: 0, y: 1)))
        }
    }
}
