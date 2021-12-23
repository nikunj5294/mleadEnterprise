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
    func doRequestPostInFormData(_ url:String,params:[String:String],delegate:WebServiceDelegate){
        self.delegate = delegate;
        let urlPath = URL(string: WEBSERVICE_URL+url)
        
        guard urlPath != nil else { return }
            let boundary = generateBoundary()
        var request = URLRequest(url: urlPath!)

            let parameters = params

//            guard let mediaImage = Media(withImage: image, forKey: "file") else { return }

            request.httpMethod = "POST"

            request.allHTTPHeaderFields = [
                        "X-User-Agent": "ios",
                        "Accept-Language": "en",
                        "Accept": "application/json",
                        "Content-Type": "multipart/form-data; boundary=\(boundary)"                    ]

            let dataBody = createDataBody(withParameters: parameters, media: nil, boundary: boundary)
            request.httpBody = dataBody

            let session = URLSession.shared
            session.dataTask(with: request) {data, response, error in
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
        }.resume()

  }
    
    func generateBoundary() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }

    func createDataBody(withParameters params: [String: String]?, media: [Media]?, boundary: String) -> Data {

        let lineBreak = "\r\n"
        var body = Data()

        if let parameters = params {
            for (key, value) in parameters {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
                body.append("\(value + lineBreak)")
            }
        }

        if let media = media {
            for photo in media {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(photo.key)\"; filename=\"\(photo.fileName)\"\(lineBreak)")
                body.append("Content-Type: \(photo.mimeType + lineBreak + lineBreak)")
                body.append(photo.data)
                body.append(lineBreak)
            }
        }

        body.append("--\(boundary)--\(lineBreak)")

        return body
    }


    
}
extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}


struct Media {
    let key: String
    let fileName: String
    let data: Data
    let mimeType: String

    init?(withImage image: UIImage, forKey key: String) {
        self.key = key
        self.mimeType = "image/jpg"
        self.fileName = "\(arc4random()).jpeg"

        guard let data = image.jpegData(compressionQuality: 0.5) else { return nil }
        self.data = data
    }
}
