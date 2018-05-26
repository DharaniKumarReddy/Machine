//
//  WebViewController.swift
//  Franziskaner Munchen
//
//  Created by Dharani Reddy on 14/04/18.
//  Copyright © 2018 Integro Infotech. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {

    // MARK:- Variables
    internal var webUrl: String?
    
    // MARK:- IBOutlets
    @IBOutlet private weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadingIndicator.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        loadingIndicator.startAnimating()
        webView.navigationDelegate = self
        loadWebView()
        navigationItem.addTitleView()
    }
    
    private func loadWebView() {
        if let url = URL(string: webUrl ?? "http://franziskaner-missionsverein.de/index.html") {
            let urlRequest = URLRequest(url: url)
            webView.load(urlRequest) //loadRequest(urlRequest)
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loadingIndicator.stopAnimating()
    }
}
