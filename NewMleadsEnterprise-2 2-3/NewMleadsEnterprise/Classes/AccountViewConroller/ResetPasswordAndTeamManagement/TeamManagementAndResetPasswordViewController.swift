//
//  TeamManagementAndResetPasswordViewController.swift
//  NewMleadsEnterprise
//
//  Created by Triforce New Mac on 14/08/19.
//  Copyright © 2019 com.Tri-Force.MLeadsEnterprise. All rights reserved.
//

import UIKit
import  NVActivityIndicatorView

class TeamManagementAndResetPasswordViewController: UIViewController, NVActivityIndicatorViewable {

    @IBOutlet var tblView: UITableView!
    
    
    var menuSegues = NSMutableArray()
    var images = Array<UIImage>()
    var alertbtnColor = Utilities.alertButtonColor()
    
    var appdelegate = AppDelegate()
    let webService : WebService = WebService()
    var handleWebService : HandleWebService = HandleWebService()
    
    var hierarchy = String()
    
    let NameArr = ["Password Reset","Manage Export Ability","TeamManageMent You can transfer or delete account","Add TeamMember","Current Team Hierarchy - Visibility to 3 Level - Touch to Change"]
    let ImageArr:[UIImage] = [UIImage(named: "password-reset1")!,UIImage(named: "export152")!,UIImage(named: "team-mang")!,UIImage(named: "Team-management")!,UIImage(named: "add-team-member")!]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationController?.isNavigationBarHidden = true
        self.navigationItem.title = "ResetPassword & TeamManage"
        var backImage = UIImage(named: "LeftArrow")
//        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: backImage, style: UIBarButtonItem.Style.plain, target: nil, action: nil)
    
        tblView.delegate = self
        tblView.dataSource = self
        
        
    }
}

//MARK: UITableView DAta Source And DElegate MEthod...
extension TeamManagementAndResetPasswordViewController: UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NameArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ResetAndTeamMemberCell
        cell.lblName.text = NameArr[indexPath.row]
        cell.imgName.image = ImageArr[indexPath.row]
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.layer.borderColor = UIColor.gray.cgColor
        cell?.layer.borderWidth = 2
        
        print("indexPath\(indexPath.row)")
        if indexPath.row == 0{
            let passWordResetVC = mainStoryboard.instantiateViewController(withIdentifier:  "PasswordResetViewController") as! PasswordResetViewController
            self.navigationController?.pushViewController(passWordResetVC, animated: true)
        }
        else if indexPath.row == 1{
            let VC = mainStoryboard.instantiateViewController(withIdentifier:  "ManageExportAbilityViewController") as! ManageExportAbilityViewController
            self.navigationController?.pushViewController(VC, animated: true)
            
        }
        else if indexPath.row == 2{
            let VC = mainStoryboard.instantiateViewController(withIdentifier:  "TeamManagementViewController") as! TeamManagementViewController
            self.navigationController?.pushViewController(VC, animated: true)
            
        }
        else if indexPath.row == 3{
            let teamMemberVC = mainStoryboard.instantiateViewController(withIdentifier:  "AddTeamMemberViewController") as! AddTeamMemberViewController
            self.navigationController?.pushViewController(teamMemberVC, animated: true)
        }
            
        else if indexPath.row == 4{
            print("Click On Current Team Hierarchy Visible Level 3.0..")
            
            if objLoginUserDetail.seeFullHeirarchy == "1"
            {
                hierarchy = "0"

                let alert = UIAlertController(title: "", message: "Team members and their activities up to 3 levels below you in your organization will be shown to you.",  preferredStyle: .alert)
                let attributedString = Utilities.alertAttribute(titleString: "Team Member Limited Hierarchy")
                alert.setValue(attributedString, forKey: "attributedTitle")
                let okAct = UIAlertAction(title: "OK", style: .default, handler: {UIAlertAction in
                    let param = ["flag":"hierarchy",
                                 "user_id":objLoginUserDetail.createTimeStamp,
                                 "createdTimeStamp":objLoginUserDetail.createTimeStamp,
                                 "hierarchy":self.hierarchy]

                    //Progress Bar Loading...
                    let size = CGSize(width: 30, height: 30)
                    self.startAnimating(size, message: "Loading...", type: NVActivityIndicatorType(rawValue: 29))

                    self.webService.doRequestPost(UPDATE_USER_API_URL, params: param as [String : AnyObject], key: "updateUser", delegate: self)
                })
                let cancelAct = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

                okAct.setValue(alertbtnColor, forKey: "titleTextColor")
                cancelAct.setValue(alertbtnColor, forKey: "titleTextColor")

                alert.addAction(okAct)
                alert.addAction(cancelAct)
                present(alert,animated: true,completion: nil)
            }
            else
            {
                hierarchy = "1"

                let alert = UIAlertController(title: "", message: "All the team members and their activities in your organization below your level will be shown to you.",  preferredStyle: .alert)
                let attributedString = Utilities.alertAttribute(titleString: "Team Member Full Hierarchy")
                alert.setValue(attributedString, forKey: "attributedTitle")
                let okAct = UIAlertAction(title: "OK", style: .default, handler: {UIAlertAction in
                    let param = ["flag":"hierarchy",
                                 "user_id":objLoginUserDetail.createTimeStamp,
                                 "createdTimeStamp":objLoginUserDetail.createTimeStamp,
                                 "hierarchy":self.hierarchy]

                    //Progress Bar Loading...
                    let size = CGSize(width: 30, height: 30)
                    self.startAnimating(size, message: "Loading...", type: NVActivityIndicatorType(rawValue: 29))

                    self.webService.doRequestPost(UPDATE_USER_API_URL, params: param as [String : AnyObject], key: "updateUser", delegate: self)
                })
                let cancelAct = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

                okAct.setValue(alertbtnColor, forKey: "titleTextColor")
                cancelAct.setValue(alertbtnColor, forKey: "titleTextColor")

                alert.addAction(okAct)
                alert.addAction(cancelAct)
                present(alert,animated: true,completion: nil)

            }
        }
        else{
            print("Select Any Cell")
        }
    }
}
//MARK: Webservice Delegate Method....
extension TeamManagementAndResetPasswordViewController: WebServiceDelegate{
    
    func webServiceResponceSuccess(_ response: Data, apiKey: String) {
        stopAnimating()
        
        if apiKey == UPDATE_USER_API_URL
        {
            let json = JSON(data: response)
            if json["updateUser"]["status"] == "YES"
            {
                if hierarchy == "0"{
                    
                    objLoginUserDetail.seeFullHeirarchy = "0"
                }
                else{
                    
                    objLoginUserDetail.seeFullHeirarchy = "1"
                }
                //tblView.reloadData()
            }
        }
    }
    
    func webServiceResponceFailure(_ errorMessage: String) {
        stopAnimating()
        
        let alert = UIAlertController(title: "", message: errorMessage,  preferredStyle: .alert)
        let attributedString = Utilities.alertAttribute(titleString: "")
        alert.setValue(attributedString, forKey: "attributedTitle")
        let okAct = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        okAct.setValue(alertbtnColor, forKey: "titleTextColor")
        
        alert.addAction(okAct)
        present(alert,animated: true,completion: nil)
    }
}
