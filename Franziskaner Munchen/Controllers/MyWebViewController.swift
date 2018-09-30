//
//  WebViewController.swift
//  Franziskaner Munchen
//
//  Created by Dharani Reddy on 14/04/18.
//  Copyright © 2018 Integro Infotech. All rights reserved.
//

import UIKit
import WebKit

class MyWebViewController: UIViewController, WKNavigationDelegate {

    // MARK:- Variables
    internal var webUrl: String?
    
    // MARK:- IBOutlets
    @IBOutlet private weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var myWebView: UIWebView!
   // @IBOutlet private weak var loadingView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.addTitleView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadWebView()
    }
    
    private func loadWebView() {
        let urlRequest = NSURLRequest(url: NSURL(string: webUrl ?? "http://franziskaner-missionsverein.de/index.html")! as URL)
        myWebView.loadRequest(urlRequest as URLRequest)
    }
}

extension MyWebViewController: UIWebViewDelegate {
    func webViewDidFinishLoad(_ webView: UIWebView) {
        webView.isHidden = false
        loadingIndicator.stopAnimating()
    }
}
