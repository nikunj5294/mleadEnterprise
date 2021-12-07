//
//  LinkedInViewController.swift
//  NewMleadsEnterprise
//
//  Created by Triforce New Mac on 12/12/19.
//  Copyright © 2019 com.Tri-Force.MLeadsEnterprise. All rights reserved.
//

import UIKit
import WebKit
import NVActivityIndicatorView

class LinkedInViewController: UIViewController,UIWebViewDelegate,NVActivityIndicatorViewable {

    @IBOutlet var webView: WKWebView!
     var UserData = NSMutableDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let linkedInKey = "817nv3y7fe0d6l"
        let responseType = "code"
        let authorizationEndPoint = "https://www.linkedin.com/uas/oauth2/authorization"
        let redirectURL = "https://www.myleadssite.com/"
        let state = "linkedin\(Int(NSDate().timeIntervalSince1970))"
        let scope = "r_emailaddress"

        // Create the authorization URL string.
        var authorizationURL = "\(authorizationEndPoint)?"
        authorizationURL += "response_type=\(responseType)&"
        authorizationURL += "client_id=\(linkedInKey)&"
        authorizationURL += "redirect_uri=\(redirectURL)&"
        authorizationURL += "state=\(state)&"
        authorizationURL += "scope=\(scope)"
//
        let WebUrl = authorizationURL.replacingOccurrences(of: " ", with: "%20", options: [], range: nil)
        //let WebUrl = URL("")
        let url = URL(string: WebUrl)
        let request = URLRequest(url: url!)
        webView.load(request)
        
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {
        self.startAnimating()
        
        let url = request.url
        print("urlhost\(url?.host)")
        print("url\(url)")
        print("urlabsoulte\(url?.absoluteString)")
        
        if url!.host == "https://www.myleadssite.com/"
        {
            if url!.absoluteString.contains("code")
            {
                let urlParts = url!.absoluteString.components(separatedBy: "?")
                let code = urlParts[1].components(separatedBy: "=")[1]
                
                requestForAccessToken(authorizationCode: code)
            }
        }
        return true
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView)
    {
        stopAnimating()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error)
    {
        stopAnimating()
        
    }
    
    func requestForAccessToken(authorizationCode: String) {
            let grantType = "authorization_code"
            let linkedInKey = "817nv3y7fe0d6l"
            let linkedInSecret = "WmRHkLQpBpjz0t7l"
            let redirectURL = "https://www.myleadssite.com/"
            let accessTokenEndPoint = "https://www.linkedin.com/uas/oauth2/accessToken"
            // Set the POST parameters.
            var postParams = "grant_type=\(grantType)&"
            postParams += "code=\(authorizationCode)&"
            postParams += "redirect_uri=\(redirectURL)&"
            postParams += "client_id=\(linkedInKey)&"
            postParams += "client_secret=\(linkedInSecret)"
            
            // Convert the POST parameters into a NSData object.
            let postData = postParams.data(using: String.Encoding.utf8)
            
            // Initialize a mutable URL request object using the access token endpoint URL string.
            let request = NSMutableURLRequest(url: URL(string: accessTokenEndPoint)!)
            // Indicate that we're about to make a POST request.
            request.httpMethod = "POST"
            
            // Set the HTTP body using the postData object created above.
            request.httpBody = postData
            
            // Add the required HTTP header field.
            request.addValue("application/x-www-form-urlencoded;", forHTTPHeaderField: "Content-Type")
            
            
            // Initialize a NSURLSession object.
            let session = URLSession(configuration: URLSessionConfiguration.default)
            
            // Make the request.
            let task: URLSessionDataTask = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
                // Get the HTTP status code of the request.
                let statusCode = (response as! HTTPURLResponse).statusCode
                print("response\(response)")
                
                if(error != nil)
                {
                    print("error\(error?.localizedDescription)")
                }
                
                if statusCode == 200 {
                    // Convert the received JSON data into a dictionary.
                    do {
                        let dataDictionary : [String : AnyObject] = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String : AnyObject]
                        
                        let accessToken = dataDictionary["access_token"] as! String
                        print("accessToken\(accessToken)")
                        
                        UserDefaults.standard.set(accessToken, forKey: "LIAccessToken")
                        UserDefaults.standard.synchronize()
                        
                        self.getLinkedInData(accesstoken: accessToken)
                    }
                    catch {
                        print("Could not convert JSON data into a dictionary.")
                    }
                }
            }
            
            task.resume()
        }
        
        func getLinkedInData(accesstoken: String)  {
            
            //let accesstoken = UserDefaults.value(forKey: "LIAccessToken")
            let url = "https://api.linkedin.com/v1/people/~:(id,first-name,last-name,email-address)?oauth2_access_token=\(accesstoken)&format=json"
            
            let request = NSMutableURLRequest(url: URL(string: url)!)
            request.httpMethod = "GET"
            
            let session = URLSession(configuration: URLSessionConfiguration.default)
            let task: URLSessionDataTask = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
                // Get the HTTP status code of the request.
                let statusCode = (response as! HTTPURLResponse).statusCode
                print("response\(String(describing: response))")
                
                if(error != nil)
                {
                    print("error\(error?.localizedDescription)")
                }
                
                if statusCode == 200 {
                    // Convert the received JSON data into a dictionary.
                    do {
                        let dataDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String: AnyObject]
                        
                        print(dataDictionary)
                        let firstName = dataDictionary["firstName"] as! String
                        let lastName = dataDictionary["lastName"] as! String
                        let email = dataDictionary["emailAddress"] as! String
                        
                        self.UserData = ["FirstName":firstName as AnyObject,
                                         "LastName":lastName as AnyObject,
                                         "Email":email as AnyObject]
                        
                        print("emailId\(email)")
                        print("firstName\(firstName)")
                        print("lastName\(lastName)")
                        
                        
                        self.stopAnimating()
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
                        vc.UserData = self.UserData
                        self.present(vc, animated: true, completion: nil)
                        self.webView.isHidden = true
    //                    DispatchQueue.main.async {
    //
    //                        self.navigationController?.popViewController(animated: true)
    //                        // self.dismiss(animated: true, completion: nil)
    //
    //                    }
                    }
                    catch {
                        print("Could not convert JSON data into a dictionary.")
                    }
                }
            }
            
            task.resume()
        }
    
    @IBAction func btnBackArrow(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
