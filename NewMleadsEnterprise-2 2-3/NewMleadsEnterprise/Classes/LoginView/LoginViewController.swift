//
//  LoginViewController.swift
//  NewMleadsEnterprise
//
//  Created by Ashish Salet on 05/04/19.
//  Copyright © 2019 com.Tri-Force.MLeadsEnterprise. All rights reserved.
//

import UIKit
import TextFieldEffects
import MaterialComponents
import NVActivityIndicatorView
import Alamofire
import JSSAlertView
import SSKeychain
import FacebookCore
import FacebookLogin
import FBSDKLoginKit
import GoogleSignIn
import AuthenticationServices

import LinkedinSwift


class LoginViewController: UIViewController,UITextFieldDelegate,NVActivityIndicatorViewable,SignUpViewControllerDelegate,UIAlertViewDelegate,GIDSignInDelegate,GIDSignInUIDelegate{
    
    var userType = String()
    var userId = String()
    
    var strEmailID = String()
    var strPassword = String()
    
    @IBOutlet var emailTextField: HoshiTextField!
    @IBOutlet var passwordTextField: HoshiTextField!
    
    @IBOutlet weak var imgSelectedDontshowAgain: UIImageView!
    
    
    
    var alertbtnColor = Utilities.alertButtonColor()
    let webService : WebService = WebService()
    var handleWebService : HandleWebService = HandleWebService()
    
    var appdelegate = AppDelegate()
    var UserData = NSMutableDictionary()
    
    var txtEmailController = MDCTextInputControllerOutlined()
    var txtpasswordController = MDCTextInputControllerOutlined()
    var parameterForUserDetails = [String:Any]()
    var strUserID = ""
    
    @IBOutlet weak var viewSubscribeDialog: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        self.emailTextField.placeholder = "Enter a Email ID"
        self.passwordTextField.placeholder = "Enter a Password"
       
        //USERDEFAULTS.set(true, forKey: isAppLaunchedFirstTime)//Launch image shown or not
        
        //MARK: Image on TextFields....
//        let userTextFieldImage = UIImage(named: "textFieldMail")
//        addLeftImageTextField(txtField: emailTextField, andImage: userTextFieldImage!)
//
//        let passwordTextFieldImage = UIImage(named: "textFieldpassword")
//        addLeftImageTextField(txtField: passwordTextField, andImage: passwordTextFieldImage!)
        
        let username = UserDefaults.standard.object(forKey: "username")
        let password = UserDefaults.standard.object(forKey: "password")
        
        if (username != nil){
            self.emailTextField.text = username as? String
        }
        
        if(password != nil){
            self.passwordTextField.text = password as? String
        }
        
//        let userDef = UserDefaults.standard
//        if (userDef.value(forKey: "EmailID") as? String != nil)
//        {
//            strEmailID = userDef.value(forKey: "EmailID") as! String
//            strPassword = userDef.value(forKey: "PASSWORD") as! String
//            if (strEmailID != "")
//            {
//                emailTextField.text = strEmailID
//                passwordTextField.text = strPassword
//            }
//        }
//        emailTextField.backgroundColor = .white
//        emailTextField.font = UIFont.MyFont.textFont
//        //txtEmailController = MDCTextInputControllerOutlined(textInput: emailTextField)
//        emailTextField.delegate = self
//        txtEmailController.placeholderText = "EmailID."
//        txtEmailController.floatingPlaceholderActiveColor = UIColor.MyTheme.skyBlue
//        txtEmailController.activeColor = UIColor.MyTheme.skyBlue
////
//        passwordTextField.backgroundColor = .white
//        passwordTextField.font = UIFont.MyFont.textFont
//        //txtpasswordController = MDCTextInputControllerOutlined(textInput: passwordTextField)
//        passwordTextField.delegate = self
//         txtpasswordController.placeholderText = "Password"
//         txtpasswordController.floatingPlaceholderActiveColor = UIColor.MyTheme.skyBlue
//         txtpasswordController.activeColor = UIColor.MyTheme.skyBlue
    }
    
    //MARK:FaceBook Login Action...
    
    
//    @IBAction func signinWithFacebookClicked(_ sender: UIButton) {
//        view.endEditing(true)
//        let loginManager = LoginManager()
//        loginManager.logOut()
//
//        loginManager.logIn(permissions: [.email,.publicProfile,.userBirthday], viewController: self) { (loginResult) in
//
//            switch loginResult {
//
//            case .failed(let error):
//                print("error :- ",error.localizedDescription)
//            case .cancelled:
//                print("User cancelled facebook login.")
//            case .success:
//                print(loginResult)
//                print(AccessToken.current!)
//
//                self.getUserrInfo(completion: { (reqConnection,userInfo, error) in
//
//                    if error != nil {
//                        print("Error while getting Facebook info",error?.localizedDescription ?? "")
//                    }
//                    else {
//
//                        self.IDToken = AccessToken.current?.tokenString ?? ""
//
//                        let dictData = userInfo! as! [String : Any]
//                        let email = dictData["email"] as? String
//                        if email == nil {
//                            self.HideHUD()
//                            self.ShowAlertVC(title: UserData.applicationName ?? "", subTitle: AlertMessages.emailIsNotAssociated)
//                            return
//                        }
//                        self.domainName = (email ?? "").components(separatedBy: "@").last ?? ""
//                        UserDefaults.standard.set(dictData, forKey: UserDefaultStrings.UserInfo)
//                        self.fbGoogleToAPIProcess(dict: dictData, IDType: "facebook")
//                    }
//                })
//            }
//        }
//    }
    
    /************Apple Sign In Setup************/
    
//    func setupAppleSignIn() {
//
//    let btnAuthorization = ASAuthorizationAppleIDButton(authorizationButtonType: .signIn, authorizationButtonStyle: .white)
//        btnAuthorization.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width-(37*2), height: viewAppleSignIn.frame.size.height)
//        btnAuthorization.addTarget(self, action: #selector(actionHandleAppleSignin), for: .touchUpInside)
//        viewAppleSignIn.addSubview(btnAuthorization)
//    }
    
    @IBAction func btnAppleSignInClicked(_ sender: Any) {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    
    @IBAction func btnFacebookAction(_ sender: Any) {
        print("FaceBook Button Click...")
        let loginManager = LoginManager()
        loginManager.logOut()
        
        loginManager.logIn(permissions: [.email,.publicProfile,.userBirthday], viewController: self) { (loginResult) in
            
            switch loginResult {
                
            case .failed(let error):
                print("error :- ",error.localizedDescription)
            case .cancelled:
                print("User cancelled facebook login.")
            case .success:
                print(loginResult)
                print(AccessToken.current!)
                
                self.getUserrInfo(completion: { (reqConnection,userInfo, error) in
                    
                    if error != nil {
                        print("Error while getting Facebook info",error?.localizedDescription ?? "")
                    }
                    else {
                        
//                        self.IDToken = AccessToken.current?.tokenString ?? ""
                        
                        let dictData = userInfo! as! [String : Any]
//                        let email = dictData["email"] as? String
//                        if email == nil {
////                            self.ShowAlertVC(title: UserData.applicationName ?? "", subTitle: AlertMessages.emailIsNotAssociated)
//                            return
//                        }
//                        self.domainName = (email ?? "").components(separatedBy: "@").last ?? ""
//                        UserDefaults.standard.set(dictData, forKey: UserDefaultStrings.UserInfo)
//                        self.fbGoogleToAPIProcess(dict: dictData, IDType: "facebook")
                        
                        let firstName = dictData["first_name"] as? String
                        let lastName = dictData["last_name"] as? String
                        var emailObj = ""
                        if dictData["email"] as? String != nil{
                            emailObj = dictData["email"] as? String ?? ""
                        }
                        
                        
                        self.UserData = ["FirstName":firstName! as AnyObject,
                                         "LastName":lastName! as AnyObject,
                                         "Email":emailObj as AnyObject]
                        
                        self.stopAnimating()
                        
                        USERDEFAULTS.set(true, forKey: IS_ALREADY_LOGIN)
                        
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
                        vc.UserData = self.UserData
                        self.present(vc, animated: true, completion: nil)
                        
                    }
                })
            }
        }
    }
    
    //MARK: FaceBook USer DAta...
    
    func getUserrInfo(completion: @escaping (GraphRequestConnection?,Any?,Error?) -> Void) {
        
        let req = GraphRequest(graphPath: "me", parameters: ["fields":"email,name,picture.type(large),first_name,birthday,last_name,gender"])
        
        req.start(completionHandler: completion)
        
    }
    
//    func getFBUserData(){
//        if((FBSDKAccessToken.current()) != nil){
//            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "first_name, last_name, email"]).start(completionHandler: { (connection, result, error) -> Void in
//                if (error == nil){
//
//                    var dict : [String : AnyObject]!
//
//                    dict = result as! [String : AnyObject]
//
//                    let firstName = dict["first_name"] as? String
//                    let lastName = dict["last_name"] as? String
//                    let email = dict["email"] as? String
//
//                    self.UserData = ["FirstName":firstName! as AnyObject,
//                                     "LastName":lastName! as AnyObject,
//                                     "Email":email! as AnyObject]
//
//                    self.stopAnimating()
//
//                    USERDEFAULTS.set(true, forKey: IS_ALREADY_LOGIN)
//
//                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
//                    vc.UserData = self.UserData
//                    self.present(vc, animated: true, completion: nil)
//                }
//            })
//        }
//    }
    
    //MARK: Google Signing Integration Button Action
    @IBAction func btnGoogleSigningAction(_ sender: Any) {
        GIDSignIn.sharedInstance().signOut()
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
      
        GIDSignIn.sharedInstance().clientID = "746519021306-o8qco2usrg3dqo75c81ofbp1g5dl2cd3.apps.googleusercontent.com"
       
        GIDSignIn.sharedInstance().signInSilently()
        GIDSignIn.sharedInstance().signIn()
    }
    
    func sign(_ signIn: GIDSignIn, didSignInFor user: GIDGoogleUser, withError error: Error?) {
        
        if (error == nil) {

            let firstName = user.profile.givenName
            let lastName = user.profile.familyName
            let email = user.profile.email
            
            self.UserData = ["FirstName":firstName! as AnyObject,
                             "LastName":lastName! as AnyObject,
                             "Email":email! as AnyObject]
            
            self.stopAnimating()
            USERDEFAULTS.set(true, forKey: IS_ALREADY_LOGIN)
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
            vc.UserData = self.UserData
            self.present(vc, animated: true, completion: nil)
            
        } else {
            print("\(error?.localizedDescription)")
        }
    }
    
    func sign(_ signIn: GIDSignIn, didDisconnectWith user: GIDGoogleUser, withError error: Error?) {
        if error != nil {
            
            print("Disconnect")
        }
    }
    
    //MARK:- Google SignInDelegate UI Method
    
    // Present a view that prompts the user to sign in with Google
    func sign(_ signIn: GIDSignIn!,
              present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    // Dismiss the "Sign in with Google" view
    func sign(_ signIn: GIDSignIn!,
              dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
    }

    //MARK: LinkedIn Integration Button Action
    @IBAction func btnLinkedInAction(_ sender: Any) {
        print("click Button")

        //let vc = self.storyboard?.instantiateViewController(withIdentifier: "LinkedInViewController") as! LinkedInViewController
        //self.present(vc, animated: true, completion: nil)
        //self.navigationController?.pushViewController(vc, animated: true)
        /*
        let permission = [LISDK_BASIC_PROFILE_PERMISSION]
        LISDKSessionManager.createSession(withAuth: permission, state: nil, showGoToAppStoreDialog: true, successBlock: { (returnState) in
            let session = LISDKSessionManager.sharedInstance()?.session
            print(session?.description)
            
            LISDKAPIHelper.sharedInstance()?.getRequest("https://www.linkedin.com/uas/oauth2/authorization", success: { (response) in
                
            }, error: { (error) in
                print(error?.localizedDescription)
            })
        }) { (error) in
            print(error?.localizedDescription)
        }*/
    }
    
    
    //MARK: LOGIN Button ACtion...
    @IBAction func btnLoginClick(_ sender: Any) {
        print("txtNumber \(String(describing: emailTextField.text?.count))")
        
        self.hideKeyboardWhenTappedAround()
        
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
        let username:String = emailTextField.text!
        let password:String = passwordTextField.text!
       
        if (username.isEmpty == true || password.isEmpty == true)
        {
            let alert = UIAlertController(title: "", message: "Please Enter Email ID / Password",  preferredStyle: .alert)
            let attributedString = Utilities.alertAttribute(titleString: "Login Failed.")
            alert.setValue(attributedString, forKey: "attributedTitle")
            
            let OKAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            OKAction.setValue(alertbtnColor, forKey: "titleTextColor")
            
            alert.addAction(OKAction)
            present(alert,animated: true,completion: nil)
            
        }
        else if !(emailTextField.text!.isEmail){
            print("Please enter valid email id")
            
            let alert = UIAlertController(title: "", message: "Please Enter Valid Email ID",  preferredStyle: .alert)
            let attributedString = Utilities.alertAttribute(titleString: "Login Failed.")
            alert.setValue(attributedString, forKey: "attributedTitle")
            let okAct = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            okAct.setValue(alertbtnColor, forKey: "titleTextColor")
            
            alert.addAction(okAct)
            present(alert,animated: true,completion: nil)
        }
        else{
            UserDefaults.standard.set(username, forKey: "username")
            UserDefaults.standard.set(password, forKey: "password")
            
            let encryPassword = password.sha512()
            let param:[String : AnyObject] = ["userName":username as AnyObject,
                                              "password":encryPassword as AnyObject,
                                              "udid":UserDefaults.standard.value(forKey: DEVICE_ID)! as AnyObject,
                                              "deviceType":DEVICE_TYPE as AnyObject]
        
            
            //Progress Bar Loding...
            let size = CGSize(width: 30, height: 30)
            startAnimating(size, message: "Loading...", type: NVActivityIndicatorType(rawValue: 29))
            
            //Call Webservices                userLogin
            webService.doRequestPost(LOGIN_API_URL, params: param, key: "userLogin", delegate: self)
        }
    }
    
    //MARK: SignUp Button Action
    @IBAction func btnSignupClick(_ sender: AnyObject) {
        //print("BUtton Click...")
        //let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let signUpVC = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        self.present(signUpVC, animated: true, completion: nil)
    }
    
    //MARK: Forgot Password Action
    @IBAction func btnForgotPasswordClick(_ sender: Any) {
        
        let signUpVC = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordViewController") as! ForgotPasswordViewController
        self.present(signUpVC, animated: true, completion: nil)
    }
    
    //MARK: Subscribe Dialog Box Action

    @IBAction func btnDontshowAgainClicked(_ sender: UIButton) {
        if sender.isSelected{
            sender.isSelected = false
            imgSelectedDontshowAgain.image = UIImage(named: "uncheckbox")
            USERDEFAULTS.set(false, forKey: IS_SHOW_SUBSCRIPTION_DIALOG)
        }else{
            sender.isSelected = true
            imgSelectedDontshowAgain.image = UIImage(named: "checkbox")
            USERDEFAULTS.set(true, forKey: IS_SHOW_SUBSCRIPTION_DIALOG)
        }
    }
    
    @IBAction func btnSubscribeClicked(_ sender: Any) {
        if let url = URL(string: "https://www.myleadssite.com/subscribenow.php") {
            UIApplication.shared.open(url)
        }
    }
    
    
    @IBAction func btnRateAppClicked(_ sender: Any) {
        if let url = URL(string: "itms-apps://apple.com/app/id570173563") {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func btnLaterClicked(_ sender: Any) {
        self.viewSubscribeDialog.isHidden = true
        self.CallUserDetailsApi()
    }
    
    
    //MARK:- SignUPViewCOntrollerDelegate Method
    func txtEmailPassField(Email: String, PassWord: String) {
        emailTextField.text = Email
        passwordTextField.text = PassWord
    }
    
//    //MARK: TextField Left Image...
//
//    func addLeftImageTextField(txtField : UITextField , andImage img : UIImage){
//        let leftImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
//        leftImage.image = img
//        txtField.leftView = leftImage
//        txtField.leftViewMode = .always
//    }
    
        
    func CallUserDetailsApi()  {
        let param:[String : AnyObject] = ["userId":strUserID as AnyObject]
        
        
        //Get User Detail                                                   MleadUser**********
        self.webService.doRequestPost(GET_USER_DETAIL, params: param, key: "userDetail", delegate: self)
        
        let paramForToken = ["user_id":strUserID,
                             "device_id":USERDEFAULTS.value(forKey: DEVICE_ID),
                             "device_type":DEVICE_TYPE,
                             "push_notification_key":USERDEFAULTS.value(forKey: DEVICE_TOKEN)]
        
        
        //Progress Bar Loding...
        let size = CGSize(width: 30, height: 30)
        self.startAnimating(size, message: "Loading...", type: NVActivityIndicatorType(rawValue: 29))
        
        self.webService.doRequestPost(GET_ADD_PUSHNOTIFICATION, params: paramForToken as [String : AnyObject], key: "getAddPushNotification", delegate: self)
    }
    
    //MARK: TextFields Return Keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
}

//MARK:WEBService Responce Function.
extension LoginViewController : WebServiceDelegate {
    
    func webServiceResponceSuccess(_ response: Data, apiKey: String) {
        
        stopAnimating()
        
        let json = JSON(data: response)
        if apiKey == LOGIN_API_URL
        {
            print (json)
            let result = handleWebService.handleLogin(response)
            if result.Status
            {
                let setting = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
                UIApplication.shared.registerUserNotificationSettings(setting)
                
                //USERDEFAULTS.set(true, forKey: LOGINDEVICERESPONSE_API_URL)
                USERDEFAULTS.set(true, forKey: IS_ALREADY_LOGIN)
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    
                self.strUserID = result.UserId
                
                
                if let isShow = USERDEFAULTS.value(forKey: IS_SHOW_SUBSCRIPTION_DIALOG) as? Bool{
                    if isShow{  
                        self.viewSubscribeDialog.alpha = 0.0
                        UIView.animate(withDuration: 0.4) {
                            self.viewSubscribeDialog.isHidden = false
                            self.viewSubscribeDialog.alpha = 1.0
                        }
                    }else{
                        self.CallUserDetailsApi()
                    }
                }else{
                    self.viewSubscribeDialog.alpha = 0.0
                    UIView.animate(withDuration: 0.4) {
                        self.viewSubscribeDialog.isHidden = false
                        self.viewSubscribeDialog.alpha = 1.0
                    }
                }
                
                    
//                }
            }else{
                if json["userLogin"] != nil{
                    let userLoginData = json["userLogin"].dictionaryObject
                    if let error = userLoginData?["error"]{
                        let alert = UIAlertController(title: "", message: "" ,  preferredStyle: .alert)
                        let attributedString = Utilities.alertAttribute(titleString: error as? String ?? "Login Failed")
                        alert.setValue(attributedString, forKey: "attributedTitle")
                        
                        let OKAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        OKAction.setValue(alertbtnColor, forKey: "titleTextColor")
                        
                        alert.addAction(OKAction)
                        present(alert,animated: true,completion: nil)
                    }
                }else{
                    let alert = UIAlertController(title: "", message: json["error"].string,  preferredStyle: .alert)
                    let attributedString = Utilities.alertAttribute(titleString: "Login Failed")
                    alert.setValue(attributedString, forKey: "attributedTitle")
                    
                    let OKAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    OKAction.setValue(alertbtnColor, forKey: "titleTextColor")
                    
                    alert.addAction(OKAction)
                    present(alert,animated: true,completion: nil)
                }
            }
        }
        else if apiKey == GET_USER_DETAIL {
            let result = handleWebService.handleUserDetails(response)
            
            if result.Status
            {
                let encodedData = NSKeyedArchiver.archivedData(withRootObject: result.UserDetail)
                USERDEFAULTS.set(encodedData, forKey: LOGIN_USER_Detail)
                USERDEFAULTS.synchronize()
                
                let decodedUserDetail = USERDEFAULTS.object(forKey: LOGIN_USER_Detail) as! Data
                objLoginUserDetail = NSKeyedUnarchiver.unarchiveObject(with: decodedUserDetail) as! UserDetail?
                
                let viewController = mainStoryboard.instantiateViewController(withIdentifier: "RootViewController") as! RootViewController
                app.keyWindow?.rootViewController = viewController
            }
        }
        else if apiKey == GET_ADD_PUSHNOTIFICATION
        {
            let json = JSON(data: response)
            let result = json["AddPushNotification"]
            
            if result["status"] == "YES"
            {
                print("Add Pushnotification Successfully")
            }
        }
    }
    func webServiceResponceFailure(_ errorMessage: String) {
        
        stopAnimating()
        let alert = UIAlertController(title: "", message: errorMessage,  preferredStyle: .alert)
        //let alert = UIAlertController(title: "", message: "Please Enter Valid User Name And Password",  preferredStyle: .alert)
        let attributedString = Utilities.alertAttribute(titleString: "Login Failed")
        alert.setValue(attributedString, forKey: "attributedTitle")
        
        let OKAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        OKAction.setValue(alertbtnColor, forKey: "titleTextColor")
        
        alert.addAction(OKAction)
        present(alert,animated: true,completion: nil)
    }
}


// MARK:- Apple Sign In Delegate Methods

extension LoginViewController: ASAuthorizationControllerDelegate {

     // ASAuthorizationControllerDelegate function for authorization failed

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {

        print(error.localizedDescription)

    }

       // ASAuthorizationControllerDelegate function for successful authorization

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {

        startAnimating()
        
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {

            guard let authorizationCode = appleIDCredential.identityToken,
                let authCode = String(data: authorizationCode, encoding: .utf8) else {
                    print("Problem with the authorizationCode")
                    self.stopAnimating()
                    return
            }
            //let appleId = appleIDCredential.user
            let appleUserFirstName = appleIDCredential.fullName?.givenName
            let appleUserLastName = appleIDCredential.fullName?.familyName
            let appleUserEmail = appleIDCredential.email
            
            
//            let dictObj = ["email":appleUserEmail ?? "","name": "\(appleUserFirstName ?? "") \(appleUserLastName ?? "")"]
            
            let firstName = appleUserFirstName ?? ""
            let lastName = appleUserLastName ?? ""
            let emailObj = appleUserEmail ?? ""
            
            self.UserData = ["FirstName":firstName as AnyObject,
                             "LastName":lastName as AnyObject,
                             "Email":emailObj as AnyObject,
                             "AppleID":appleIDCredential.user as AnyObject]
            
            self.stopAnimating()
            
            USERDEFAULTS.set(true, forKey: IS_ALREADY_LOGIN)
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
            vc.UserData = self.UserData
            self.present(vc, animated: true, completion: nil)
            
            
//            if appleUserEmail == nil{
//                domainName = (appleUserEmail ?? "").components(separatedBy: "@").last ?? ""
//                self.fbGoogleToAPIProcess(dict: dictObj, IDType: "apple")
//            }else{
//                    domainName = (appleUserEmail ?? "").components(separatedBy: "@").last ?? ""
//                    self.fbGoogleToAPIProcess(dict: dictObj, IDType: "apple")
//                }
//            }
        }
        
    }
}


extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {

    //For present window

    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {

        return self.view.window!

    }

}
