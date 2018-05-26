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
    
    // MARK:- IBOutlets
    @IBOutlet private weak var webview: WKWebView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.addTitleView()
        activityIndicator.startAnimating()
        webview.navigationDelegate = self
        let request = URLRequest(url: URL(string: pdf ?? "")!)
        webview.load(request)
        // Do any additional setup after loading the view.
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
    }
}
