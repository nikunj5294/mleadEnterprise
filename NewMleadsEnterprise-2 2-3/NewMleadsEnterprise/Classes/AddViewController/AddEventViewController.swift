//
//  AddEventViewController.swift
//  NewMleadsEnterprise
//
//  Created by Triforce New Mac on 29/06/19.
//  Copyright © 2019 com.Tri-Force.MLeadsEnterprise. All rights reserved.
//

import UIKit
import DLRadioButton
import TextFieldEffects
import NVActivityIndicatorView

class AddEventViewController: UIViewController,UITextFieldDelegate,NVActivityIndicatorViewable,WebServiceDelegate {
    
    
    @IBOutlet var txtEventsName: HoshiTextField!
    @IBOutlet var txtLocation: HoshiTextField!
    @IBOutlet var txtcity: HoshiTextField!
    @IBOutlet var txtState: HoshiTextField!
    @IBOutlet var Country: HoshiTextField!
    @IBOutlet var txtPhone: HoshiTextField!
    @IBOutlet var txtPurpose: HoshiTextField!
    @IBOutlet var txtContactPerson: HoshiTextField!
    
    @IBOutlet var btnStartDateOutlet: UIButton!
    @IBOutlet var btnEndDateOutlet: UIButton!
    @IBOutlet var lblStartDate: UILabel!
    @IBOutlet var lblEndDate: UILabel!
    
    @IBOutlet var btnVisibleTeamMember: DLRadioButton!
    @IBOutlet var btnVisibleOnlyMe: DLRadioButton!
    
    @IBOutlet var txtNote: UITextView!
    
    @IBOutlet var ContainerView: UIView!
    
    var eventID = String()
    
    var EvntStartDate = Date()
    var EvntEndDate = Date()
    var initialStartDate = Date()
    var initialEndDate = Date()
    var dateTimeStamp = Date()
    
    var strEvntStartDate = String()
    var strEventEndDate = String()
    
    var objEventDetail: EventDetail = EventDetail()
    var appdelegate = AppDelegate()
   
    let webService : WebService = WebService()
    var handleWebService : HandleWebService = HandleWebService()
    var alertbtnColor = Utilities.alertButtonColor()
    
    var isViewEvent = Bool()
    var isEditEvent = Bool()
    var isAddEvent = Bool()
    var alertTitle = String()
    var isPrivate = String()
    var isFirstTime = Bool()
    var isCountrySelected = Bool()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.findHamburguerViewController()?.gestureEnabled = false
    
        self.navigationItem.title = "ADD Event"
        
        if objEventDetail.event_has_attendee == "y"
        {
            btnStartDateOutlet.isUserInteractionEnabled = false
            btnEndDateOutlet.isUserInteractionEnabled = false
        }
        
        if isEditEvent
        {
            self.navigationItem.title = "Edit Event"
            //navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(self.btnSaveClickAction(_:)))

            alertTitle = "Edit Event!"

            EventDataField()
        }
        else
        {
            
    //        else if isAddEvent
    //        {
                btnVisibleTeamMember.isSelected = true
                isPrivate = "N"
            
                
                alertTitle = "Add Event!"
            
                let currentDate = Utilities.DateToStringFormatter(Date: Date(), ToString: "MM-dd-yyyy")
                lblStartDate.text = currentDate
                lblEndDate.text = currentDate
                
                strEvntStartDate = Utilities.dateFormatter(Date: lblStartDate.text!, FromString: "MM-dd-yyyy", ToString: "yyyy-MM-dd")
                strEventEndDate = Utilities.dateFormatter(Date: lblEndDate.text!, FromString: "MM-dd-yyyy", ToString: "yyyy-MM-dd")
                
                isFirstTime = true
            //}
            if isViewEvent
            {
                self.navigationItem.title = "View Event"
                txtEventsName.isUserInteractionEnabled = false
                txtLocation.isUserInteractionEnabled = false
                Country.isUserInteractionEnabled = false
                txtState.isUserInteractionEnabled = false
                txtcity.isUserInteractionEnabled = false
                
                txtPurpose.isUserInteractionEnabled = false
                txtContactPerson.isUserInteractionEnabled = false
                txtPhone.isUserInteractionEnabled = false
                txtNote.isUserInteractionEnabled = false
                
                btnStartDateOutlet.isUserInteractionEnabled = false
                btnEndDateOutlet.isUserInteractionEnabled = false
                btnVisibleTeamMember.isUserInteractionEnabled = false
                btnVisibleOnlyMe.isUserInteractionEnabled = false
                
                EventDataField()
            }
        }
    }
    
    //MARK:- Custom Function
    func EventDataField()
    {
        txtEventsName.text = objEventDetail.eventName
        txtLocation.text = objEventDetail.location
        txtcity.text = objEventDetail.city
        txtState.text = objEventDetail.state
        Country.text = objEventDetail.country
        
        txtPurpose.text = objEventDetail.purpose
        txtContactPerson.text = objEventDetail.contactPerson
        txtPhone.text = objEventDetail.phone
        txtNote.text = objEventDetail.notes
        
        if objEventDetail.eventDate != nil{
            lblStartDate.text = Utilities.dateFormatter(Date: objEventDetail.eventDate!, FromString: "yyyy-MM-dd", ToString:"MM-dd-yyyy")
        }
        
        if objEventDetail.eventEndDate != nil{
            lblEndDate.text = Utilities.dateFormatter(Date: objEventDetail.eventEndDate!, FromString: "yyyy-MM-dd", ToString:"MM-dd-yyyy")
        }
    
        
        strEvntStartDate = Utilities.dateFormatter(Date: lblStartDate.text!, FromString: "MM-dd-yyyy", ToString: "yyyy-MM-dd")
        strEventEndDate = Utilities.dateFormatter(Date: lblEndDate.text!, FromString: "MM-dd-yyyy", ToString: "yyyy-MM-dd")
        
        self.initialStartDate = Utilities.StringToDateFormatter(DateString: strEvntStartDate, FromString: "yyyy-MM-dd")
        self.initialEndDate = Utilities.StringToDateFormatter(DateString: strEventEndDate, FromString: "yyyy-MM-dd")
        
        if objEventDetail.isPrivate == "N"
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
    
    @IBAction func btnBackClickAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let back = storyboard.instantiateViewController(withIdentifier: "DashboardViewController") as! DashboardViewController
        let navigationVc = UINavigationController(rootViewController: back)
        present(navigationVc, animated: true, completion: nil)
    }
    
    //MARK: Button Start And End Date DropDown
    @IBAction func btnStartDateDropDown(_ sender: Any) {
        view.endEditing(true)

        DatePickerPopover.appearFrom(originView: sender as! UIView, baseView: ContainerView, baseViewController: self, title: "Event Start Date", dateMode: .date, initialDate: self.initialStartDate, doneAction: { selectedDate in print("selectedDate \(selectedDate)")
//        DatePickerPopover.appearFrom(originView: sender as! UIView, baseView: ContainerView, baseViewController: self, title: "Event Start Date", dateMode: .date, initialDate: self.initialStartDate, doneAction: { selectedDate in print("selectedDate \(selectedDate)")
        
            
            self.EvntStartDate = selectedDate
            let startDate = Utilities.DateToStringFormatter(Date: self.EvntStartDate, ToString: "MM-dd-yyyy")
            self.lblStartDate.text = startDate
            self.strEvntStartDate = Utilities.dateFormatter(Date: startDate, FromString: "MM-dd-yyyy", ToString: "yyyy-MM-dd")
            self.initialStartDate = selectedDate
            
        }, cancelAction: {print("cancel")})
    }
    
    @IBAction func btnEndDateDropDown(_ sender: Any) {
        view.endEditing(true)
        
        DatePickerPopover.appearFrom(originView: sender as! UIView, baseView: ContainerView, baseViewController: self, title: "Event End Date", dateMode: .date, initialDate: self.initialEndDate, doneAction: { selectedDate in print("selectedDate \(selectedDate)")
            
            self.EvntEndDate = selectedDate
            let endDate = Utilities.DateToStringFormatter(Date: self.EvntEndDate, ToString: "MM-dd-yyyy")
            self.lblEndDate.text = endDate
            self.strEventEndDate = Utilities.dateFormatter(Date: endDate, FromString: "MM-dd-yyyy", ToString: "yyyy-MM-dd")
            self.initialEndDate = selectedDate
            
        }, cancelAction: {print("cancel")})
    }
    
    //MARK: BUtton Type RadioBUtton Action...
   @objc @IBAction fileprivate func btnEventsTypeSelected(_ radioButton: DLRadioButton) {
        if (radioButton.isMultipleSelectionEnabled) {
            for button in radioButton.selectedButtons() {
                print(String(format: "%@ is selected.\n", button.titleLabel!.text!));
            }
        } else {
            print(String(format: "%@ is selected.\n", radioButton.selected()!.titleLabel!.text!));
            
            if btnVisibleTeamMember.isSelected
            {
                isPrivate = "N"
            }
            
            if btnVisibleOnlyMe.isSelected
            {
                isPrivate = "Y"
            }
        }
    }
    
    
    //MARK: Save Button Action...
    @IBAction func btnSaveClickAction(_ sender: AnyObject) {
        view.endEditing(true)
        
        if  (txtEventsName.text?.isBlank)!
        {
            print("Please Enter Event Name")
            let alert = UIAlertController(title: "", message: "Please Enter Event Name",  preferredStyle: .alert)
            let attributedString = Utilities.alertAttribute(titleString: alertTitle)
            alert.setValue(attributedString, forKey: "attributedTitle")
            let OKAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            OKAction.setValue(alertbtnColor, forKey: "titleTextColor")
            
            alert.addAction(OKAction)
            present(alert,animated: true,completion: nil)
            //
            //            let alert = UIAlertView(title: alertTitle, message: "Please Enter Event Name" , delegate: self, cancelButtonTitle: "OK")
            //            alert.show()
        }
        else if  (txtLocation.text?.isBlank)!
        {
            print("Please Enter Location Name")
            let alert = UIAlertController(title: "", message: "Please Enter Location Name",  preferredStyle: .alert)
            let attributedString = Utilities.alertAttribute(titleString: alertTitle)
            alert.setValue(attributedString, forKey: "attributedTitle")
            let OKAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            OKAction.setValue(alertbtnColor, forKey: "titleTextColor")
            
            alert.addAction(OKAction)
            present(alert,animated: true,completion: nil)
            //            let alert = UIAlertView(title: alertTitle, message: "Please Enter Location Name" , delegate: self, cancelButtonTitle: "OK")
            //            alert.show()
        }
        else if initialEndDate.isLessThanDate(dateToCompare: initialStartDate)
        {
            print("date not valid")
            let alert = UIAlertController(title: "", message: "End Date should be greater than or equal to Start Date",  preferredStyle: .alert)
            let attributedString = Utilities.alertAttribute(titleString: alertTitle)
            alert.setValue(attributedString, forKey: "attributedTitle")
            let OKAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            OKAction.setValue(alertbtnColor, forKey: "titleTextColor")
            
            alert.addAction(OKAction)
            present(alert,animated: true,completion: nil)
            
            //            let alert = UIAlertView(title: alertTitle, message: "End Date should be greater than or equal to Start Date" , delegate: self, cancelButtonTitle: "OK")
            //            alert.show()
        }
        else if !(txtPhone.text?.isValidPhoneNo())! && !(txtPhone.text?.isBlank)!
        {
            print("Please Enter valid Phone No")
            let alert = UIAlertController(title: "", message: "Please Enter valid Phone No",  preferredStyle: .alert)
            let attributedString = Utilities.alertAttribute(titleString: alertTitle)
            alert.setValue(attributedString, forKey: "attributedTitle")
            let OKAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            OKAction.setValue(alertbtnColor, forKey: "titleTextColor")
            
            alert.addAction(OKAction)
            present(alert,animated: true,completion: nil)
            //            let alert = UIAlertView(title: alertTitle, message: "Please Enter valid Phone No" , delegate: self, cancelButtonTitle: "OK")
            //            alert.show()
        }
        else if ((txtPhone.text?.characters.count)! < 6 || (txtPhone.text?.characters.count)! > 20) && !(txtPhone.text?.isBlank)!
        {
            print("Please Enter Phone No between 6 to 20 characters")
            
            let alert = UIAlertController(title: "", message: "Please Enter Phone No between 6 to 20 characters",  preferredStyle: .alert)
            let attributedString = Utilities.alertAttribute(titleString: alertTitle)
            alert.setValue(attributedString, forKey: "attributedTitle")
            let OKAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            OKAction.setValue(alertbtnColor, forKey: "titleTextColor")
            
            alert.addAction(OKAction)
            present(alert,animated: true,completion: nil)
            
            //            let alert = UIAlertView(title: alertTitle, message: "Please Enter Phone No between 6 to 20 characters" , delegate: self, cancelButtonTitle: "OK")
            //            alert.show()
        }
        else
        {
            if isEditEvent
            {

                let param = ["eventId":objEventDetail.eventid!,
                             "eventName":txtEventsName.text!,
                             "location":txtLocation.text!,
                             "city":txtcity.text!,
                             "state":txtState.text!,
                             "country":Country.text!,
                             "eventDate":strEvntStartDate,
                             "eventEndDate":strEventEndDate,
                             "purpose":txtPurpose.text!,
                             "contactPerson":txtContactPerson.text!,
                             "phone":txtPhone.text!,
                             "notes":txtNote.text!,
                             "updatedTimeStamp":"\(Int(Date().timeIntervalSince1970))",
                             "isPrivate":isPrivate,
                             "phone_ext":"",
                             "other_phone":""
                    ] as [String : Any]
//
//
                let size = CGSize(width: 30, height: 30)
                self.startAnimating(size, message: "Loading...", type: NVActivityIndicatorType(rawValue: 29))

                webService.doRequestPost(EDIT_EVENT_API_KEY, params: param as [String : AnyObject], key: "updateEvent", delegate: self)
            }
            else
            {
                let Phone = txtPhone.text!
                let PhoneNo = Phone.replacingOccurrences(of: "+", with: "%2B", options: [], range: nil)
                
                let param:[String : String] = ["userId":objLoginUserDetail.userId!,
                                               "eventName":txtEventsName.text!,
                                               "location":txtLocation.text!,
                                               "city":txtcity.text!,
                                               "state":txtState.text!,
                                               "country":Country.text!,
                                               "eventDate":strEvntStartDate,
                                               "eventEndDate":strEventEndDate,
                                               "purpose":txtPurpose.text!,
                                               "contactPerson":txtContactPerson.text!,
                                               "phone":txtPhone.text!,
                                               "notes":txtNote.text,
                                               "createdTimeStamp":"\(Int(dateTimeStamp.timeIntervalSince1970))",
                                               "updatedTimeStamp":"0",
                                               "phone_ext":"",
                                               "other_phone":"",
                                               "isPrivate":isPrivate] //as? [String : AnyObject]
                
                //Progress Bar Loding...
                let size = CGSize(width: 30, height: 30)
                self.startAnimating(size, message: "Loading...", type: NVActivityIndicatorType(rawValue: 29))
                
                webService.doRequestPost(ADD_EVENT_API_URL, params: param as [String : AnyObject], key: "addEvent", delegate: self)
            }
//
            
                
         
        }
    }
    
    // UPDATE AND EDIT EVENTS ON UNDER PROGRESS SO WORKING THEN
    
    //MARK:Webservice CAlling Function..
    func webServiceResponceSuccess(_ response: Data, apiKey: String) {
        stopAnimating()
        
        
        if apiKey == EDIT_EVENT_API_KEY
        {
            let json = JSON(data: response)
            let result = json["updateEvent"]
            
            if result["status"] == "YES"
            {
                let alert = UIAlertController(title: "", message: "Event Updated Successfully.",  preferredStyle: .alert)
                let attributedString = Utilities.alertAttribute(titleString: "Update Event!")
                alert.setValue(attributedString, forKey: "attributedTitle")
                let OKAction = UIAlertAction(title: "OK", style: .default, handler: { UIAlertAction in
                    for controller in self.navigationController!.viewControllers
                    {
                        if controller.isKind(of: EventViewController.self)
                        {
                            _ = self.navigationController?.popToViewController(controller, animated: true)
                        }
                    }
                    
                })
                OKAction.setValue(alertbtnColor, forKey: "titleTextColor")
                
                alert.addAction(OKAction)
                present(alert,animated: true,completion: nil)
                //                let alert = UIAlertView(title: "Update Event!", message: "Event Updated Successfully.", delegate: self, cancelButtonTitle: "Ok")
                //                alert.tag = 101
                //                alert.show()
            }
            else
            {
                let alert = UIAlertController(title: "", message: "Event Not Updated.",  preferredStyle: .alert)
                let attributedString = Utilities.alertAttribute(titleString: "Update Event!")
                alert.setValue(attributedString, forKey: "attributedTitle")
                let OKAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                OKAction.setValue(alertbtnColor, forKey: "titleTextColor")
                
                alert.addAction(OKAction)
                present(alert,animated: true,completion: nil)
                
                //                let alert = UIAlertView(title: "Update Event!", message: "Event Not Updated.", delegate: self, cancelButtonTitle: "Ok")
                //                alert.show()
            }
        }
        else if apiKey == ADD_EVENT_API_URL
        {
            let json = JSON(data: response)
            let result = json["addEvent"]
            
            if result["status"] == "YES"
            {
                let alert = UIAlertController(title: "", message: "Event Added Successfully.",  preferredStyle: .alert)
                let attributedString = Utilities.alertAttribute(titleString: "Add Event!")
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
                let alert = UIAlertController(title: "", message: "Event Not Added.",  preferredStyle: .alert)
                let attributedString = Utilities.alertAttribute(titleString: "Add Event!")
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
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
