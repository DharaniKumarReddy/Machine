//
//  YoutubePlayerViewController.swift
//  Franziskaner Munchen
//
//  Created by Dharani Reddy on 21/04/18.
//  Copyright © 2018 Integro Infotech. All rights reserved.
//

import UIKit
import YouTubePlayer

class YoutubePlayerViewController: UIViewController, YouTubePlayerDelegate {

    // MARK:- Variables
    internal var videoId: String?
    
    // MARK:- IBOutlets
    @IBOutlet private weak var videoPlayer: YouTubePlayerView!
    @IBOutlet private weak var indicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Load video from YouTube ID
        indicator.startAnimating()
        videoPlayer.loadVideoID(videoId ?? "")
        videoPlayer.delegate = self
        navigationItem.addTitleView()
    }
    
    func playerReady(_ videoPlayer: YouTubePlayerView) {
        videoPlayer.isHidden = false
        indicator.stopAnimating()
    }
}
