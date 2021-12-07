//
//  SystemsOptionReferralProgram.swift
//  NewMleadsEnterprise
//
//  Created by Akshansh Modi on 30/11/20.
//  Copyright © 2020 com.Tri-Force.MLeadsEnterprise. All rights reserved.
//

import UIKit
import WebKit

class SystemsOptionReferralProgram: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var AIView: UIActivityIndicatorView!
    @IBOutlet weak var WKWebView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        WKWebView.navigationDelegate = self
        self.AIView.startAnimating()
        let url = URL(string: "https://www.myleadssite.com/refereal_affialiate_programmer.php")
        let request = URLRequest(url: url!)
        WKWebView.load(request)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.AIView.stopAnimating()
    }

}
