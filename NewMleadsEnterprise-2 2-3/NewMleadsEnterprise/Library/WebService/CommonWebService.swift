//
//  WebService.swift
//  Secure Evite
//
//  Created by System Administrator on 9/1/16.
//  Copyright © 2016 Tri-Force Consulting Services. All rights reserved.
//

import Foundation

public protocol WebServiceDelegate : class{
    
    func webServiceResponceSuccess(_ response:Data,apiKey:String);
    func webServiceResponceFailure(_ errorMessage:String);
    
}
open class WebService : NSObject,NSURLConnectionDataDelegate,NSURLConnectionDelegate {
    
    weak var delegate:WebServiceDelegate?=nil;
    
    open func  doRequestPost (_ url:String,params:[String:AnyObject],key:String,delegate:WebServiceDelegate){
        
        self.delegate = delegate;
        
        let theJSONData = try? JSONSerialization.data(
            withJSONObject: params ,
            options: JSONSerialization.WritingOptions(rawValue: 0))
        let jsonString = NSString(data: theJSONData!,
                                  encoding: String.Encoding.ascii.rawValue)
        
        let jsonWithKeyString = NSString(format: "%@=%@",key,jsonString!)
        
        
        print("URL:\(WEBSERVICE_URL+url)")
        print("Request string : \(jsonWithKeyString)")
        
        let configuration = URLSessionConfiguration.default
        
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
        
        let urlPath = URL(string: WEBSERVICE_URL+url)
        var request = URLRequest(url: urlPath!) 
        request.timeoutInterval = 60
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
//        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        let postLength = NSString(format:"%lu", jsonWithKeyString.length) as String
        request.setValue(postLength, forHTTPHeaderField:"Content-Length")
       
//        if let imageData =
//         request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonWithKeyString.data(using: String.Encoding.utf8.rawValue)

            let dataTask = session.dataTask(with: request) {data, response, error in
                if((error) != nil) {
                print(error!.localizedDescription)
                if self.delegate != nil {
                    self.delegate?.webServiceResponceFailure(error!.localizedDescription)
                }
            }else {
//                _ = NSString(data: data!, encoding:String.Encoding.utf8.rawValue)
//                let _: NSError?
                
                let URL:String = ((response?.url)?.lastPathComponent)!
                let json = JSON(data: data!)
                print("Response string:\(json)")
                if self.delegate != nil {
                  self.delegate?.webServiceResponceSuccess(data!,apiKey:URL)
                }
            }
        }
        dataTask.resume()
        
    }
   
}
