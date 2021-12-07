//
//  SignUpViewController.swift
//  NewMleadsEnterprise
//
//  Created by PRIYANK on 09/04/19.
//  Copyright © 2019 com.Tri-Force.MLeadsEnterprise. All rights reserved.
//

import UIKit
import TextFieldEffects
import MaterialComponents
import NVActivityIndicatorView
import Alamofire
import JSSAlertView

@objc protocol SignUpViewControllerDelegate {
    @objc optional func txtEmailPassField(Email:String,PassWord:String)
}

class SignUpViewController: UIViewController,UITextFieldDelegate,NVActivityIndicatorViewable,UIScrollViewDelegate,WebServiceDelegate {
    var delegate:SignUpViewControllerDelegate? = nil
    
    @IBOutlet var txtFirstNameTextField: HoshiTextField!
    @IBOutlet var txtLastNameTextField: HoshiTextField!
    @IBOutlet var txtEmailTextField: HoshiTextField!
    @IBOutlet var txtPasswordTextField: HoshiTextField!
    @IBOutlet var txtConfirmPassTextFiels: HoshiTextField!
    @IBOutlet var txtPhoneNoTextField: HoshiTextField!
    
    

    var UserData = NSMutableDictionary()
    
    let webService : WebService = WebService()
    var handleWebService : HandleWebService = HandleWebService()
    
    var appdelegate = AppDelegate()
    
//    var txtFirstNameViewController = MDCTextInputControllerOutlined()
//    var txtLastNameViewcontroller = MDCTextInputControllerOutlined()
//    var txtEmailViewcontroller = MDCTextInputControllerOutlined()
//    var txtPasswordViewcontroller = MDCTextInputControllerOutlined()
//    var txtConfirmPassViewcontroller = MDCTextInputControllerOutlined()
//    var txtPhoneNoViewcontroller = MDCTextInputControllerOutlined()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        txtEmailTextField.delegate = self
        txtPasswordTextField.delegate = self
        txtConfirmPassTextFiels.delegate = self
        txtFirstNameTextField.delegate = self
        txtLastNameTextField.delegate = self
        txtPhoneNoTextField.delegate = self
        // Do any additional setup after loading the view.
        
        txtFirstNameTextField.text = UserData["FirstName"] as? String
        txtLastNameTextField.text = UserData["LastName"] as? String
        txtEmailTextField.text = UserData["Email"] as? String
    }
    //MARK: BUTTON SIGNUP
    @IBAction func btnSignUpClick(_ sender: Any) {
        txtConfirmPassTextFiels.resignFirstResponder()
        
        if  (txtFirstNameTextField.text?.isBlank)!
        {
            print("Please Enter First Name")
            
            let alert = UIAlertController(title: "", message: "Please Enter First Name",  preferredStyle: .alert)
            let attributedString = Utilities.alertAttribute(titleString: "SignUp Failed")
            alert.setValue(attributedString, forKey: "attributedTitle")
            let okAct = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            okAct.setValue(alertbtnColor, forKey: "titleTextColor")
            
            alert.addAction(okAct)
            present(alert,animated: true,completion: nil)
            
            //            let alert = UIAlertView(title: "SignUp Failed", message: "Please Enter First Name" , delegate: self, cancelButtonTitle: "OK")
            //            alert.show()
        }
        else if (txtLastNameTextField.text?.isBlank)!{
            // Please enter last name
            
            print("Please enter last name")
            
            let alert = UIAlertController(title: "", message: "Please Enter Last Name",  preferredStyle: .alert)
            let attributedString = Utilities.alertAttribute(titleString: "SignUp Failed")
            alert.setValue(attributedString, forKey: "attributedTitle")
            let okAct = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            okAct.setValue(alertbtnColor, forKey: "titleTextColor")
            
            alert.addAction(okAct)
            present(alert,animated: true,completion: nil)
        }
        else if !self.isValidEmail(self.txtEmailTextField.text!)
        {
            print("Please enter valid email id")
            
            let alert = UIAlertController(title: "", message: "Please enter valid email id",  preferredStyle: .alert)
            let attributedString = Utilities.alertAttribute(titleString: "SignUp Failed")
            alert.setValue(attributedString, forKey: "attributedTitle")
            let okAct = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            okAct.setValue(alertbtnColor, forKey: "titleTextColor")
            
            alert.addAction(okAct)
            present(alert,animated: true,completion: nil)
            
            //            let alert = UIAlertView(title: "SignUp Failed", message: "Please Enter Valid Email" , delegate: self, cancelButtonTitle: "OK")
            //            alert.show()
        }
        /*else if ((txtCnfrmEmail.text?.isBlank)! || (txtEmail.text != txtCnfrmEmail.text))
        {
            print("Email Does Not Match")

            let alert = UIAlertController(title: "", message: "Email Does Not Match",  preferredStyle: .alert)
            let attributedString = Utilities.alertAttribute(titleString: "SignUp Failed")
            alert.setValue(attributedString, forKey: "attributedTitle")
            let okAct = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            okAct.setValue(alertbtnColor, forKey: "titleTextColor")

            alert.addAction(okAct)
            present(alert,animated: true,completion: nil)
            //            let alert = UIAlertView(title: "SignUp Failed", message: "Email Does Not Match" , delegate: self, cancelButtonTitle: "OK")
            //            alert.show()
        }*/
        else if (txtPasswordTextField.text?.isBlank)!
        {
            print("Please Enter Password")
            
            let alert = UIAlertController(title: "", message: "Please Enter Password",  preferredStyle: .alert)
            let attributedString = Utilities.alertAttribute(titleString: "SignUp Failed")
            alert.setValue(attributedString, forKey: "attributedTitle")
            let okAct = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            okAct.setValue(alertbtnColor, forKey: "titleTextColor")
            
            alert.addAction(okAct)
            present(alert,animated: true,completion: nil)
            
            //            let alert = UIAlertView(title: "SignUp Failed", message: "Please Enter Password" , delegate: self, cancelButtonTitle: "OK")
            //            alert.show()
        }
        else if ((txtConfirmPassTextFiels.text?.isBlank)! || (txtPasswordTextField.text != txtConfirmPassTextFiels.text))
        {
            print("Password Does Not Match")
            
            let alert = UIAlertController(title: "", message: "Password Does Not Match",  preferredStyle: .alert)
            let attributedString = Utilities.alertAttribute(titleString: "SignUp Failed")
            alert.setValue(attributedString, forKey: "attributedTitle")
            let okAct = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            okAct.setValue(alertbtnColor, forKey: "titleTextColor")
            
            alert.addAction(okAct)
            present(alert,animated: true,completion: nil)
            
            //            let alert = UIAlertView(title: "SignUp Failed", message: "Password Does Not Match" , delegate: self, cancelButtonTitle: "OK")
            //            alert.show()
        }
        else if ((txtPhoneNoTextField.text?.isBlank)! || !(txtPhoneNoTextField.text?.isValidPhoneNo())!)
        {
            print("Please Enter Valid Phone number")
            
            let alert = UIAlertController(title: "", message: "Please Enter Valid Phone number",  preferredStyle: .alert)
            let attributedString = Utilities.alertAttribute(titleString: "SignUp Failed")
            alert.setValue(attributedString, forKey: "attributedTitle")
            let okAct = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            okAct.setValue(alertbtnColor, forKey: "titleTextColor")
            
            alert.addAction(okAct)
            present(alert,animated: true,completion: nil)
            //            let alert = UIAlertView(title: "SignUp Failed", message: "Please Enter Valid Phone number" , delegate: self, cancelButtonTitle: "OK")
            //            alert.show()
        }
            
        else
        {
            let userName = txtEmailTextField.text
            let encryPass = txtPasswordTextField.text?.sha512()
            
            let param:[String : String] = ["firstName":txtFirstNameTextField.text! ,
                                           "lastName":txtLastNameTextField.text! ,
                                           "email":userName!,
                                           "password":encryPass!,
                                           "phone":txtPhoneNoTextField.text!,
                                           "registerType": USER_TYPE_FOR_APP,
                                           "mobilePlatform":DEVICE_TYPE,//(DEVICE_ID as AnyObject) as! String,
                                            "event_organizer_type":"",
                                            "ip":"",
                                            "zipCode":"",
                                            "country":"",
                                            "securityQuesId":"",
                                            "currency_id":"",
                                            "city":"",
                                            "optIn":"",
                                            "jobtitle":"",
                                            "state":"",
                                            "subscriptionType":"Free Trial",
                                            "hearFrom":"",
                                            "termsCondition":"",
                                            "securityAnswer":"",
                                            "userName":"",
                                            "industryId":"30"]
            
            print("Parameter = \(param)")
            //Progress Bar Loding...
            let size = CGSize(width: 30, height: 30)
            startAnimating(size, message: "Loading...", type: NVActivityIndicatorType(rawValue: 29))
            
            webService.doRequestPost(REGISTRATION_API_URL, params: param as [String : AnyObject], key: "registerFreeEnterpriserUser", delegate: self)
        }
        
        
    }
    
    
    @IBAction func btnBackClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: TextFields Return Keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func webServiceResponceSuccess(_ response: Data, apiKey: String) {
       stopAnimating()
        let json = JSON(data: response)
        //        let userSignUp = json["userSignUp"]
       print(json)
        if apiKey == REGISTRATION_API_URL
        {
            let result = handleWebService.handleSignUp(response)
            print(result)
            if result.Status
            {
                //USERDEFAULTS.set(true, forKey: IS_ALREADY_LOGIN)
                
                let param:[String : AnyObject] = ["userId":result.UserId as AnyObject]
                
                ShowAlert(title: "Success", message: "Registration successfully.", buttonTitle: "Ok") {
                    //Get User Detail
                    let size = CGSize(width: 30, height: 30)
                    self.startAnimating(size, message: "Loading...", type: NVActivityIndicatorType(rawValue: 29))
                    
                    self.webService.doRequestPost(GET_USER_DETAIL, params: param, key: "userDetail", delegate: self)
                }
                
            }
            else
            {
                //print("No.")
                let alert = UIAlertController(title: "", message: json["error"].string,  preferredStyle: .alert)
                let attributedString = Utilities.alertAttribute(titleString: "SignUp Failed")
                alert.setValue(attributedString, forKey: "attributedTitle")
                let okAct = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                
                okAct.setValue(alertbtnColor, forKey: "titleTextColor")
                
                alert.addAction(okAct)
                present(alert,animated: true,completion: nil)
                
                //                let alert = UIAlertView(title: "SignUp Failed", message: json["error"].string , delegate: self, cancelButtonTitle: "OK")
                //                alert.show()
            }
        }
            
        else if apiKey == GET_USER_DETAIL
        {
            let result = handleWebService.handleUserDetails(response)
            
            if result.Status
            {
                let encodedData = NSKeyedArchiver.archivedData(withRootObject: result.UserDetail)
                USERDEFAULTS.set(encodedData, forKey: LOGIN_USER_Detail)
                USERDEFAULTS.synchronize()
                                                                                            //RootViewController
                let viewController = mainStoryboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                app.keyWindow?.rootViewController = viewController
            }
        }
    }
    
    func webServiceResponceFailure(_ errorMessage: String) {
        stopAnimating()
        let alert = UIAlertController(title: "", message: errorMessage,  preferredStyle: .alert)
        let attributedString = Utilities.alertAttribute(titleString: "SignUp Failed")
        alert.setValue(attributedString, forKey: "attributedTitle")
        let okAct = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        okAct.setValue(alertbtnColor, forKey: "titleTextColor")
        
        alert.addAction(okAct)
        present(alert,animated: true,completion: nil)
    }
    

    @IBAction func btnCheckedClick(_ sender: Any) {
        
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
}


