//
//  SideMenuViewController.swift
//  NewMleadsEnterprise
//
//  Created by  on 09/05/19.
//  Copyright © 2019 com.Tri-Force.MLeadsEnterprise. All rights reserved.
//

import UIKit
import SSKeychain
import NVActivityIndicatorView
import SDWebImage

class SideMenuViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,WebServiceDelegate,NVActivityIndicatorViewable {
    
    @IBOutlet var imgProfileUpload: RoundImageEffects!
    
    @IBOutlet var btnUploadProfile: UIButton!
    
    var menuSegues = NSMutableArray()
    var menuImage = Array<UIImage>()
    
    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    
    let webservice : WebService = WebService()
    var handleWebservice: HandleWebService = HandleWebService()
    var appdelegate = AppDelegate()
    
    @IBOutlet var tblViewMenu: UITableView!
    @IBOutlet var lblName: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let tapGesture = UITapGestureRecognizer(target: self, action: "AddViewController")
//        imgProfileUpload.addGestureRecognizer(tapGesture)
//        imgProfileUpload.isUserInteractionEnabled = true
        
        if USERDEFAULTS.bool(forKey: IS_ALREADY_LOGIN)
        {

//            var udid1 = HandleWebService.getUniqueDeviceIdentifier(as: AppDelegate)
//
//            var udid1 = objMLeadServices.getUniqueDeviceIdentifier(asString: appDelegate.objCurrentUser.createTimeStamp)
//            var loginUserId = UserDefaults.standard.object(forKey: kLoginId) as? String
//
//            let name = objLoginUserDetail.firstName! + " " + objLoginUserDetail.lastName!
//            lblName.text = name
//            lblEmail.text = objLoginUserDetail.email

        }
        menuSegues = ["Account","Settings","ReferToFriend","Logout"]
        menuImage = [#imageLiteral(resourceName: "account"),#imageLiteral(resourceName: "setting"),#imageLiteral(resourceName: "pr1"),#imageLiteral(resourceName: "logout")]
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.updatePhoto(_:)),
            name: Notification.Name("updatedthephoto"),
            object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        SDImageCache.shared.clearMemory()
        SDImageCache.shared.clearDisk()
        
        if let decodedUserDetail = USERDEFAULTS.object(forKey: LOGIN_USER_Detail) as? Data{
            objLoginUserDetail = NSKeyedUnarchiver.unarchiveObject(with: decodedUserDetail) as! UserDetail!
//            print("objLoginUserDetail Model Data Side Menu : \(objLoginUserDetail)")
            
            if objLoginUserDetail.firstName != nil{
                lblName.text = objLoginUserDetail.firstName!
            }
            
            if objLoginUserDetail.lastName != nil{
                lblName.text = lblName.text!.count > 0 ? "\(lblName.text!) \(objLoginUserDetail.lastName!)" : "\(objLoginUserDetail.lastName!)"
            }
            
            imgProfileUpload.sd_setImage(with: URL(string: objLoginUserDetail.profileImage ?? ""), placeholderImage: UIImage(named: "ic_img_user"), options: .continueInBackground)
        }
    }
    
    @objc func updatePhoto(_ notification: NSNotification) {
        if let dict = notification.userInfo as NSDictionary? {
                    if let imageData = dict["image"] as? UIImage{
                        // do something with your image
                        imgProfileUpload.image = imageData
                    }
                }
        
    }
    
    //MARK: IMAGE PROFILE UPLOAD...
    @IBAction func btnUploadProfileAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ImageProfileViewController") as! ImageProfileViewController
        vc.image = imgProfileUpload.image!
        vc.isFromSideMenu = true
        self.present(vc, animated: true, completion: nil)
    }
    
    
    //MARK: UITableView Delegate And DataSource Method.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuSegues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "CellMenu")!
        
        let imgIcon : UIImageView = cell.contentView.viewWithTag(100)as! UIImageView
        let lblTitle : UILabel = cell.contentView.viewWithTag(101)as! UILabel
        
        imgIcon.image = menuImage[indexPath.row]
        lblTitle.text  = menuSegues[indexPath.row] as! String
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let nvc = self.mainNavigationController()
        
        print("indexPath\(indexPath.row)")
        if indexPath.row == 0
        {
            //self.findHamburguerViewController()?.hideMenuViewControllerWithCompletion(nil)
            if let hamburguerViewController = self.findHamburguerViewController() {
                hamburguerViewController.hideMenuViewControllerWithCompletion({ () -> Void in
                    
                    print("YES")
                    nvc.visibleViewController!.performSegue(withIdentifier: self.menuSegues[indexPath.row] as! String, sender: nil)
                    hamburguerViewController.contentViewController = nvc
                    objLoginUserDetail.registeredEventId = ""
                })
            }
            //self.findHamburguerViewController()?.hideMenuViewControllerWithCompletion({ () -> Void in})
        }
        else if menuSegues.count-1 > indexPath.row
        {
        
            if let hamburguerViewController = self.findHamburguerViewController() {
                hamburguerViewController.hideMenuViewControllerWithCompletion({ () -> Void in
                    
                    print("YES")
                    nvc.visibleViewController!.performSegue(withIdentifier: self.menuSegues[indexPath.row] as! String, sender: nil)
                    hamburguerViewController.contentViewController = nvc
                    objLoginUserDetail.registeredEventId = ""
                })
            }
            else
            {
                print("NO")
            }
        }

      /*  if indexPath.row == 0
        {
            //self.findHamburguerViewController()?.hideMenuViewControllerWithCompletion(nil)
            self.findHamburguerViewController()?.hideMenuViewControllerWithCompletion({ () -> Void in})

            let myLeadtVC = mainStoryboard.instantiateViewController(withIdentifier: "AccountViewController") as! AccountViewController
            self.navigationController?.pushViewController(myLeadtVC, animated: true)

        }else if indexPath.row == 1{

            print("Setting ViewController Page")
            self.findHamburguerViewController()?.hideMenuViewControllerWithCompletion({ () -> Void in})
           let myLeadtVC = mainStoryboard.instantiateViewController(withIdentifier:  "SettingViewController") as! SettingViewController
           self.navigationController?.pushViewController(myLeadtVC, animated: true)
        }else if indexPath.row == 2 {
            print("REfer Friend.")
        }*/
            
        else
        {
            if let hamburguerViewController = self.findHamburguerViewController() {
                hamburguerViewController.hideMenuViewControllerWithCompletion({ () -> Void in
                    
                    if let isShow = USERDEFAULTS.value(forKey: IS_SHOW_SUBSCRIPTION_DIALOG) as? Bool{
                        if isShow{
                            NotificationCenter.default.post(name: Notification.Name("OpenSubscriptionDialog"), object: nil)
                        }else{
                            //Progress Bar Loding...
                            let size = CGSize(width: 30, height: 30)
                            self.startAnimating(size, message: "Loading...", type: NVActivityIndicatorType(rawValue: 29))
    
                            let param:[String : AnyObject] = ["userID":objLoginUserDetail.userId! as AnyObject,"udid":UserDefaults.standard.value(forKey: DEVICE_ID)! as AnyObject]
                            //Get User Detail
                            self.webservice.doRequestPost(LOGOUT_API_URL, params: param, key: "getUnRegisterDevice", delegate: self)
                
                        }
                    }else{
                        NotificationCenter.default.post(name: Notification.Name("OpenSubscriptionDialog"), object: nil)
                    }
                    
                    
                    
                    

//                    let VC = self.storyboard?.instantiateViewController(identifier: "SubscriptionPopUpViewController")
//                    VC!.modalPresentationStyle = .overCurrentContext
//                    self.parent?.navigationController?.present(VC!, animated: true, completion: nil)
                })
            }
            
 
         
            
            
            //TEMPARY CLOSE WINDOW..........*******
            //LOGOUT
//            UIApplication.shared.unregisterForRemoteNotifications()
//            USERDEFAULTS.set(false, forKey: IS_ALREADY_LOGIN)
//            // let viewController = mainStoryboard.instantiateViewController(withIdentifier: "DLnevigation") as! UINavigationController
//                                                                                         //HomeNevigation DLHamburguerNavigationController
//            let viewController = mainStoryboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
//            app.keyWindow?.rootViewController = viewController;
        }
        
    }
    
    
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
                app.keyWindow?.rootViewController = viewController;
                
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

   func mainNavigationController() -> DLHamburguerNavigationController{    //HomeNevigation    DLHamburguerNavigationController
        return self.storyboard?.instantiateViewController(withIdentifier: "HomeNevigation") as! DLHamburguerNavigationController
    }
    
}
