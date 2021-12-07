//
//  SubscriptionPopUpViewController.swift
//  NewMleadsEnterprise
//
//  Created by MAC on 18/03/21.
//  Copyright © 2021 com.Tri-Force.MLeadsEnterprise. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class SubscriptionPopUpViewController: UIViewController, WebServiceDelegate, NVActivityIndicatorViewable {
    
    

    @IBOutlet weak var imgSelectedDontshowAgain: UIImageView!
    
    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    let webservice : WebService = WebService()
    var handleWebservice: HandleWebService = HandleWebService()
    var appdelegate = AppDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    
    @IBAction func btnCancelClicked(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    
    @IBAction func btnRateAppClicked(_ sender: Any) {
        if let url = URL(string: "itms-apps://apple.com/app/id570173563") {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func btnLaterClicked(_ sender: Any) {
        //Progress Bar Loding...
        let size = CGSize(width: 30, height: 30)
        startAnimating(size, message: "Loading...", type: NVActivityIndicatorType(rawValue: 29))

        let param:[String : AnyObject] = ["userID":objLoginUserDetail.userId! as AnyObject,"udid":UserDefaults.standard.value(forKey: DEVICE_ID)! as AnyObject]
        //Get User Detail
        webservice.doRequestPost(LOGOUT_API_URL, params: param, key: "getUnRegisterDevice", delegate: self)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    //MARK: Webservice CAll Method.
    func webServiceResponceSuccess(_ response: Data, apiKey: String) {
        stopAnimating()
        let json = JSON(data: response)
        
        if apiKey == LOGOUT_API_URL
        {
            let result = handleWebservice.handleLogOut(response)
            print(result)
            if result
            {
                //TEMPARY CLOSE THESE WINDOW......
                UIApplication.shared.unregisterForRemoteNotifications()
                USERDEFAULTS.set(false, forKey: IS_ALREADY_LOGIN)
                // let viewController = mainStoryboard.instantiateViewController(withIdentifier: "DLnevigation") as! UINavigationController
                                                                                             //HomeNevigation DLHamburguerNavigationController
                let viewController = mainStoryboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                UIWindow.key?.rootViewController = viewController
//                app.keyWindow?.rootViewController = viewController
                
//                let param:[String : AnyObject] = ["userid": result.UserId as AnyObject]
//
//                //Get User Detail
//                let size = CGSize(width: 30, height: 30)
//                self.startAnimating(size, message: "Loading...", type: NVActivityIndicatorType(rawValue: 29))
//
//                webservice.doRequestPost(LOGINDEVICERESPONSE_API_URL, params: param, key: "getRegisterDevice", delegate: self)
            }
        }
        else{
            let alert = UIAlertController(title: "", message: json["error"].string, preferredStyle: .alert)
            let attributedString = Utilities.alertAttribute(titleString: "Logout Failed")
            alert.setValue(attributedString, forKey: "attributedTitle")
            let OKAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            OKAction.setValue(alertbtnColor, forKey: "titleTextColor")
            alert.addAction(OKAction)
            present(alert,animated: true,completion: nil)
        }
        
        
    }
    
    func webServiceResponceFailure(_ errorMessage: String) {
        
        let alert = UIAlertController(title: "", message: errorMessage,  preferredStyle: .alert)
        let attributedString = Utilities.alertAttribute(titleString: "Logout Failed")
        alert.setValue(attributedString, forKey: "attributedTitle")
        let OKAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        OKAction.setValue(alertbtnColor, forKey: "titleTextColor")
        
        alert.addAction(OKAction)
        present(alert,animated: true,completion: nil)
    }

}


extension UIWindow {
    static var key: UIWindow? {
        if #available(iOS 13, *) {
            return UIApplication.shared.windows.first { $0.isKeyWindow }
        } else {
            return UIApplication.shared.keyWindow
        }
    }
}
