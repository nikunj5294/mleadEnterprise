//
//  AddTeamMemberViewController.swift
//  NewMleadsEnterprise
//
//  Created by Triforce New Mac on 18/09/19.
//  Copyright © 2019 com.Tri-Force.MLeadsEnterprise. All rights reserved.
//

import UIKit
import TextFieldEffects
import DLRadioButton
import NVActivityIndicatorView

class AddTeamMemberViewController: UIViewController,NVActivityIndicatorViewable {

    
    @IBOutlet var txtFirstName: HoshiTextField!
    @IBOutlet var txtLastName: HoshiTextField!
    @IBOutlet var txtEmailId: HoshiTextField!
    @IBOutlet var txtReTypeEmail: HoshiTextField!
    @IBOutlet var txtPhoneNo: HoshiTextField!
    
    @IBOutlet var btnMyManager: UIButton!
    @IBOutlet var lblTeamMember: UILabel!
    
    @IBOutlet var btnIndustry: UIButton!
    @IBOutlet var lblIndustry: UILabel!
    
    @IBOutlet var btnEventYes: DLRadioButton!
    @IBOutlet var btnEventNo: DLRadioButton!
    
    @IBOutlet var containerView: UIView!
    
    let webService : WebService = WebService()
    var handleWebService : HandleWebService = HandleWebService()
    var appdelegate = AppDelegate()
    
    var eventOrganizer = String()
    
    var arrTeamMamber = [String]()
    var selectedIDForTeamMember = String()
    var arrTeamCreatedTiemStemp = [String]()
    var selectedIndexForTeamMember = Int()
    var selectedStringForTeamMamber = String()
    
    var selectedIndexForIndustry = Int()
    var selectedIDForIndustry = String()
    
    var isTeamMember = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Add Team Member"
        self.findHamburguerViewController()?.gestureEnabled = false
        
        //navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(self.btnRegisterClicked(_:)))
        //navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register", style: .done, target: self, action: #selector(self.btnRegisterClicked(_:)))

        //Progress Bar Loding...
        let size = CGSize(width: 30, height: 30)
        startAnimating(size, message: "Loading...", type: NVActivityIndicatorType(rawValue: 29))
        
        //MARK: WEB SERVICES CALL...
        let param:[String : AnyObject] = ["userId":objLoginUserDetail.userId! as AnyObject, "hierarchy_type":"1" as AnyObject]
        
        webService.doRequestPost(GET_ADD_TEAM_MEMBER_LIST, params: param, key: "user", delegate: self)
        
        //EVENT ORGANIZER
        if objLoginUserDetail.eventOrganizer == "1"
        {
            btnEventNo.isSelected = true
            eventOrganizer = "1"
        }
        else
        {
            btnEventYes.isSelected = true
            eventOrganizer = "0"
        }
        
        //MARK: Industry ...
        if objLoginUserDetail.industryId == ""
        {
            if arrIndustryId.Industry.contains("Accounting")
            {
                selectedIndexForIndustry = arrIndustryId.Industry.index(of: "Accounting")!
                selectedIDForIndustry = arrIndustryId.IndustryID[selectedIndexForIndustry]
            }
        }
        else if arrIndustryId.IndustryID.contains(objLoginUserDetail.industryId!)
        {
            selectedIndexForIndustry = arrIndustryId.IndustryID.index(of: objLoginUserDetail.industryId!)!
            selectedIDForIndustry = arrIndustryId.IndustryID[selectedIndexForIndustry]
        }
        lblIndustry.text = arrIndustryId.Industry[selectedIndexForIndustry]
        
    }
    
    @objc @IBAction fileprivate func UserEventOrganizerButton(_ radioButton : DLRadioButton)
    {
        if (radioButton.isMultipleSelectionEnabled) {
            for button in radioButton.selectedButtons() {
                print(String(format: "%@ is selected.\n", button.titleLabel!.text!));
            }
        } else {
            if btnEventYes.isSelected
            {
                print(radioButton.selected()!.titleLabel!.text!)
                eventOrganizer = "1"
            }
            else
            {
                print(radioButton.selected()!.titleLabel!.text!)
                eventOrganizer = "0"
            }
        }
    }
    
    
    @IBAction func btnMyManagerAction(_ sender: Any) {
        StringPickerPopOver.appearFrom(originView: sender as! UIView, baseView: containerView, baseViewController: self, title: "Select Manager", choices: arrTeamMamber , initialRow:selectedIndexForTeamMember, doneAction: { selectedRow, selectedString in
            print("row \(selectedRow) : \(selectedString)")
            
            self.selectedIndexForTeamMember = selectedRow
            self.selectedIDForTeamMember = self.arrTeamCreatedTiemStemp[self.selectedIndexForTeamMember]
            self.lblTeamMember.text = selectedString
            print("For Member = \(self.selectedIndexForTeamMember)")
            print("Select Member id = \(self.selectedIDForTeamMember)")
            
            },cancelAction: { print("cancel")})
    }
    
    @IBAction func btnIndustryAction(_ sender: Any) {
        StringPickerPopOver.appearFrom(originView: sender as! UIView, baseView: containerView, baseViewController: self, title: "Select Manager", choices: arrIndustryId.Industry , initialRow:selectedIndexForIndustry, doneAction: { selectedRow, selectedString in
            print("row \(selectedRow) : \(selectedString)")
            
            self.selectedIndexForIndustry = selectedRow
            self.selectedIDForIndustry = arrIndustryId.IndustryID[self.selectedIndexForIndustry]
            self.lblIndustry.text = selectedString
            print("For Industry = \(self.selectedIndexForIndustry)")
            print("Select Industry id = \(self.selectedIDForIndustry)")
            
        },cancelAction: { print("cancel")})
    }
    //MARK:Register BUtton Action...
    @IBAction func btnRegisterClicked(_ sender: Any) {
        
        if  (txtFirstName.text?.isBlank)!
        {
            print("Please Enter First Name")
            
            let alert = UIAlertController(title: "", message: "Please Enter First Name",  preferredStyle: .alert)
            let attributedString = Utilities.alertAttribute(titleString: "Add Team Member")
            alert.setValue(attributedString, forKey: "attributedTitle")
            let OKAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            OKAction.setValue(alertbtnColor, forKey: "titleTextColor")
            
            alert.addAction(OKAction)
            present(alert,animated: true,completion: nil)
            
            //            let alert = UIAlertView(title: "Add Team Member", message: "Please Enter First Name" , delegate: self, cancelButtonTitle: "OK")
            //            alert.show()
        }
        else if  (txtLastName.text?.isBlank)!
        {
            print("Please Enter Last Name")
            
            let alert = UIAlertController(title: "", message: "Please Enter Last Name",  preferredStyle: .alert)
            let attributedString = Utilities.alertAttribute(titleString: "Add Team Member")
            alert.setValue(attributedString, forKey: "attributedTitle")
            let OKAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            OKAction.setValue(alertbtnColor, forKey: "titleTextColor")
            
            alert.addAction(OKAction)
            present(alert,animated: true,completion: nil)
            
            //            let alert = UIAlertView(title: "Add Team Member", message: "Please Enter Last Name" , delegate: self, cancelButtonTitle: "OK")
            //            alert.show()
        }
        else if ((txtEmailId.text?.isBlank)! || !(txtEmailId.text?.isEmail)!)
        {
            print("Please Enter Valid Email")
            
            let alert = UIAlertController(title: "", message: "Please Enter Valid Email",  preferredStyle: .alert)
            let attributedString = Utilities.alertAttribute(titleString: "Add Team Member")
            alert.setValue(attributedString, forKey: "attributedTitle")
            let OKAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            OKAction.setValue(alertbtnColor, forKey: "titleTextColor")
            
            alert.addAction(OKAction)
            present(alert,animated: true,completion: nil)
            
        }
        else if ((txtReTypeEmail.text?.isBlank)! || (txtEmailId.text != txtReTypeEmail.text))
        {
            print("Email Does Not Match")
            
            let alert = UIAlertController(title: "", message: "Email Does Not Match",  preferredStyle: .alert)
            let attributedString = Utilities.alertAttribute(titleString: "Add Team Member")
            alert.setValue(attributedString, forKey: "attributedTitle")
            let OKAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            OKAction.setValue(alertbtnColor, forKey: "titleTextColor")
            
            alert.addAction(OKAction)
            present(alert,animated: true,completion: nil)
        }
        else
        {
            
            let param:[String : String] = ["accountCreatedBy":objLoginUserDetail.userId!,
                                           "userName":"",
                                           "firstName": txtFirstName.text!,
                                           "lastName": txtLastName.text!,
                                           "email": txtEmailId.text!,
                                           "phoneNumber":"",
                                           "registerType":"E" ,
                                           "termsCondition":"1" ,
                                           "userDeviceType":"iOS",
                                           "reportsTo": (selectedIDForTeamMember as AnyObject) as! String,
                                           "companyName":"" ,
                                           "address":"" ,
                                           "city":"",
                                           "state":"",
                                           "zipCode":"",
                                           "country":"",
                                           "companyWebSite":"",
                                           "mobilePhone":"",
                                           "securityQuesId":"",
                                           "securityAnswer":"",
                                           "event_organizer_type":"1",
                                           "hearFrom":"Search Engine",
                                           "industryId":selectedIDForIndustry,
                                           "subscriptionType":"Free Trial"]
            
            //Progress Bar Loding...
            let size = CGSize(width: 30, height: 30)
            self.startAnimating(size, message: "Loading...", type: NVActivityIndicatorType(rawValue: 29))
            
            webService.doRequestPost(GET_ADD_TEAM_MEMBER_API_URL, params: param as [String : AnyObject], key: "registerFeeTrialAddTeamMember", delegate: self)
        }
    }

}
extension AddTeamMemberViewController : WebServiceDelegate{
    
    func webServiceResponceSuccess(_ response: Data, apiKey: String) {
        stopAnimating()
        if apiKey == GET_ADD_TEAM_MEMBER_LIST
        {
            let result = handleWebService.handleGetAddTeamMember(response)
            
            if result.Status
            {
                print(result.Status)
                
                let arrTempTeamName = NSMutableArray()
                let arrTempCreatedTimestamp = NSMutableArray()
                let arrTempReportsTo = NSMutableArray()
                let arrTempExportAllowed = NSMutableArray()
                
                for i in 0...result.teamMember.count-1
                {
                    arrTeamMamber.append(result.teamMember[i].first_name!  + " " + result.teamMember[i].last_name!)
                    arrTempReportsTo.add(result.teamMember[i].reportsTo!)
                    arrTempExportAllowed.add(result.teamMember[i].export_allowed!)
                    arrTeamCreatedTiemStemp.append(result.teamMember[i].created_timestamp!)
                    //arrTempCreatedTimestamp.add(result.teamMember[i].created_timestamp!)
                    
                    
                    if arrTeamCreatedTiemStemp[i] == objLoginUserDetail.userId
                    {
                        lblTeamMember.text = arrTeamMamber[i]
                    }
                    isTeamMember = "1"
                }
            }
        }
        else if apiKey == GET_ADD_TEAM_MEMBER_API_URL
        {
            let json = JSON(data: response)
            let result = json["registerFeeTrialAddTeamMember"]
            
            if result["status"] == "YES"
            {
                let alert = UIAlertController(title: "", message: "Team Member Added Successfully.",  preferredStyle: .alert)
                let attributedString = Utilities.alertAttribute(titleString: "Add Team Member!")
                alert.setValue(attributedString, forKey: "attributedTitle")
                let OKAction = UIAlertAction(title: "OK", style: .default, handler: { UIAlertAction in
                    _ = self.navigationController?.popViewController(animated: true)
                })
                OKAction.setValue(alertbtnColor, forKey: "titleTextColor")
                
                alert.addAction(OKAction)
                present(alert,animated: true,completion: nil)
            }
            else
            {
                let alert = UIAlertController(title: "", message: "Email already exists",  preferredStyle: .alert)
                let attributedString = Utilities.alertAttribute(titleString: "Add Member")
                alert.setValue(attributedString, forKey: "attributedTitle")
                let OKAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                OKAction.setValue(alertbtnColor, forKey: "titleTextColor")
            
                alert.addAction(OKAction)
                present(alert,animated: true,completion: nil)
            }
        }
    }
    func webServiceResponceFailure(_ errorMessage: String) {
        stopAnimating()
        
        let alert = UIAlertController(title: "", message: errorMessage,  preferredStyle: .alert)
        let attributedString = Utilities.alertAttribute(titleString: "")
        alert.setValue(attributedString, forKey: "attributedTitle")
        let OKAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        OKAction.setValue(alertbtnColor, forKey: "titleTextColor")
        
        alert.addAction(OKAction)
        present(alert,animated: true,completion: nil)
    }
    
}

