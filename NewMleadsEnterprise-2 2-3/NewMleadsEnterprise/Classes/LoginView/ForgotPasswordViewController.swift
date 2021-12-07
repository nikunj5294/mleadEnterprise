//
//  ForgotPasswordViewController.swift
//  NewMleadsEnterprise
//
//  Created by Triforce New Mac on 13/06/19.
//  Copyright © 2019 com.Tri-Force.MLeadsEnterprise. All rights reserved.
//

import UIKit
import TextFieldEffects
import NVActivityIndicatorView

class ForgotPasswordViewController: UIViewController,UITextFieldDelegate,WebServiceDelegate, NVActivityIndicatorViewable{
    
    @IBOutlet var txtForgotEmailid: HoshiTextField!
    
    let webService : WebService = WebService()
    var handleWebService : HandleWebService = HandleWebService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.txtForgotEmailid.placeholder = "Enter a Email ID"
        self.hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
    }
    
    //MARK: Back Button Click....
    @IBAction func btnBackClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: Submit BUtton Click..
    @IBAction func btnSubmitClick(_ sender: AnyObject) {
        
        if (txtForgotEmailid.text!.isEmpty){
            let alert = UIAlertController(title: "", message: "Please Enter Registered Email",  preferredStyle: .alert)
            let attributedString = Utilities.alertAttribute(titleString: "Alert")
            alert.setValue(attributedString, forKey: "attributedTitle")
            
            let OKAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            OKAction.setValue(alertbtnColor, forKey: "titleTextColor")
            
            alert.addAction(OKAction)
            present(alert,animated: true,completion: nil)
        }
        else if !(txtForgotEmailid.text!.isEmail){
            
            let alert = UIAlertController(title: "", message: "Please Enter Valid Email",  preferredStyle: .alert)
            let attributedString = Utilities.alertAttribute(titleString: "Alert")
            alert.setValue(attributedString, forKey: "attributedTitle")
            
            let OKAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            OKAction.setValue(alertbtnColor, forKey: "titleTextColor")
            
            alert.addAction(OKAction)
            present(alert,animated: true,completion: nil)
        }
//        }else if((txtForgotEmailid.text?.isValidEmail())!){
//
//            let alert = UIAlertController(title: "", message: "Please Enter valid Email",  preferredStyle: .alert)
//            let attributedString = Utilities.alertAttribute(titleString: "Alert")
//            alert.setValue(attributedString, forKey: "attributedTitle")
//
//            let OKAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
//            OKAction.setValue(alertbtnColor, forKey: "titleTextColor")
//
//            alert.addAction(OKAction)
//            present(alert,animated: true,completion: nil)
//
//        }
        else{
            let param:[String : AnyObject] = ["email":txtForgotEmailid.text! as AnyObject]
            
            webService.doRequestPost(FORGOT_PASSWORD_API_URL, params: param, key: "userForgotPassword", delegate: self)
        }
    }
    
    //MARK:- WebService Response
    func webServiceResponceSuccess(_ response:Data,apiKey:String){
        stopAnimating()
        if apiKey == FORGOT_PASSWORD_API_URL
        {
            let result = handleWebService.handleForgotPassword(response)
            if result
            {
                let param:[String : AnyObject] = ["email":txtForgotEmailid.text! as AnyObject]
                                                  //"securityAnswer":"" as AnyObject]
                
                //Progress Bar Loding...
                let size = CGSize(width: 30, height: 30)
                self.startAnimating(size, message: "Loading...", type: NVActivityIndicatorType(rawValue: 29))
                
                webService.doRequestPost(GET_FORGOT_PASSWORD_EMAIL, params: param, key: "getForgotPasswordEmail", delegate: self)
            
            }else{
                
                print("forgetpass unsuccess")
                
                let alert = UIAlertController(title: "", message: "Email is not Registered.",  preferredStyle: .alert)
                let attributedString = Utilities.alertAttribute(titleString: "Failed")
                alert.setValue(attributedString, forKey: "attributedTitle")
                
                let OKAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                OKAction.setValue(alertbtnColor, forKey: "titleTextColor")
                
                alert.addAction(OKAction)
                present(alert,animated: true,completion: nil)
            }
            
        }else if apiKey == GET_FORGOT_PASSWORD_EMAIL{
            
            let result = handleWebService.handleForgotPasswordEmail(response)
            if result
            {
                let alert = UIAlertController(title: "", message: "Your password information has been sent to your email address",  preferredStyle: .alert)
                let attributedString = Utilities.alertAttribute(titleString: "Success")
                alert.setValue(attributedString, forKey: "attributedTitle")
                
                let OKAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                OKAction.setValue(alertbtnColor, forKey: "titleTextColor")
                
                alert.addAction(OKAction)
                present(alert,animated: true,completion: nil)
                
                txtForgotEmailid.text = ""
                dismissKeyboard()
                print("success")
                
            }else{
                
                let alert = UIAlertController(title: "", message: "Email Not Send",  preferredStyle: .alert)
                let attributedString = Utilities.alertAttribute(titleString: "Failed")
                alert.setValue(attributedString, forKey: "attributedTitle")
                
                let OKAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                OKAction.setValue(alertbtnColor, forKey: "titleTextColor")
                
                alert.addAction(OKAction)
                present(alert,animated: true,completion: nil)
                
            }
        }
    }
    
    func webServiceResponceFailure(_ errorMessage:String)
    {
        stopAnimating()
    }
}
extension String {
    func isValidEmail() -> Bool {
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: characters.count)) != nil
    }
}
