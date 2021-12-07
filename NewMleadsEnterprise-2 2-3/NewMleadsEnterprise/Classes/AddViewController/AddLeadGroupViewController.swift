//
//  AddLeadGroupViewController.swift
//  NewMleadsEnterprise
//
//  Created by Triforce New Mac on 21/08/19.
//  Copyright © 2019 com.Tri-Force.MLeadsEnterprise. All rights reserved.
//

import UIKit
import TextFieldEffects
import DLRadioButton
import NVActivityIndicatorView

class AddLeadGroupViewController: UIViewController,UITextFieldDelegate,NVActivityIndicatorViewable,WebServiceDelegate {
    
    @IBOutlet var btnDate: UIButton!
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var ContainerView: UIView!
    
    @IBOutlet var btnVisibleTeamMember: DLRadioButton!
    @IBOutlet var btnVisibleOnlyMe: DLRadioButton!
    
    @IBOutlet var txtGroupName: HoshiTextField!
    @IBOutlet var txtLeadsource: HoshiTextField!
    @IBOutlet var txtPhoneNo: HoshiTextField!
    @IBOutlet var txtPurpose: HoshiTextField!
    @IBOutlet var txtContactPerson: HoshiTextField!
    
    @IBOutlet var txtNote: UITextView!
    
    var initialStartDate = Date()
    var StartDate = Date()
    var strStartDate = String()
    var isPrivate = String()
    var alertTitle = String()
    var isFirstTime = Bool()
    var strLeadGroupDate = String()
    var isViewLeadGroup = Bool()
    var isAttende = Bool()
    
    var dateTimeStamp = Date()
    
    var objLeadGroupDetail: LeadGroupDetail = LeadGroupDetail()
    var appdelegate = AppDelegate()
    let webService : WebService = WebService()
    var handleWebService : HandleWebService = HandleWebService()
    var alertbtnColor = Utilities.alertButtonColor()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.hideKeyboardWhenTappedAround()
        self.navigationItem.title = "Add Lead Group"
        self.findHamburguerViewController()?.gestureEnabled = false
        
        btnVisibleTeamMember.isSelected = true
        isPrivate = "N"
        
        alertTitle = "Add LeadGroup!"
        
        let currentDate = Utilities.DateToStringFormatter(Date: Date(), ToString: "MM-dd-yyyy")
        lblDate.text = currentDate
        strLeadGroupDate = Utilities.dateFormatter(Date: lblDate.text!, FromString: "MM-dd-yyyy", ToString: "yyyy-MM-dd")
        self.strStartDate = Utilities.dateFormatter(Date: lblDate.text!, FromString: "MM-dd-yyyy", ToString: "yyyy-MM-dd")
        
        isFirstTime = true
        
        if isViewLeadGroup
        {
            self.navigationItem.title = "View LeadGroup"
            txtGroupName.isUserInteractionEnabled = false
            
            txtPurpose.isUserInteractionEnabled = false
            txtContactPerson.isUserInteractionEnabled = false
            txtPhoneNo.isUserInteractionEnabled = false
            txtNote.isUserInteractionEnabled = false
            btnDate.isUserInteractionEnabled = false

            btnVisibleTeamMember.isUserInteractionEnabled = false
            btnVisibleOnlyMe.isUserInteractionEnabled = false
            
            LeadGroupDataField()
        }
    }
    
    //MARK:- Custom Function
    func LeadGroupDataField(){
        
        txtGroupName.text = objLeadGroupDetail.groupname
    
        txtPurpose.text = objLeadGroupDetail.purpose
        txtContactPerson.text = objLeadGroupDetail.contactPerson
        txtPhoneNo.text = objLeadGroupDetail.phone
        txtNote.text = objLeadGroupDetail.note
        
        lblDate.text = Utilities.dateFormatter(Date: objLeadGroupDetail.groupDate!, FromString: "yyyy-MM-dd", ToString:"MM-dd-yyyy")
        strLeadGroupDate = Utilities.dateFormatter(Date: lblDate.text!, FromString: "MM-dd-yyyy", ToString: "yyyy-MM-dd")
       
        self.initialStartDate = Utilities.StringToDateFormatter(DateString: strLeadGroupDate, FromString: "yyyy-MM-dd")
      
        if objLeadGroupDetail.groupType == "N"
        {
            btnVisibleTeamMember.isSelected = true
            isPrivate = "N"
        }
        else
        {
            btnVisibleOnlyMe.isSelected = true
            isPrivate = "Y"
        }
        
        isFirstTime = false
    }
    
    
    //MARK: Back Button Action...
    @IBAction func btnBackClick(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let back = storyboard.instantiateViewController(withIdentifier: "DashboardViewController") as! DashboardViewController
        let navigationVc = UINavigationController(rootViewController: back)
        present(navigationVc, animated: true, completion: nil)
    }
    
    //MARK: Button Date DropDown...
    @IBAction func btnDateDropDown(_ sender: Any) {
        view.endEditing(true)
        
        DatePickerPopover.appearFrom(originView: sender as! UIView, baseView: ContainerView, baseViewController: self, title: " Date", dateMode: .date, initialDate: self.initialStartDate, doneAction: { selectedDate in print("selectedDate \(selectedDate)")
            
            self.StartDate = selectedDate
            let startDate = Utilities.DateToStringFormatter(Date: self.StartDate, ToString: "MM-dd-yyyy")
            self.lblDate.text = startDate
            self.strStartDate = Utilities.dateFormatter(Date: startDate, FromString: "MM-dd-yyyy", ToString: "yyyy-MM-dd")
            self.initialStartDate = selectedDate
            
        }, cancelAction: {print("cancel")})
    }
    
    //MARK: BUtton Type RadioBUtton Action...
    @objc @IBAction fileprivate func btnEventsTypeSelected(_ radioButton: DLRadioButton) {
        
        if self.isPrivate == "Y"{
            btnVisibleTeamMember.isSelected = true
            btnVisibleOnlyMe.isSelected = false
            self.isPrivate = "N"
        }
        else{
            btnVisibleTeamMember.isSelected = false
            btnVisibleOnlyMe.isSelected = true
            self.isPrivate = "Y"
        }
        
//        if (radioButton.isMultipleSelectionEnabled) {
//            for button in radioButton.selectedButtons() {
//                print(String(format: "%@ is selected.\n", button.titleLabel!.text!));
//            }
//        } else {
//            print(String(format: "%@ is selected.\n", radioButton.selected()!.titleLabel!.text!));
//
//            if btnVisibleTeamMember.isSelected
//            {
//                isPrivate = "N"
//            }
//
//            if btnVisibleOnlyMe.isSelected
//            {
//                isPrivate = "Y"
//            }
//        }
    }
    
    //MARK: BUtton SAve Action...
    @IBAction func btnSaveClick(_ sender: Any) {
        view.endEditing(true)
        if  (txtGroupName.text?.isBlank)!
        {
            print("Please Enter Lead Group Name")
            let alert = UIAlertController(title: "", message: "Please Enter Lead Group Name",  preferredStyle: .alert)
            let attributedString = Utilities.alertAttribute(titleString: alertTitle)
            alert.setValue(attributedString, forKey: "attributedTitle")
            let OKAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            OKAction.setValue(alertbtnColor, forKey: "titleTextColor")
            
            alert.addAction(OKAction)
            present(alert,animated: true,completion: nil)
        }
        else if  (txtLeadsource.text?.isBlank)!
        {
            print("Please Enter Lead Source(Location) Name")
            let alert = UIAlertController(title: "", message: "Please Enter Lead Source (Location) Name",  preferredStyle: .alert)
            let attributedString = Utilities.alertAttribute(titleString: alertTitle)
            alert.setValue(attributedString, forKey: "attributedTitle")
            let OKAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            OKAction.setValue(alertbtnColor, forKey: "titleTextColor")
            
            alert.addAction(OKAction)
            present(alert,animated: true,completion: nil)
        }
        else if !(txtPhoneNo.text?.isValidPhoneNo())! && !(txtPhoneNo.text?.isBlank)!
        {
            print("Please Enter valid Phone No")
            let alert = UIAlertController(title: "", message: "Please Enter valid Phone No",  preferredStyle: .alert)
            let attributedString = Utilities.alertAttribute(titleString: alertTitle)
            alert.setValue(attributedString, forKey: "attributedTitle")
            let OKAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            OKAction.setValue(alertbtnColor, forKey: "titleTextColor")
            
            alert.addAction(OKAction)
            present(alert,animated: true,completion: nil)
        }
        else if ((txtPhoneNo.text?.characters.count)! < 6 || (txtPhoneNo.text?.characters.count)! > 20) && !(txtPhoneNo.text?.isBlank)!
        {
            print("Please Enter Phone No between 6 to 20 characters")
            
            let alert = UIAlertController(title: "", message: "Please Enter Phone No between 6 to 20 characters",  preferredStyle: .alert)
            let attributedString = Utilities.alertAttribute(titleString: alertTitle)
            alert.setValue(attributedString, forKey: "attributedTitle")
            let OKAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            OKAction.setValue(alertbtnColor, forKey: "titleTextColor")
            
            alert.addAction(OKAction)
            present(alert,animated: true,completion: nil)
        }
        else{
            let Phone = txtPhoneNo.text!
            let PhoneNo = Phone.replacingOccurrences(of: "+", with: "%2B", options: [], range: nil)
            
             let param:[String : String] = ["userId":objLoginUserDetail.userId!,
                                            "lead_group_name":txtGroupName.text!,
                                            "lead_group_date":strStartDate,
                                            "lead_source":txtLeadsource.text!,
                                            "purpose":txtPurpose.text!,
                                            "contactPerson":txtContactPerson.text!,
                                            "phone":txtPhoneNo.text!,
                                            "notes":txtNote.text!,
                                            "isPrivate":isPrivate,
                                            "createdTimeStamp":"\(Int(dateTimeStamp.timeIntervalSince1970))"]
            //Progress Bar Loding...
            let size = CGSize(width: 30, height: 30)
            self.startAnimating(size, message: "Loading...", type: NVActivityIndicatorType(rawValue: 29))
            
            webService.doRequestPost(Add_LeadGroup_API_URL, params: param as [String : AnyObject], key: "addLeadGroup", delegate: self)
        }
    }
    
    func webServiceResponceSuccess(_ response: Data, apiKey: String) {
        stopAnimating()
        if apiKey == Add_LeadGroup_API_URL
        {
            let json = JSON(data: response)
            let result = json["addLeadGroup"]
            
            if result["status"] == "YES"
            {
                let alert = UIAlertController(title: "", message: "Lead Group Added Successfully.",  preferredStyle: .alert)
                let attributedString = Utilities.alertAttribute(titleString: "Add Lead Group!")
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
                let alert = UIAlertController(title: "", message: "Lead Group Not Added.",  preferredStyle: .alert)
                let attributedString = Utilities.alertAttribute(titleString: "Add Lead Group!")
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
