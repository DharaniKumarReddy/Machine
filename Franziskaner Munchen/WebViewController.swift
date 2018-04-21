//
//  WebViewController.swift
//  Franziskaner Munchen
//
//  Created by Dharani Reddy on 14/04/18.
//  Copyright © 2018 Integro Infotech. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, UIWebViewDelegate {

    // MARK:- Variables
    internal var webUrl: String?
    
    // MARK:- IBOutlets
    @IBOutlet private weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadingIndicator.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        loadingIndicator.startAnimating()
        loadWebView()
    }
    
    private func loadWebView() {
        if let url = URL(string: webUrl ?? "http://franciscansmunich.com/") {
            let urlRequest = URLRequest(url: url)
            webView.loadRequest(urlRequest)
        }
    }

    func webViewDidFinishLoad(_ webView: UIWebView) {
        loadingIndicator.stopAnimating()
    }
}
