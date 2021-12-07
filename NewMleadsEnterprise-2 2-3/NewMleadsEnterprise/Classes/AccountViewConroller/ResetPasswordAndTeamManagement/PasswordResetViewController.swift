//
//  PasswordResetViewController.swift
//  NewMleadsEnterprise
//
//  Created by Triforce New Mac on 07/09/19.
//  Copyright © 2019 com.Tri-Force.MLeadsEnterprise. All rights reserved.
//

import UIKit
import TextFieldEffects
import NVActivityIndicatorView

class PasswordResetViewController: UIViewController ,NVActivityIndicatorViewable{

    @IBOutlet var btnTeamMember: UIButton!
    @IBOutlet var lblTeamMember: UILabel!
    @IBOutlet var txtCurrentPassword: HoshiTextField!
    @IBOutlet var txtNewPassword: HoshiTextField!
    @IBOutlet var txtConfirmPassword: HoshiTextField!
    
    let webService : WebService = WebService()
    var handleWebService : HandleWebService = HandleWebService()
    var appdelegate = AppDelegate()
    
    var arrOfDictionary = [[String : String]]()
    var arrTeamName = [String]()
    var selectedIndexForTeamMember = Int()
    var selectedID = String()
    var reportID = String()
    var selectedRow = Int()
    //var arrTempReportsTo = NSMutableArray()
    var arrTeamCreatedTiemStemp = [String]()
    var isTeamMember = String()
    
    //let arrTempReportsTo = NSMutableArray()
    
   // var arrTeamCreatedTiemStemp = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationController?.isNavigationBarHidden = true
        self.navigationItem.title = "PassWord Reset"
        self.findHamburguerViewController()?.gestureEnabled = false
        
        //Progress Bar Loding...
        let size = CGSize(width: 30, height: 30)
        startAnimating(size, message: "Loading...", type: NVActivityIndicatorType(rawValue: 29))
        
        let param:[String : AnyObject] = ["userId":objLoginUserDetail.userId! as AnyObject, "hierarchy_type":"0" as AnyObject]

        webService.doRequestPost(GET_ADD_TEAM_MEMBER_LIST, params: param, key: "user", delegate: self)
        
       

    }
   
    @IBAction func btnBackArrowAction(_ sender: Any) {
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TeamManagementAndResetPasswordViewController") as! TeamManagementAndResetPasswordViewController
//        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func btnTeamMemberDropDown(_ sender: Any) {
        print("Click On Button in TeamManagement")
        StringPickerPopOver.appearFrom(originView: sender as! UIView, baseView: self.btnTeamMember, baseViewController: self, title: "Select Member", choices: arrTeamName , initialRow:selectedIndexForTeamMember, doneAction: { selectedRow, selectedString in
            print("row \(selectedRow) : \(selectedString)")
            
            self.selectedIndexForTeamMember = selectedRow
            self.selectedID = self.arrTeamCreatedTiemStemp[self.selectedIndexForTeamMember]
            self.lblTeamMember.text = selectedString
            print("FOR MEMBER: \(self.selectedIndexForTeamMember)")
            print("SELECCTED ID: \(self.selectedID)")
            //self.reportID = self.arrTempReportsTo[self.selectedIndexForTeamMember] as! String
            //print("reportID\(self.reportID)")
            
//            self.selectedRow = selectedRow
//            var reportsTo = String()
//
//            for i in 0..<self.arrOfDictionary.count
//            {
//                let name = self.arrOfDictionary[i] as NSDictionary
//                if (name.value(forKey: objLoginUserDetail.createTimeStamp!) != nil){
//                    reportsTo = name.value(forKey: objLoginUserDetail.createTimeStamp!) as! String
//                }
//            }
//
//            print("Report To of Login User is : \(reportsTo)")
//
            if self.selectedIndexForTeamMember == 0
            {
                self.txtCurrentPassword.isHidden = false
                self.isTeamMember = "0"
            }
            else
            {
                self.txtCurrentPassword.isHidden = true
                self.isTeamMember = "1"
            }
        }, cancelAction:{print("cancel")})
    }
    
    
    //MARK: BUTTON SUBMIT ACTION...
    @IBAction func btnSubmitAction(_ sender: Any) {
        if ((txtCurrentPassword.text?.isEmpty)! && txtCurrentPassword.isHidden == false)
        {
            if self.isTeamMember == "0" {
                
                print("Your Current Password is Missing")
                
                let alert = UIAlertController(title: "", message: "Your Current Password is Missing or Incorrect",  preferredStyle: .alert)
                let attributedString = Utilities.alertAttribute(titleString: "Reset Password Failed")
                alert.setValue(attributedString, forKey: "attributedTitle")
                let okAct = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                
                okAct.setValue(alertbtnColor, forKey: "titleTextColor")
                
                alert.addAction(okAct)
                present(alert,animated: true,completion: nil)
                
            }
        }
        else if ((txtNewPassword.text?.isEmpty)! || ((txtNewPassword.text?.characters.count)!) < 6)
        {
            print("Please Enter New Password")
            
            let alert = UIAlertController(title: "", message: "Please Enter New Password",  preferredStyle: .alert)
            let attributedString = Utilities.alertAttribute(titleString: "Reset Password Failed")
            alert.setValue(attributedString, forKey: "attributedTitle")
            let okAct = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            okAct.setValue(alertbtnColor, forKey: "titleTextColor")
            
            alert.addAction(okAct)
            present(alert,animated: true,completion: nil)
        }
        else if ((txtConfirmPassword.text?.isEmpty)! || ((txtConfirmPassword.text?.characters.count)!) < 6){
            print("Please Enter Confirm Password")
            
            let alert = UIAlertController(title: "", message: "Please Enter Confirm Password",  preferredStyle: .alert)
            let attributedString = Utilities.alertAttribute(titleString: "Reset Password Failed")
            alert.setValue(attributedString, forKey: "attributedTitle")
            let okAct = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            okAct.setValue(alertbtnColor, forKey: "titleTextColor")
            
            alert.addAction(okAct)
            present(alert,animated: true,completion: nil)
        }
        else if (txtNewPassword.text != txtConfirmPassword.text){
            
            print("Password Does Not Match")
            
            let alert = UIAlertController(title: "", message: "Password Does Not Match",  preferredStyle: .alert)
            let attributedString = Utilities.alertAttribute(titleString: "Reset Password Failed")
            alert.setValue(attributedString, forKey: "attributedTitle")
            let okAct = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            okAct.setValue(alertbtnColor, forKey: "titleTextColor")
            
            alert.addAction(okAct)
            present(alert,animated: true,completion: nil)
        }
        else{
            
            let currentPass = txtCurrentPassword.text?.sha512()
            let newPass = txtNewPassword.text?.sha512()

            let param:[String : AnyObject] = [//"userId":objLoginUserDetail.userId! as AnyObject,
                                              "userId":objLoginUserDetail.createTimeStamp as AnyObject,
                                              "selectedId":objLoginUserDetail.createTimeStamp as AnyObject,
                                              "is_teamMember":isTeamMember as AnyObject,
                                              "oldPassword":currentPass as AnyObject,
                                              "newPassword":newPass as AnyObject,
                                              "updatedTimeStamp":objLoginUserDetail.updateTimeStamp as AnyObject]
            
            //Progress Bar Loding...
            let size = CGSize(width: 30, height: 30)
            startAnimating(size, message: "Loading...", type: NVActivityIndicatorType(rawValue: 29))
            webService.doRequestPost(RESET_PASSWORD_API_URL, params: param, key: "userChangePassword", delegate: self)
        }
    }
}
extension PasswordResetViewController: WebServiceDelegate,UIAlertViewDelegate{
    
    func webServiceResponceSuccess(_ response: Data, apiKey: String) {
        stopAnimating()
        if apiKey == GET_ADD_TEAM_MEMBER_LIST
        {
            let result = handleWebService.handleGetAddTeamMember(response)
            
            if result.Status
            {
                
                let arrTempTeamName = NSMutableArray()
                let arrTempCreatedTimestamp = NSMutableArray()
                let arrTempReportsTo = NSMutableArray()
                let arrTempExportAllowed = NSMutableArray()
                
                for i in 0...result.teamMember.count-1
                {
                    arrTeamName.append(result.teamMember[i].first_name!  + " " + result.teamMember[i].last_name!)
                    arrTempReportsTo.add(result.teamMember[i].reportsTo!)
                    arrTempExportAllowed.add(result.teamMember[i].export_allowed!)
                    arrTeamCreatedTiemStemp.append(result.teamMember[i].created_timestamp!)
                    //arrTempCreatedTimestamp.add(result.teamMember[i].created_timestamp!)
                    
                    
                    if arrTeamCreatedTiemStemp[i] == objLoginUserDetail.userId
                    {
                        lblTeamMember.text = arrTeamName[i]
                    }
                    isTeamMember = "0"
                }
            }
        }
        else if apiKey == RESET_PASSWORD_API_URL
        {
            
            let result = handleWebService.handleResetPassword(response)
            
//            let json = JSON(data: response)
//            //        let result = json["userSignUp"]
            //if json["status"].string == "YES"
            if result
            {
                print(result)
                let alert = UIAlertController(title: "", message: "Password Change Successfully",  preferredStyle: .alert)
                let attributedString = Utilities.alertAttribute(titleString: "Reset Password")
                alert.setValue(attributedString, forKey: "attributedTitle")
                let okAct = UIAlertAction(title: "OK", style: .default, handler: {UIAlertAction in
                    _ = self.navigationController?.popViewController(animated: true)
                })
                
                okAct.setValue(alertbtnColor, forKey: "titleTextColor")
                
                alert.addAction(okAct)
                present(alert,animated: true,completion: nil)
            }
        }
        else{
            print("Reset password unsccess.....")
            
            let alert = UIAlertController(title: "", message: "Failed",  preferredStyle: .alert)
            let attributedString = Utilities.alertAttribute(titleString: "Reset Password Failed")
            alert.setValue(attributedString, forKey: "attributedTitle")
            let okAct = UIAlertAction(title: "OK", style: .default, handler: {UIAlertAction in
                _ = self.navigationController?.popViewController(animated: true)
            })
            
            okAct.setValue(alertbtnColor, forKey: "titleTextColor")
            
            alert.addAction(okAct)
            present(alert,animated: true,completion: nil)
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
