//
//  MoreInfoSendFeedback.swift
//  NewMleadsEnterprise
//
//  Created by Akshansh Modi on 29/11/20.
//  Copyright © 2020 com.Tri-Force.MLeadsEnterprise. All rights reserved.
//

import UIKit
import TextFieldEffects
import Alamofire
import NVActivityIndicatorView
import JSSAlertView

class MoreInfoSendFeedback: UIViewController, NVActivityIndicatorViewable, WebServiceDelegate {
    func webServiceResponceSuccess(_ response: Data, apiKey: String) {
        stopAnimating()
        let json = JSON(data: response)
        print(json)
        //self.navigationController?.popViewController(animated: true)
    }
    
    func webServiceResponceFailure(_ errorMessage: String) {
        stopAnimating()
    }
    

    @IBOutlet weak var lblSubject: HoshiTextField!
    @IBOutlet weak var txwMessage: UITextView!
    
    let webService : WebService = WebService()
    var handleWebService : HandleWebService = HandleWebService()
    var appdelegate = AppDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    @IBAction func Submit(_ sender: Any) {
        let valid = self.validation()
        if valid {
            let param:[String : AnyObject] = ["userId":objLoginUserDetail.userId! as AnyObject,
                                              "subject":lblSubject.text! as AnyObject,
                                              "message":txwMessage.text as AnyObject]
            
            //Progress Bar Loding...
            let size = CGSize(width: 30, height: 30)
            startAnimating(size, message: "Loading...", type: NVActivityIndicatorType(rawValue: 29))
            
            webService.doRequestPost("https://www.myleadssite.com/MLeads9.7.22/FeedbackEmailSent.php", params: param, key: "SendFeedback", delegate: self)
        }
    }
    
    func nsdataToJSON(data: NSData) -> AnyObject? {
        do {
            return try JSONSerialization.jsonObject(with: data as Data, options: .mutableContainers) as AnyObject
        } catch let myJSONError {
            print(myJSONError)
        }
        return nil
    }
    
    func validation() -> Bool {
        if self.lblSubject.text!.isEmpty{
            let alert = UIAlertController(title: "Alert", message: "Please enter subject", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        else if self.txwMessage.text!.isEmpty{
            let alert = UIAlertController(title: "Alert", message: "Please enter message", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        return true
    }
}

//extension MoreInfoSendFeedback {
//
//    func AlamofireForgotPassword(){
//
//        let url = "https://www.myleadssite.com/MLeads9.7.22/FeedbackEmailSent.php"
//        let param = ["email":"\(self.txtForgotPassword.text!)"]
//
//        Alamofire.request(url, method: .post, parameters: param as Parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
//            switch(response.result) {
//            case .success(_):
//                if response.result.value != nil{
//                    self.AIView.stopAnimating()
//                    let data = response.result.value as! [String : Any]
//                    print(data)
//                    let status = data["status"] as! Int
//                    let msg = data["message"] as? String ?? ""
//                    if status == 1
//                    {
//                        let DealsData = data["data"] as? [[String:Any]] ?? []
//                        let _ = Alert(title: "", msg: msg, vc: self)
//                    }
//                    else {
//
//                        let _ = Alert(title: "Alert", msg: msg, vc: self)
//                    }
//                }
//                break
//
//            case .failure(_):
//                self.AIView.stopAnimating()
//                //let _ = Alert(title: "Error", msg: "server or internet error", vc: self)
//                break
//            }
//        }
//    }
//}
