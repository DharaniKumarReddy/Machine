//
//  PDFViewController.swift
//  Franziskaner Munchen
//
//  Created by Dharani Reddy on 23/04/18.
//  Copyright © 2018 Integro Infotech. All rights reserved.
//

import UIKit
import WebKit

class PDFViewController: UIViewController, WKNavigationDelegate {

    // MARK:- Variables
    internal var pdf: String?
    private var webView: WKWebView!
    
    // MARK:- IBOutlets
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: view.frame, configuration: webConfiguration)
        webView.navigationDelegate = self
        view.addSubview(webView)
        navigationItem.addTitleView()
        activityIndicator.startAnimating()
        //webView.navigationDelegate = self
        let request = URLRequest(url: URL(string: pdf ?? "")!)
        webView.load(request)
        // Do any additional setup after loading the view.
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
    }
}
