//
//  WebService.swift
//  Edumere Seller
//
//  Created by MAC-1 on 30/09/19.
//  Copyright © 2019 MAC-1. All rights reserved.
//

import Foundation
import Alamofire
import SVProgressHUD

#if DEBUG
let Env = "d"
#else
let Env = "p"
#endif


class WebServiceCH {
    
    static let shared = WebServiceCH()
    var AuthorizationToken = ""
    
    var getHeaders : HTTPHeaders
    {
        debugPrint("getHeaders",AuthorizationToken)
        return ["Authorization":AuthorizationToken,"Accept":"application/json", "Env":Env]
    }
    
    func setAuthorizationToken(_ Token: String) {
        debugPrint("setAuthorizationToken",Token)
        AuthorizationToken = "Bearer " + Token
    }
    
    func removeAuthorizationToken(){
        AuthorizationToken = ""
    }
    
    func RequesURL(_ urlString : URLConvertible , Perameters : [String: Any]? = nil ,showProgress:Bool,completion: @escaping ((NSDictionary , Bool) -> Void), failure:@escaping ((Error) -> Void))
    {
        if showProgress{
            SVProgressHUD.show()
            SVProgressHUD.setDefaultAnimationType(.native)
            SVProgressHUD.setDefaultMaskType(.clear)
        }
        
        debugPrint("urlString",urlString)
        
        Alamofire.request(urlString,method: .post, parameters: Perameters, encoding: URLEncoding.httpBody, headers: getHeaders)
            .responseJSON { response in
                
                switch(response.result) {
                case .success(let Value):
                    if showProgress{
                        SVProgressHUD.dismiss()
                    }
                    if let json = JSON(Value).dictionaryObject as NSDictionary?
                    {
                        if self.LogoutForcefully(json) == false
                        {
                            completion(json , ConvertToBool(json["status"]))
                        }
                    } else {
                        failure(MYError.init(description: "Something went wrong", domain: ""))
                    }
                    
                case .failure(let encodingError):
                    if showProgress{
                        SVProgressHUD.dismiss()
                    }
                    print("Error:\(String(describing: response.result.error))")
                    failure(encodingError)
                }
        }
    }
    
    func RequesURLGet(_ urlString : URLConvertible , Perameters : [String: Any]? = nil ,showProgress:Bool,completion: @escaping ((NSDictionary , Bool) -> Void), failure:@escaping ((Error) -> Void))
    {
        if showProgress{
            SVProgressHUD.show()
            SVProgressHUD.setDefaultAnimationType(.native)
            SVProgressHUD.setDefaultMaskType(.clear)
        }
        
        debugPrint("urlString",urlString)
        debugPrint("Perameters",Perameters ?? "")
        Alamofire.request(urlString,method: .get, parameters: Perameters, encoding: URLEncoding.httpBody, headers: getHeaders)
            .responseJSON { response in
                
                switch(response.result) {
                case .success(let Value):
                    if showProgress{
                        SVProgressHUD.dismiss()
                    }
                    if let json = JSON(Value).dictionaryObject as NSDictionary?
                    {
                        if self.LogoutForcefully(json) == false
                        {
                            completion(json , ConvertToBool(json["status"]))
                        }
                    } else {
                        failure(MYError.init(description: "Something went wrong", domain: ""))
                    }
                    
                case .failure(let encodingError):
                    if showProgress{
                        SVProgressHUD.dismiss()
                    }
                    print("Error:\(String(describing: response.result.error))")
                    failure(encodingError)
                }
        }
    }
    
    func webRequestForSingleImages(DictionaryImages : NSDictionary? = nil, urlString : URLConvertible , Perameters : [String: Any] ,completion: @escaping ((NSDictionary , Bool) -> Void), failure:@escaping ((Error) -> Void))
    {
        Alamofire.upload(multipartFormData:{ multipartFormData in
            
            // POST PARAMETER
            for (key, value) in Perameters {
                print("parameter: \(key):\(value)")
                let par:String = value as! String
                multipartFormData.append(par.data(using: .utf8)!, withName: key)
            }
            
            // UPLOAD IMAGE
            if let imagedata = DictionaryImages
            {
                for (key,value) in imagedata
                {
                    print(key)
                    print(value)
                    
                    if(value is (UIImage)){
                            
                        if let imageData = (value as! UIImage).jpegData(compressionQuality: 0.75) {
                                let ImageName = "Image\(NSUUID().uuidString).png"
                                multipartFormData.append(imageData, withName: "\(key)", fileName: ImageName, mimeType: "image/*")
                            }
                    }
                }
            }
            
            
        },usingThreshold:UInt64.init(), to:urlString, method:.post, headers:getHeaders, encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                print("UP [ \(upload.uploadProgress.fractionCompleted)]")
                upload.responseJSON { response in
                    print("responseJSON:---\(response)")
                    
                    switch(response.result) {
                        
                    case .success(let Value):
                        if response.result.value != nil , let json = JSON(Value).dictionaryObject as NSDictionary?
                        {
                            print("===> \(urlString) \n ===>\(json)")
                            if self.LogoutForcefully(json) == false
                            {
                                completion(json , ConvertToBool(json["status"]))
                            }
                        }
                        
                        break
                        
                    case .failure(let encodingError):
                        print("Error:\(String(describing: response.result.error))")
                        failure(encodingError)
                        break
                    }
                    }
                    .responseString { (responseString) in
                        debugPrint("responseString Upload:\(responseString)")
                }
                
            case .failure(let encodingError):
                failure(encodingError)
            }
        })
    }
    
    func webRequestForMultipleImages(DictionaryImages : NSDictionary? = nil, urlString : URLConvertible , Perameters : [String: Any] ,completion: @escaping ((NSDictionary , Bool) -> Void), failure:@escaping ((Error) -> Void))
    {
        Alamofire.upload(multipartFormData:{ multipartFormData in
            
            // POST PARAMETER
            for (key, value) in Perameters {
                print("parameter: \(key):\(value)")
                if value is Array<String>
                {
                    for str in value as! [String] {
                        multipartFormData.append("\(str)".data(using: String.Encoding.utf8)!, withName: "\(key)[]")
                    }
                }
                else
                {
                    let par:String = value as! String
                    multipartFormData.append(par.data(using: .utf8)!, withName: key)
                }
            }
            
            // UPLOAD IMAGE
            if let imagedata = DictionaryImages
            {
                for (key,value) in imagedata
                {
                    print(key)
                    print(value)
                           
                    if(value is ([UIImage])){
                        for (image) in value as! [UIImage] {
                            
                            if let imageData = image.pngData() {
                                let ImageName = "Image\(NSUUID().uuidString).png"
                                multipartFormData.append(imageData, withName: "\(key)[]", fileName: ImageName, mimeType: "image/*")
                            }
                        }
                    }
                }
            }
            
            
        },usingThreshold:UInt64.init(), to:urlString, method:.post, headers:getHeaders, encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                print("UP [ \(upload.uploadProgress.fractionCompleted)]")
                upload.responseJSON { response in
                    print("responseJSON:---\(response)")
                    
                    switch(response.result) {
                        
                    case .success(let Value):
                        if response.result.value != nil , let json = JSON(Value).dictionaryObject as NSDictionary?
                        {
                            print("===> \(urlString) \n ===>\(json)")
                            if self.LogoutForcefully(json) == false
                            {
                                completion(json , ConvertToBool(json["status"]))
                            }
                        }
                        
                        break
                        
                    case .failure(let encodingError):
                        print("Error:\(String(describing: response.result.error))")
                        failure(encodingError)
                        break
                    }
                    }
                    .responseString { (responseString) in
                        debugPrint("responseString Upload:\(responseString)")
                }
                
            case .failure(let encodingError):
                failure(encodingError)
            }
        })
        
    }
    
    
    func uploadPDFFile(_ uploadDocsData : Data, fileName : String, urlString : URLConvertible , Perameters : [String: Any]? = nil ,completion: @escaping ((NSDictionary , Bool) -> Void), failure:@escaping ((Error) -> Void)) {
        Alamofire.upload(multipartFormData: { multipartFormData in
            
            multipartFormData.append(uploadDocsData, withName: "file", fileName: fileName, mimeType:"pdf")
            
            if let para = Perameters {
                for (key, value) in para {
                    multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                }
            }
        }, usingThreshold:UInt64.init(), to:urlString, method:.post, headers:getHeaders, encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    print("uploding: \(progress.fractionCompleted)")
                })
                    .responseJSON { response in
                        switch response.result {
                        case .success(let value):
                            if let json = JSON(value).dictionaryObject as NSDictionary?
                            {
                                if self.LogoutForcefully(json) == false
                                {
                                    completion(json , ConvertToBool(json["status"]))
                                }
                            } else {
                                failure(MYError.init(description: "Something went wrong", domain: ""))
                            }
                        case .failure(let responseError):
                            failure(responseError)
                        }
                }
            case .failure(let encodingError):
                failure(encodingError)
            }
        })
    }
    
    
    func uploadData(_ uploadDocs : [UploadImage]?, urlString : URLConvertible , Perameters : [String: Any]? = nil , progressCompletionBlock : ((Progress) -> Void)? = nil,completion: @escaping ((NSDictionary , Bool) -> Void), failure:@escaping ((Error) -> Void)) {
        Alamofire.upload(multipartFormData: { multipartFormData in

            if let arrUpload = uploadDocs {
                arrUpload.forEach({ (objUploadImage) in
                    if let uploadData = objUploadImage.imgData {
                        multipartFormData.append(uploadData, withName: objUploadImage.name, fileName: objUploadImage.fileName, mimeType: objUploadImage.mimeType)
                    }
                })
            }

            if let para = Perameters {
                for (key, value) in para {
                    multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                }
            }
        }, usingThreshold:UInt64.init(), to:urlString, method:.post, headers:getHeaders, encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):

                upload.uploadProgress(closure: { (progress) in
                    progressCompletionBlock?(progress)
                    print("uploding: \(progress.fractionCompleted)")
                })
                    .responseJSON { response in
                        switch response.result {
                        case .success(let value):
                            if let json = JSON(value).dictionaryObject as NSDictionary?
                            {
                                if self.LogoutForcefully(json) == false
                                {
                                    completion(json , ConvertToBool(json["status"]))
                                }
                            } else {
                                failure(MYError.init(description: "Something went wrong", domain: ""))
                            }
                        case .failure(let responseError):
                            failure(responseError)
                        }
                }
            case .failure(let encodingError):
                failure(encodingError)
            }
        })
    }
    
    // API
    
    func CancelAllRequests()
    {
        Alamofire.SessionManager.default.session.getAllTasks { (tasks) in
            tasks.forEach({$0.cancel()})
        }
    }
    
    func CancelRequestByPassingURL(_ strUrl : String)
    {
        Alamofire.SessionManager.default.session.getAllTasks { (tasks) in
            tasks.forEach({task in
                if task.currentRequest?.url?.absoluteString == strUrl
                {
                    task.cancel()
                }
            })
        }
    }
    
    func isServiceCalledInBackground(_ strUrl : String , Completion : ((Bool) -> ())?)
    {
        Alamofire.SessionManager.default.session.getAllTasks { (tasks) in
            tasks.forEach({task in
                Completion?(task.currentRequest?.url?.lastPathComponent == strUrl)
            })
        }
    }
    
    
    func LogoutForcefully(_ resDict : NSDictionary) -> Bool{
        
        if ToString(resDict["response_msg"]) == "Unauthenticated."
        {
             ShowAlert(title: "" , message: ToString(resDict["response_msg"]), buttonTitle: "Ok", handlerCB: {
                removeAllUserDefaults()
//                appdelegate.setLoginVC()
             })
            return true
        }
        return false
    }
    
}

class UploadImage {
    var imgData : Data?
    var name = ""
    var fileName = ""
    var mimeType = ""
    
    init(_ ImgData : Data? , Name : String , FileName : String , Mime : String = "image/*") {
        self.imgData = ImgData
        self.name = Name
        self.fileName = FileName
        self.mimeType = Mime
    }
    
    class var getFileName : String {
        let dateForm = DateFormatter()
        dateForm.dateStyle = .medium
        dateForm.timeStyle = .none
        dateForm.dateFormat = "yyyyMMdd_HHmmss"
        return "glbUserID" + "_" + dateForm.string(from: Date())
    }
}

struct MYError : Error {
    let description : String
    let domain : String
    
    var localizedDescription: String {
        return NSLocalizedString(description, comment: "")
    }
}


