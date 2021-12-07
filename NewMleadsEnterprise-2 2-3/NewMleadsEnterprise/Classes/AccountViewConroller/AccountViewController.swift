//
//  AccountViewController.swift
//  NewMleadsEnterprise
//
//  Created by  on 17/05/19.
//  Copyright © 2019 com.Tri-Force.MLeadsEnterprise. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class AccountViewController: UIViewController,NVActivityIndicatorViewable,WebServiceDelegate {
    
    var menuSegues = NSMutableArray()
    var images = Array<UIImage>()
    var alertbtnColor = Utilities.alertButtonColor()
    
    var appdelegate = AppDelegate()
    let webService : WebService = WebService()
    var handleWebService : HandleWebService = HandleWebService()
    
    @IBOutlet var tblView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "My Account"
        self.findHamburguerViewController()?.gestureEnabled = false
        
        
        //self.AddBarButton()
//        tblView.rowHeight = UITableView.automaticDimension
//        tblView.estimatedRowHeight = 113
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        menuSegues = ["Profile", "QR Code","Video Presentation","Team Management And ResetPassword"]
        images = [#imageLiteral(resourceName: "myprofile"),#imageLiteral(resourceName: "qrcode"),#imageLiteral(resourceName: "video"),#imageLiteral(resourceName: "team")]
        tblView.reloadData()
    }
    
    //MARK: Button Action
    @IBAction func btnBackAction(_ sender: Any) {
        
    }
    
//    func AddBarButton() {
//
//        let btnName = UIButton()
//        btnName.setImage(#imageLiteral(resourceName: "LeftArrow"), for: .normal)
//        btnName.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30)
//        btnName.addTarget(self, action: Selector("action"), for: .touchUpInside)
//
//        let rightBarButton = UIBarButtonItem()
//        rightBarButton.customView = btnName
//
//        self.navigationItem.rightBarButtonItem = rightBarButton
//    }
 
    
    //MARK: WebServices Delegate Method
    func webServiceResponceSuccess(_ response: Data, apiKey: String) {
        
            //Progress Bar Loding...
            let size = CGSize(width: 30, height: 30)
            startAnimating(size, message: "Loading...", type: NVActivityIndicatorType(rawValue: 29))
    }
    
    func webServiceResponceFailure(_ errorMessage: String) {

        let alert = UIAlertController(title: "", message: errorMessage,  preferredStyle: .alert)
        let attributedString = Utilities.alertAttribute(titleString: "")
        alert.setValue(attributedString, forKey: "attributedTitle")
        let OKAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        OKAction.setValue(alertbtnColor, forKey: "titleTextColor")

        alert.addAction(OKAction)
        present(alert,animated: true,completion: nil)
    }
    
}

 //MARK: TableView Dalegate Method:
extension AccountViewController:UITableViewDelegate,UITableViewDataSource{
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuSegues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellAccount", for: indexPath)
        
        let imgIcon : UIImageView = cell.contentView.viewWithTag(101) as! UIImageView
        let lblTitle : UILabel = cell.contentView.viewWithTag(102) as! UILabel
        
        imgIcon.image = images[indexPath.row]
        lblTitle.text = menuSegues[indexPath.row] as? String
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("indexPath\(indexPath.row)")
        if indexPath.row == 0{
            print(" PRofile IN Account..")
            let VC = mainStoryboard.instantiateViewController(withIdentifier:  "ProfileViewController") as! ProfileViewController
            self.navigationController?.pushViewController(VC, animated: true)
        }
        else if indexPath.row == 1{
            print("QR Code...")
            //let userOBj : UserDetail
            //userOBj =
            let VC = mainStoryboard.instantiateViewController(withIdentifier:  "QRCodeViewController") as! QRCodeViewController
            //VC.QR = userOBj.firstName!
            self.navigationController?.pushViewController(VC, animated: true)
        }
        else if indexPath.row == 2{
            print("Video Profile ...")
            let VC = mainStoryboard.instantiateViewController(withIdentifier:  "VideoPresentationViewController") as! VideoPresentationViewController
            VC.isVideoList = true
            self.navigationController?.pushViewController(VC, animated: true)
        }
        else if indexPath.row == 3 {
            print("TeamManagement & Reset Password...")
            let VC = mainStoryboard.instantiateViewController(withIdentifier:  "TeamManagementAndResetPasswordViewController") as! TeamManagementAndResetPasswordViewController
            self.navigationController?.pushViewController(VC, animated: true)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
}
