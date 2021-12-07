//
//  DashboardReportViewController.swift
//  NewMleadsEnterprise
//
//  Created by Triforce New Mac on 16/08/19.
//  Copyright © 2019 com.Tri-Force.MLeadsEnterprise. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import WebKit

class DashboardReportViewController: UIViewController,UIWebViewDelegate,NVActivityIndicatorViewable,WebServiceDelegate,WKNavigationDelegate {
    
    
    @IBOutlet var webView: WKWebView!
    
    var Url = String()
    var webservice : WebService = WebService()
    var handleWebService : HandleWebService = HandleWebService()
    var appdelegate:AppDelegate = AppDelegate()
    var alertbtnColor = Utilities.alertButtonColor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "DashBoard Report"
        self.findHamburguerViewController()?.gestureEnabled  = false
        
        //Progress Bar Loding...
        let size = CGSize(width: 30, height: 30)
        startAnimating(size, message: "Loading...", type: NVActivityIndicatorType(rawValue: 29))
        
        let url = URL(string: MY_DASHBOARD_URL + objLoginUserDetail.createTimeStamp!)
        let request = URLRequest(url: url!)
        webView.allowsBackForwardNavigationGestures = true
        webView.load(request)
    }
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView

    }
    
    
    //WEBView Method Call Function...
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        stopAnimating()
    }
//    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool
//    {
//        startAnimating()
//        print("Start load...")
//        return true
//    }
//
//    func webViewDidFinishLoad(_ webView: UIWebView)
//    {
//        stopAnimating()
//    }
//
//    func webView(_ webView: UIWebView, didFailLoadWithError error: Error)
//    {
//        stopAnimating()
//    }
    
    //MARK: WEbservices Method Call
    func webServiceResponceSuccess(_ response: Data, apiKey: String) {
        stopAnimating()
    }
    
    
    func webServiceResponceFailure(_ errorMessage: String) {
        stopAnimating()
        
        let alert = UIAlertController(title: "", message: errorMessage,  preferredStyle: .alert)
        let attributedString = Utilities.alertAttribute(titleString: "")
        alert.setValue(attributedString, forKey: "attributedTitle")
        let OKAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        OKAction.setValue(alertbtnColor, forKey: "titleTextColor")
        
        alert.addAction(OKAction)
        present(alert,animated: true,completion: nil)
        
    }
    
}
