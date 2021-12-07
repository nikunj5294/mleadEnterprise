//
//  ProfileViewController.swift
//  NewMleadsEnterprise
//
//  Created by Triforce New Mac on 16/08/19.
//  Copyright © 2019 com.Tri-Force.MLeadsEnterprise. All rights reserved.
//

import UIKit
import MDFTextAccessibility
import TextFieldEffects
import NVActivityIndicatorView
import DLRadioButton

@IBDesignable class ProfileViewController: UIViewController,NVActivityIndicatorViewable, UITextFieldDelegate {

    
    @IBOutlet weak var txtFirstName: HoshiTextField!
    @IBOutlet weak var txtLastName: HoshiTextField!
    @IBOutlet weak var txtEmailId: HoshiTextField!
    @IBOutlet weak var txtCompanyName: HoshiTextField!
    @IBOutlet weak var txtJobTitle: HoshiTextField!
    @IBOutlet weak var txtAddress: HoshiTextField!
    @IBOutlet weak var txtCity: HoshiTextField!
    @IBOutlet weak var txtState: HoshiTextField!
    @IBOutlet weak var txtCountry: HoshiTextField!
    @IBOutlet weak var txtZipCode: HoshiTextField!
    @IBOutlet weak var txtCompanyWebSite: HoshiTextField!
    @IBOutlet weak var txtPhoneNo: HoshiTextField!
    @IBOutlet weak var txtPhoneExtension: HoshiTextField!
    @IBOutlet weak var txtOtherPhone: HoshiTextField!
    @IBOutlet weak var txtMobileNo: HoshiTextField!
    
    @IBOutlet weak var btnPersonal: DLRadioButton!
    @IBOutlet weak var btnBusiness: DLRadioButton!
    @IBOutlet weak var btnEventOrgYes: DLRadioButton!
    @IBOutlet weak var btnEventOrgNo: DLRadioButton!
    @IBOutlet weak var btnOpnIn: DLRadioButton!
    
    @IBOutlet weak var lblHearFrom: UILabel!
    @IBOutlet weak var lblCurrencySupport: UILabel!
    @IBOutlet weak var lblIndustry: UILabel!
    @IBOutlet weak var lblLeadRetrivel: UILabel!
    
    @IBOutlet var ContainerView: UIView!
    
    let webService : WebService = WebService()
    var handleWebService : HandleWebService = HandleWebService()
    var appdelegate = AppDelegate()
    
    var userType = String()
    var eventOrganizer = String()
    //var eventOrganizer = Bool()
    var isOptInBtnPressed = Bool()
    var optIn = String()
    let updatedTimeStamp = Date()

    var arrHearFrom = [String]()
    var selectedIndexForHearFrom = Int()
    var selectedStringForHearFrom = String()
    
    var selectedIndexForIndustry = Int()
    var selectedIDForIndustry = String()
    
    var selectedIndexForCurrencySupport = Int()
    var selectedIDForCurrencySupport = String()
    var selectedSymbolForCurrency = String()
    var selectedHexaSymbolForCurrency = String()
    
    //var arrLeadRetrivel = [String]()
    var selectedIndexForLeadRetrivel = Int()
    var selectedStringForLeadRetrivel = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnOpnIn.isSelected = true
        optIn = "1"
        isOptInBtnPressed = false
        
        
        self.txtOtherPhone.delegate = self
        self.txtMobileNo.delegate = self
        self.navigationItem.title = "My Profile"
        self.findHamburguerViewController()?.gestureEnabled = false
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(self.btnSave(_:)))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.btnCancelClicked(_:)))
        
        txtEmailId.isUserInteractionEnabled = false
        txtFirstName.text = objLoginUserDetail.firstName
        txtLastName.text = objLoginUserDetail.lastName
        txtEmailId.text = objLoginUserDetail.email
        txtCompanyName.text = objLoginUserDetail.companyName
        txtJobTitle.text = objLoginUserDetail.jobTitle
        txtAddress.text = objLoginUserDetail.address
        txtCity.text = objLoginUserDetail.city
        txtState.text = objLoginUserDetail.state
        txtCountry.text = objLoginUserDetail.country
        //txtZipCode.text = objLoginUserDetail.zipCode
        txtZipCode.text = objLoginUserDetail.zipCode
        txtCompanyWebSite.text = objLoginUserDetail.companyWebsite
        txtPhoneNo.text = objLoginUserDetail.phone
        txtPhoneExtension.text = objLoginUserDetail.phoneExt
        txtOtherPhone.text = objLoginUserDetail.otherPhone
        txtMobileNo.text = objLoginUserDetail.mobile
        
        //Event Type:
        if objLoginUserDetail.userType == "Business"
        {
            btnBusiness.isSelected = true
            userType = "Business"
            //Business
        }
        else
        {
            btnPersonal.isSelected = true
            userType = "Personal"
            //Personal
        }
        
        //EVENT ORGANIZER
        if objLoginUserDetail.eventOrganizer == "1"
        {
            btnEventOrgYes.isSelected = true
            eventOrganizer = "1"
        }
        else
        {
            btnEventOrgNo.isSelected = true
            eventOrganizer = "0"
        }
        
        //MARK: HearForm About....
        arrHearFrom = ["Search Engine","Friend","Magazine","Newspaper","Other"]
        
        if objLoginUserDetail.hearAbout == ""
        {
            if arrHearFrom.contains("Search Engine")
            {
                selectedIndexForHearFrom = arrHearFrom.index(of: "Search Engine")!
                selectedStringForHearFrom = arrHearFrom[selectedIndexForHearFrom]
            }
        }
            
        else if arrHearFrom.contains(objLoginUserDetail.hearAbout!)
        {
            selectedIndexForHearFrom = arrHearFrom.index(of: objLoginUserDetail.hearAbout!)!
            selectedStringForHearFrom = arrHearFrom[selectedIndexForHearFrom]
        }
        lblHearFrom.text = arrHearFrom[selectedIndexForHearFrom]
        
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

        //MARK: Currency ...
        if objLoginUserDetail.currency_id == ""
        {
            if arrCurrencySupport.Currency.contains("United State")
            {
                selectedIndexForCurrencySupport = arrCurrencySupport.Currency.index(of: "United State")!
                selectedIDForCurrencySupport = arrCurrencySupport.CurrencyId[selectedIndexForCurrencySupport]
                //selectedSymbolForCurrency = arrCurrencySupport.Symbol[selectedIndexForCurrencySupport]
            }
        }
        else if arrCurrencySupport.CurrencyId.contains(objLoginUserDetail.currency_id!)
        {
            selectedIndexForCurrencySupport = arrCurrencySupport.CurrencyId.index(of: objLoginUserDetail.currency_id!)!
            selectedIDForCurrencySupport = arrCurrencySupport.CurrencyId[selectedIndexForCurrencySupport]
            //selectedSymbolForCurrency = arrCurrencySupport.Symbol[selectedSymbolForCurrency]
            //selectedSymbolForCurrency = arrCurrencySupport.Symbol[selectedIndexForCurrencySupport]
        }
        lblCurrencySupport.text = arrCurrencySupport.Currency[selectedIndexForCurrencySupport]
        
        //MARK: LEad Retrivel
//        //arrLeadRetrivel = ["None","Scan Business Card","Scan the Badge","Speak","Scan QR Code","Bump Lead","Quick Lead","Quick Note","Type Lead"]
        if objLoginUserDetail.leadRetrivalSetting == ""
        {
            if arrLeadRetrivel.LeadRetrivel.contains("none")
            {
                selectedIndexForLeadRetrivel = arrLeadRetrivel.LeadRetrivel.index(of: "None")!
                selectedStringForLeadRetrivel = arrLeadRetrivel.LeadRetrivelID[selectedIndexForLeadRetrivel]
            }
        }

//        else if arrLeadRetrivel.LeadRetrivelID.contains(objLoginUserDetail.leadRetrivalSetting!)
//        {
//            selectedIndexForLeadRetrivel = arrLeadRetrivel.LeadRetrivelID.index(of: objLoginUserDetail.leadRetrivalSetting!)!
//            selectedStringForLeadRetrivel = arrLeadRetrivel.LeadRetrivelID[selectedIndexForLeadRetrivel]
//        }
        lblLeadRetrivel.text = arrLeadRetrivel.LeadRetrivel[selectedIndexForLeadRetrivel]
        
    }
    
    // UItextfield Delegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        
        if textField == txtOtherPhone || textField == txtMobileNo{
            if textField.text?.count == 20{
                if range.hashValue == 0 {
                    return true
                }
                else{
                    return false
                }
            }
            else{
                return true
            }
        }
        else{
            return true
        }
    }
    
    //MARK:- BUtton Action Method...
    @objc @IBAction fileprivate func UserTypeSelectedButton(_ radioButton : DLRadioButton)
    {
        if (radioButton.isMultipleSelectionEnabled) {
            for button in radioButton.selectedButtons() {
                print(String(format: "%@ is selected.\n", button.titleLabel!.text!));
            }
        } else {
            if btnBusiness.isSelected
            {
                print(radioButton.selected()!.titleLabel!.text!)
                userType = "Business"
            }
            else
            {
                print(radioButton.selected()!.titleLabel!.text!)
                userType = "Personal"
            }
        }
    }
    
    @objc @IBAction fileprivate func UserEventOrganizerButton(_ radioButton : DLRadioButton)
    {
        if (radioButton.isMultipleSelectionEnabled) {
            for button in radioButton.selectedButtons() {
                print(String(format: "%@ is selected.\n", button.titleLabel!.text!));
            }
        } else {
            if btnEventOrgYes.isSelected
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
    @objc @IBAction fileprivate func optInSelectedButton(_ radioButton : DLRadioButton) {
        
        if isOptInBtnPressed
        {
            btnOpnIn.isSelected = true
            optIn = "1"
            isOptInBtnPressed = false
        }
        else
        {
            btnOpnIn.isSelected = false
            optIn = "0"
            isOptInBtnPressed = true
        }
        
    }
    
    @IBAction func btnCurrencySupportDropDown(_ sender: Any) {
        StringPickerPopOver.appearFrom(originView: sender as! UIView, baseView: ContainerView, baseViewController: self, title: "Select Currency", choices: arrCurrencySupport.Currency , initialRow:selectedIndexForCurrencySupport, doneAction: { selectedRow, selectedString in
            print("row \(selectedRow) : \(selectedString)")
            
            self.selectedIndexForCurrencySupport = selectedRow
            self.selectedIDForCurrencySupport = arrCurrencySupport.CurrencyId[self.selectedIndexForCurrencySupport]
            
            if arrCurrencySupport.Symbol.count > self.selectedIndexForCurrencySupport{
                self.selectedSymbolForCurrency = arrCurrencySupport.Symbol[self.selectedIndexForCurrencySupport]
            }
            else{
                self.selectedSymbolForCurrency = "USD"
            }
            
            self.lblCurrencySupport.text = selectedString
            print("For Currency Support = \(self.selectedIndexForCurrencySupport)")
            print("Select Currency id = \(self.selectedIDForCurrencySupport)")
            
        },cancelAction: { print("cancel")})
    }
    
    @IBAction func btnHearFormDropDown(_ sender: Any) {
        StringPickerPopOver.appearFrom(originView: sender as! UIView, baseView: ContainerView, baseViewController: self, title: "Select Hear From", choices: arrHearFrom , initialRow:selectedIndexForHearFrom, doneAction: { selectedRow, selectedString in
            print("row \(selectedRow) : \(selectedString)")
            
            self.selectedIndexForHearFrom = selectedRow
            self.selectedStringForHearFrom = selectedString
            self.lblHearFrom.text = selectedString
            print("For Hear From = \(self.selectedIndexForHearFrom)")
            print("Select Hear From = \(self.selectedStringForHearFrom)")
            
        },cancelAction: { print("cancel")})
    }
    
    @IBAction func btnIndustryDropDown(_ sender: Any) {
        StringPickerPopOver.appearFrom(originView: sender as! UIView, baseView: ContainerView, baseViewController: self, title: "Select Industry", choices: arrIndustryId.Industry , initialRow:selectedIndexForIndustry, doneAction: { selectedRow, selectedString in
            print("row \(selectedRow) : \(selectedString)")
            
            self.selectedIndexForIndustry = selectedRow
            self.selectedIDForIndustry = arrIndustryId.IndustryID[self.selectedIndexForIndustry]
            self.lblIndustry.text = selectedString
            print("For Industry = \(self.selectedIndexForIndustry)")
            print("Select Industry id = \(self.selectedIDForIndustry)")
            
        },cancelAction: { print("cancel")})
    }
    
    @IBAction func btnLeadRetrivelDropDown(_ sender: Any) {
        StringPickerPopOver.appearFrom(originView: sender as! UIView, baseView: ContainerView, baseViewController: self, title: "Select Lead Retrivel", choices: arrLeadRetrivel.LeadRetrivel , initialRow:selectedIndexForLeadRetrivel, doneAction: { selectedRow, selectedString in
            print("row \(selectedRow) : \(selectedString)")
            
            self.selectedIndexForLeadRetrivel = selectedRow
            self.selectedStringForLeadRetrivel = selectedString
            self.lblLeadRetrivel.text = selectedString
            print("Lead Retrivel = \(self.selectedIndexForLeadRetrivel)")
            print("Select Lead Retrivel Name = \(self.selectedStringForLeadRetrivel)")
            
        },cancelAction: { print("cancel")})
    }
    
    @IBAction func btnSave(_ sender: Any) {
        if (txtFirstName.text?.isBlank)!
        {
            print("Please Enter First Name")
            
            let alert = UIAlertController(title: "", message: "Please Enter First Name",  preferredStyle: .alert)
            let attributedString = Utilities.alertAttribute(titleString: "Edit Profile!")
            alert.setValue(attributedString, forKey: "attributedTitle")
            let okAct = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            okAct.setValue(alertbtnColor, forKey: "titleTextColor")
            
            alert.addAction(okAct)
            present(alert,animated: true,completion: nil)
        }
        else if (txtLastName.text?.isBlank)!
        {
            print("Please Enter Last Name")
            
            let alert = UIAlertController(title: "", message: "Please Enter Last Name",  preferredStyle: .alert)
            let attributedString = Utilities.alertAttribute(titleString: "Edit Profile!")
            alert.setValue(attributedString, forKey: "attributedTitle")
            let okAct = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            okAct.setValue(alertbtnColor, forKey: "titleTextColor")
            
            alert.addAction(okAct)
            present(alert,animated: true,completion: nil)
        }
        else if !((txtCompanyWebSite.text?.isBlank)!) && !((txtCompanyWebSite.text?.isValidateUrl)!) {
            print(txtCompanyWebSite.text?.isValidateUrl)
            print("Please Enter valid WebsiteUrl")
            
            let alert = UIAlertController(title: "", message: "Please Enter valid Website URL",  preferredStyle: .alert)
            let attributedString = Utilities.alertAttribute(titleString: "Edit Profile!")
            alert.setValue(attributedString, forKey: "attributedTitle")
            let okAct = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            okAct.setValue(alertbtnColor, forKey: "titleTextColor")
            
            alert.addAction(okAct)
            present(alert,animated: true,completion: nil)
        }
        else if !(txtPhoneNo.text?.isValidPhoneNo())! || (txtPhoneNo.text?.isBlank)!
        {
            print("Please Enter valid Phone No")
            
            let alert = UIAlertController(title: "", message: "Please Enter valid Phone No",  preferredStyle: .alert)
            let attributedString = Utilities.alertAttribute(titleString: "Edit Profile!")
            alert.setValue(attributedString, forKey: "attributedTitle")
            let okAct = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            okAct.setValue(alertbtnColor, forKey: "titleTextColor")
            
            alert.addAction(okAct)
            present(alert,animated: true,completion: nil)
        }
        else if (txtPhoneNo.text?.characters.count)! < 6 || (txtPhoneNo.text?.characters.count)! > 20
        {
            print("Please Enter Phone No between 6 to 20 characters")
            
            let alert = UIAlertController(title: "", message: "Please Enter Phone No between 6 to 20 characters",  preferredStyle: .alert)
            let attributedString = Utilities.alertAttribute(titleString: "Edit Profile!")
            alert.setValue(attributedString, forKey: "attributedTitle")
            let okAct = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            okAct.setValue(alertbtnColor, forKey: "titleTextColor")
            
            alert.addAction(okAct)
            present(alert,animated: true,completion: nil)
        }
        else{
            print("\(Int(updatedTimeStamp.timeIntervalSince1970))")
            
            let Phone = txtPhoneNo.text!
            let PhoneNo = Phone.replacingOccurrences(of: "+", with: "%2B", options: [], range: nil)
            
            let OtherPhone = txtOtherPhone.text!
            let OtherPhoneNo = OtherPhone.replacingOccurrences(of: "+", with: "%2B", options: [], range: nil)
            
            let Mobile = txtMobileNo.text!
            let MobileNo = Mobile.replacingOccurrences(of: "+", with: "%2B", options: [], range: nil)
            
            let param:[String : AnyObject] = [//"user_id" : objLoginUserDetail.createTimeStamp! as AnyObject,
                                              "user_id": objLoginUserDetail.createTimeStamp! as AnyObject,
                                              "createdTimeStamp":objLoginUserDetail.createTimeStamp as AnyObject,
                                              "first_name": txtFirstName.text as AnyObject,
                                              "last_name": txtLastName.text as AnyObject,
                                              "email": txtEmailId.text as AnyObject,
                                              "userType": userType as AnyObject,
                                              "companyName": txtCompanyName.text as AnyObject,
                                              "address": txtAddress.text as AnyObject,
                                              "city": txtCity.text as AnyObject,
                                              "state": txtState.text as AnyObject,
                                              "zipCode": txtZipCode.text as AnyObject,
                                              "country": txtCountry.text as AnyObject,
                                              "companyWebSite": txtCompanyWebSite.text as AnyObject,
                                              "phoneNumber": PhoneNo as AnyObject,
                                              "mobilePhone": MobileNo as AnyObject,
                                              "securityQuesId": "" as AnyObject,
                                              "securityAnswer": "" as AnyObject,
                                              "industryId": selectedIDForIndustry as AnyObject,
                                              "hearFrom": selectedStringForHearFrom as AnyObject,
                                              "updatedTimeStamp": "\(Int(updatedTimeStamp.timeIntervalSince1970))" as AnyObject,
                                              "event_organizer_type": eventOrganizer as AnyObject,
                                              "other_phone": txtOtherPhone.text as AnyObject,
                                              "phone_ext": txtPhoneExtension.text as AnyObject,
                                              "optIn": optIn as AnyObject,
                                              "default_lead_type": selectedIndexForLeadRetrivel as AnyObject,
                                              "jobtitle": txtJobTitle.text as AnyObject,
                                              "currency_id": selectedIDForCurrencySupport as AnyObject]
            
            //Progress Bar Loding...
            let size = CGSize(width: 30, height: 30)
            startAnimating(size, message: "Loading...", type: NVActivityIndicatorType(rawValue: 29))
            
            webService.doRequestPost(UPDATE_USER_API_URL, params: param, key: "updateUser", delegate: self)
        }
        
    }
    
    @IBAction func btnCancelClicked(_ sender: AnyObject)
    {
        _ = navigationController?.popViewController(animated: true)
    }
    
}

extension ProfileViewController : WebServiceDelegate{
    func webServiceResponceSuccess(_ response: Data, apiKey: String) {
        stopAnimating()
        
        if apiKey == UPDATE_USER_API_URL{
            let json = JSON(data: response)
            //let result = json["updateUser"]
            
            if json["updateUser"]["status"] == "YES"
            {
                print("USER UPDATE DATA")
                //Get User Detail
                let param:[String : AnyObject] = ["userId":objLoginUserDetail.createTimeStamp as AnyObject]
                webService.doRequestPost(GET_USER_DETAIL, params: param, key: "userDetail", delegate: self)
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
                
                let decodedUserDetail = USERDEFAULTS.object(forKey: LOGIN_USER_Detail) as! Data
                objLoginUserDetail = NSKeyedUnarchiver.unarchiveObject(with: decodedUserDetail) as! UserDetail!
                
                let alert = UIAlertController(title: "", message: "User Updated Successfully",  preferredStyle: .alert)
                let attributedString = Utilities.alertAttribute(titleString: "Update User")
                alert.setValue(attributedString, forKey: "attributedTitle")
                let okAct = UIAlertAction(title: "OK", style: .default, handler: {UIAlertAction in
                    let decodedUserDetail = USERDEFAULTS.object(forKey: LOGIN_USER_Detail) as! Data
                    objLoginUserDetail = NSKeyedUnarchiver.unarchiveObject(with: decodedUserDetail) as! UserDetail!
                    _ = self.navigationController?.popViewController(animated: true)
                })
                
                okAct.setValue(alertbtnColor, forKey: "titleTextColor")
                
                alert.addAction(okAct)
                present(alert,animated: true,completion: nil)
                
            }
        }
    }
    func webServiceResponceFailure(_ errorMessage: String) {
        stopAnimating()
    }
}
