//
//  MoreInfoTermsOfUse.swift
//  NewMleadsEnterprise
//
//  Created by Akshansh Modi on 29/11/20.
//  Copyright © 2020 com.Tri-Force.MLeadsEnterprise. All rights reserved.
//

import UIKit
import WebKit

class MoreInfoTermsOfUse: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var WKWebview: WKWebView!
    @IBOutlet weak var AIView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        WKWebview.navigationDelegate = self
        self.AIView.startAnimating()
        let url = URL(string: "https://www.myleadssite.com/terms.php")
        let request = URLRequest(url: url!)
        WKWebview.load(request)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.AIView.stopAnimating()
    }

}
