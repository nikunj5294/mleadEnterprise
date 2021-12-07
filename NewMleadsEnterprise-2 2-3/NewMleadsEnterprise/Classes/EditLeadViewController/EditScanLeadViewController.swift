//
//  EditScanLeadViewController.swift
//  NewMleadsEnterprise
//
//  Created by MAC on 15/11/21.
//  Copyright © 2021 com.Tri-Force.MLeadsEnterprise. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Alamofire
import Foundation

class EditScanLeadViewController: UIViewController, NVActivityIndicatorViewable {
    
    @IBOutlet var btnUserSelectedImage: UIButton!
    @IBOutlet var btnClickeImage: UIButton!
    
    var imageSelectedBussiness: UIImage?
    var imagePicker = UIImagePickerController()

    @IBOutlet weak var btnLeadStatusObj: UIButton!
    @IBOutlet weak var lblLeadStatusObj: UILabel!
    var selectedLeadStatus = 0
    
    @IBOutlet weak var lblFollowUpActions: UILabel!
    
    @IBOutlet weak var btnTakeActionByObj: UIButton!
    @IBOutlet weak var lblTakeActionbyObj: UILabel!
    var selectedTakeActionDate = Date()
    var isTypeLead = false
    
    //MARK:- TextField Validations
    let VALID_FIRST_LAST_NAME = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
    let VALID_NAMES = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz "
    
    let PHONE_NUMBERS = "^\\s*([0123456789-()+/. ]*)\\s*$"
    let PHONE_NUMBER_EXTENSION = "^\\s*([0123456789-() ]*)\\s*$"
    
    
    @IBOutlet weak var lblEventName: UILabel!
    @IBOutlet weak var btnEventList: UIButton!
    
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtJobTitle: UITextField!
    @IBOutlet weak var txtCompanyName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtOtherEmail: UITextField!
    @IBOutlet weak var txtPhoneNumber: UITextField!
    @IBOutlet weak var txtPhoneExtention: UITextField!
    @IBOutlet weak var txtOtherPhone: UITextField!
    
    var voiceMemoData = NSData()
    var imageData = NSData()
    
    let webService : WebService = WebService()
    var handleWebService : HandleWebService = HandleWebService()
    var appdelegate = AppDelegate()
    
    var arrTeamName = [String]()
    var arrTeamCreatedTiemStemp = [String]()
    var arrTempReportsTo = NSMutableArray()
    var arrEventList = NSMutableArray()
    var arrEventName = [String]()
    
    var selectedIndexForEventIndex = Int()
    
    var surveyQuestionsIndex = [Int]()

    //MARK: Add Lead Data...
    var strStreet = ""
    var strCity = ""
    var strState = ""
    var strCountry = ""
    var strZipcode = ""
    
    var strNotes = ""
    
    var strSalesName = ""
    var strTarget = ""
    var strPeriods = ""
    var strTargetfuture = ""
    var strClosingDate = ""
    var strClosingPercentage = ""
    var strRPFDate = ""
    var strStatus = ""
    
    var strLevelInterest = 1
    var strBusinessPotential = 1
    var strtimeFrame = 1
    var strFollowUp = 1
    var strEmailCatelog = 1
    var strEmailLiterature = 1
    var strEmailQuote = 1
    var strSalesCall = 1
    var strScheduleDemo = 1
    var strProvidesSamples = 1
    var strImmediateNeed = 1
    var strPurchasingSamples = 1
    var strHasFinalSay = 1
    var strRecommanded = 1
    
    var strFollowUpActionsId = ""
    var strLeadType = "5"
    
    var strName = ""
    var strEmail = ""
    var strPhone = ""
    var objLeadList = LeadList()
    
    //MARK: ViewController Life Cycle...

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Add Lead"
        
        
        
        if imageSelectedBussiness != nil{
            btnUserSelectedImage.setImage(imageSelectedBussiness, for: .normal)
            //image/jpeg
            imageData = imageSelectedBussiness!.jpegData(compressionQuality: 0.7)! as NSData
        }
        
        if strLeadType == "1"{
            txtFirstName.text = strName
            txtEmail.text = strEmail
            txtPhoneNumber.text = strPhone
        }
        
        if strLeadType == "4"{
            
        }
        
        for _ in 0...13{
            surveyQuestionsIndex.append(1)
        }
        
        callWebService()
        setupScanData()
        setupEditData()
        // Do any additional setup after loading the view.
    }
    
    func setupEditData() {
        
        txtFirstName.text = objLeadList.firstName ?? ""
        txtLastName.text = objLeadList.lastName ?? ""
        txtEmail.text = objLeadList.email ?? ""
        txtCompanyName.text = objLeadList.company ?? ""
        txtJobTitle.text = objLeadList.jobTitle ?? ""
        txtOtherEmail.text = objLeadList.otherEmail ?? ""
        
        txtPhoneNumber.text = objLeadList.phone ?? ""
        txtOtherPhone.text = objLeadList.otherPhone ?? ""
        txtPhoneExtention.text = objLeadList.phoneExt ?? ""
        
        let leadStatus = ["Other", "Cold", "Contacted", "Contact in future", "Hot", "Not Contacted", "Qualified", "Warm", "Converted to Customer", "Current Customer", "Target Lead"]
        
        lblLeadStatusObj.text = leadStatus[Int(objLeadList.leadStatus ?? "0")!]
        lblFollowUpActions.text = objLeadList.followup_action_list
        self.selectedLeadStatus = Int(objLeadList.leadStatus ?? "")!
        strCity = objLeadList.city ?? ""
        strState = objLeadList.state ?? ""
        strStreet = objLeadList.Street ?? ""
        strCountry = objLeadList.country ?? ""
        
//        let startDate = Utilities.DateToStringFormatter(Date: objLeadList.endDate.dat, ToString: "MM/dd/yyyy")
        self.lblTakeActionbyObj.text = objLeadList.endDate
        
    }
    
    func setupScanData()  {
        
//        let clientObj = Client(applicationID: MyApplicationID, password: MyPassword)
//        clientObj?.delegate = self
//        let processingObj = ProcessingParams()
//        processingObj.apiType = "processBusinessCard"
//        clientObj?.processImage(imageSelectedBussiness, with: processingObj, withAPIName: "processBusinessCard")
        
//        let swiftOCRInstance = SwiftOCR()
//        swiftOCRInstance.recognize(imageSelectedBussiness) { recognizedString in
//            print(recognizedString)
//        }
        
    }
    
    
    @IBAction func btnClickedImagePicker(_ sender: UIButton) {
        funcOpenImagePicker()
    }
    
    func funcOpenImagePicker(){
        
        let alert = UIAlertController(title: "Mleads", message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Take Picture", style: .default, handler: { _ in
                self.openCamera()
            }))

            alert.addAction(UIAlertAction(title: "Select Picture", style: .default, handler: { _ in
                self.openGallary()
            }))

            alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        
    }
    
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

    func openGallary()
    {
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func btnClickedEventList(_ sender: UIButton) {
        
        self.view.endEditing(true)
        
        StringPickerPopOver.appearFrom(originView: sender as UIView, baseView: self.btnEventList, baseViewController: self, title: "Select Member", choices: arrEventName , initialRow:selectedIndexForEventIndex, doneAction: { selectedRow, selectedString in
            print("row \(selectedRow) : \(selectedString)")
            self.selectedIndexForEventIndex = selectedRow
            self.lblEventName.text = selectedString
            
            //self.callWebServiceForEventLeadList(TypeId: self.typeID)
            
            }, cancelAction:{print("cancel")})
        
        
    }
    
    @IBAction func btnVoiceMemoClicked(_ sender: Any) {
        
        self.view.endEditing(true)
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "VoiceMemoViewController") as! VoiceMemoViewController
        vc.delegateVoiceMemo = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func btnOptionsClicked(_ sender: UIButton) {
        
        switch sender.tag {
        case 1:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddNotesViewController") as! AddNotesViewController
            vc.strNotes = strNotes
            vc.delegateNotesData = self
            navigationController?.pushViewController(vc, animated: true)
        case 2:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddAddressViewController") as! AddAddressViewController
            vc.strStreet = strStreet
            vc.strCity = strCity
            vc.strState = strState
            vc.strCountry = strCountry
            vc.strZipcode = strZipcode
            vc.delegateAddressData = self
            navigationController?.pushViewController(vc, animated: true)
        case 3:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SalesOpportunityViewController") as! SalesOpportunityViewController
            vc.delegateSalesOpportunity = self
            vc.strSalesName = strSalesName
            vc.strTarget = strTarget
            vc.strPeriods = strPeriods
            vc.strTargetfuture = strTargetfuture
            vc.strClosingDate = strClosingDate
            vc.strClosingPercentage = strClosingPercentage
            vc.strRPFDate = strRPFDate
            vc.strStatus = strStatus
            navigationController?.pushViewController(vc, animated: true)
        case 5:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SurveyQuestionnaireViewController") as! SurveyQuestionnaireViewController
            vc.delegateSurveyQuestion = self
            vc.strLevelInterest = strLevelInterest
            vc.strBusinessPotential = strBusinessPotential
            vc.strtimeFrame = strtimeFrame
            vc.strFollowUp = strFollowUp
            vc.strEmailCatelog = strEmailCatelog
            vc.strEmailLiterature = strEmailLiterature
            vc.strEmailQuote = strEmailQuote
            vc.strSalesCall = strSalesCall
            vc.strScheduleDemo = strScheduleDemo
            vc.strProvidesSamples = strProvidesSamples
            vc.strImmediateNeed = strImmediateNeed
            vc.strPurchasingSamples = strPurchasingSamples
            vc.strHasFinalSay = strHasFinalSay
            vc.strRecommanded = strRecommanded
            navigationController?.pushViewController(vc, animated: true)
        default:
            print("")
        }
        
    }
    
    @IBAction func btnSaveClicked(_ sender: Any) {
        /*
        var isValid = true
        
        if txtFirstName.text!.isEmpty{
            displayAlert(strMessage: "Enter First Name")
            isValid = false
        }else if txtLastName.text!.isEmpty{
            displayAlert(strMessage: "Enter Last Name")
            isValid = false
        }else if txtJobTitle.text!.isEmpty{
            displayAlert(strMessage: "Enter Job Title")
            isValid = false
        }else if txtCompanyName.text!.isEmpty{
            displayAlert(strMessage: "Enter Company Name")
            isValid = false
        }else if txtEmail.text!.isEmpty{
            displayAlert(strMessage: "Enter Email")
            isValid = false
        }else if !(txtEmail.text?.isValidEmail())!{
            displayAlert(strMessage: "Enter Valid Email")
            isValid = false
        }else if txtOtherEmail.text!.isEmpty{
            displayAlert(strMessage: "Enter Email Other")
            isValid = false
        }else if txtPhoneNumber.text!.isEmpty{
            displayAlert(strMessage: "Enter Phone Number")
            isValid = false
        }else if txtPhoneNumber.text!.isEmpty{
            displayAlert(strMessage: "Enter Phone Number")
            isValid = false
        }else if lblLeadStatusObj.text!.isEmpty{
            displayAlert(strMessage: "Select Lead Status")
            isValid = false
        }else if lblFollowUpActions.text!.isEmpty{
            displayAlert(strMessage: "Select Follow Up Actions")
            isValid = false
        }else if lblTakeActionbyObj.text!.isEmpty{
            displayAlert(strMessage: "Select Take Action By")
            isValid = false
        }
        
        if isValid{*/
//            AddLeadAPIData()
//            addLEadAPICall()
            callADDLeadWebService()
//        }
        
    }
    
    func displayAlert(strMessage:String) {
        ShowAlert(title: "Mleads", message: strMessage, buttonTitle: "Ok") {
            
        }
    }
    
    @IBAction func btnFollowUpActionsClicked(_ sender: Any) {
        
        self.view.endEditing(true)
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "FollowupActionsViewController") as! FollowupActionsViewController
        vc.delegatePassFollowUpAction = self
        vc.strSelectedActions = lblFollowUpActions.text ?? ""
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
    }
    
    
    @IBAction func btnLeadStatusClicked(_ sender: Any) {
        
        self.view.endEditing(true)
        
        StringPickerPopOver.appearFrom(originView: sender as! UIView, baseView: btnLeadStatusObj , baseViewController: self, title: "Select Status", choices: ["Other", "Cold", "Contacted", "Contact in future", "Hot", "Not Contacted", "Qualified", "Warm", "Converted to Customer", "Current Customer", "Target Lead"] , initialRow:selectedLeadStatus, doneAction: { selectedRow, selectedString in
            print("row \(selectedRow) : \(selectedString)")
            self.lblLeadStatusObj.text = selectedString
            self.selectedLeadStatus = selectedRow
            },cancelAction: { print("cancel")})
        
    }
    
    @IBAction func btnTakenActionByClicked(_ sender: Any) {
        
        self.view.endEditing(true)
        
        DatePickerPopover.sharedInstance.selectedDate = selectedTakeActionDate
        DatePickerPopover.appearFrom(originView: sender as! UIView, baseView: btnTakeActionByObj, baseViewController: self, title: "Take Action By", dateMode: .date, initialDate: selectedTakeActionDate, doneAction: { selectedDate in print("selectedDate \(selectedDate)")

            self.selectedTakeActionDate = selectedDate
            let startDate = Utilities.DateToStringFormatter(Date: self.selectedTakeActionDate, ToString: "MM/dd/yyyy")
            self.lblTakeActionbyObj.text = startDate
//            self.selectedTakeActionDate = Utilities.dateFormatter(Date: startDate, FromString: "MM-dd-yyyy", ToString: "yyyy-MM-dd")
            
        }, cancelAction: {print("cancel")})
        
    }
    
    //MARK: Webservices Custom Function Call Method...
    
    
    //MARK: Webservices Custom Function Call Method...
    func callWebService()
    {
        let param = ["userId": objLoginUserDetail.userId! as AnyObject,
                                          "selectedId": "",
        "typeId": ""] as [String : AnyObject]
        
        //Progress Bar Loding...
        let size = CGSize(width: 30, height: 30)
        startAnimating(size, message: "Loading...", type: NVActivityIndicatorType(rawValue: 29))
        
        webService.doRequestPost(GET_EVENTLIST_ENTERPISE_URL, params: param, key: "eventList", delegate: self)
    }
    
    
    
    func callADDLeadWebService()
    {
     
        let size = CGSize(width: 30, height: 30)
        startAnimating(size, message: "Loading...", type: NVActivityIndicatorType(rawValue: 29))
        
        let eventDataObj = arrEventList[0] as! [EventDetail]
        let eventDetailsObj = eventDataObj[selectedIndexForEventIndex]
        
        let strStatusData = ["Qualified","Quote submitted","Closed","Cancelled","Lose","Won"]
        var statusID = ""
        
        for i in 0...strStatusData.count-1{
            if strStatusData[i] == strStatus{
                statusID = "\(i)"
                break
            }
        }
        
        let header = ["Content-Type" : "multipart/form-data; boundary=0xKhTmLbOuNdArY---This_Is_ThE_BoUnDaRyy---pqo"]
        
        let stringsurveyQuestionsArray = surveyQuestionsIndex.map { String($0) }
        
//        let date = Date()
//        let format = DateFormatter()
//        format.dateFormat = "MM/dd/yyyy"
//        let timestamp = format.string(from: date)
        let timestamp = Date.currentTimeStamp
        
        let parametersData = [
            "eventId": objLeadList.eventId!,
                "createdTimeStamp": "\(timestamp)",
//                "leadId": "", //- nil
                "updatedTimeStamp": "0",
//                "attachmentIds": "",
                "addedLeadType": objLeadList.addedLeadType ?? "0",  //- 5
                 "endDt": lblTakeActionbyObj.text ?? "",  //- 06/23/2021 - (Take Action By)
                "userId": objLoginUserDetail.userId! as AnyObject, //-
                "firstName": txtFirstName.text ?? "",
                "product": "", //- “”
                "process": "0", //- 0
                "followUpActionList": strFollowUpActionsId, //- 1,2,3,0 - All selected
                "lastName": txtLastName.text ?? "",
                "street": strStreet, //-
                "survey_answers": "",
//                    stringsurveyQuestionsArray.joined(separator: ","), //- 1,2,1,2,1,1,1,2,-1,2,1,2,2,1
                "city": strCity , //-
                "state": strState,
                "country": strCountry,
                "zip": strZipcode, //- “”
                "company": txtCompanyName.text ?? "", //-
                "email": txtEmail.text ?? "",
                "other_email": txtOtherEmail.text ?? "",
                "job_title": txtJobTitle.text ?? "",
                "opportunity_name": strSalesName,
                "periods": strPeriods, //- Annually
                "targerAmount": strTarget, //-
                "targetFutureAmount": strTargetfuture,
                "tagetCloseDate": strClosingDate, //- 05/22/2021
                "status_id": statusID, //-  @"Qualified",@"Quote submitted",@"Closed",@"Cancelled",@"Lose",@"Won" - 1,2,3,4 - any one
                "probabilityClosePer": strClosingPercentage, //- 50%
                "nextStepDate": strRPFDate, //- 05/22/2021
                    "phone": txtPhoneNumber.text ?? "",
                "other_phone": txtOtherPhone.text ?? "",
                "phone_ext": txtPhoneExtention.text ?? "",
                "lead_status": "\(self.selectedLeadStatus)", //- 0,1,2,3,4… - any one
                "notes": strNotes, //- Testing Notes
                "fileCreatedTimeStamp": "\(timestamp)",
                ] as [String : Any] //- VoiceMemo
        
        print(parametersData)
        
        Alamofire.upload(
                multipartFormData: { MultipartFormData in
                //    multipartFormData.append(imageData, withName: "user", fileName: "user.jpg", mimeType: "image/jpeg")

                    for (key, value) in parametersData {
                        MultipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                    }
                    
//                    if self.imageData.count > 0{
                        MultipartFormData.append(self.imageData as Data, withName: "imageUrl", fileName: "user.jpg", mimeType: "image/jpeg")
//                    }else{
//                        MultipartFormData.append(("" as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: "imageUrl")
//                    }
//                    if self.voiceMemoData.count > 0{
                        MultipartFormData.append(self.voiceMemoData as Data, withName: "recordSoundUrl", fileName: "demo.wav", mimeType: "audio/wav")
//                    }else{
//                        MultipartFormData.append(("" as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: "recordSoundUrl")
//
//                    }
                    
//                MultipartFormData.append(self.dataAudioObj, withName: "recordSoundUrl", fileName: "demo.wav", mimeType: "audio/wav")


            }, to: WEBSERVICE_URL+EDIT_LEAD_API_URL, headers: header) { (result) in

                switch result {
                case .success(let upload, _, _):

                    self.stopAnimating()
                    
                    upload.responseJSON { response in
                        
                        if let JSON = response.result.value {
                            if let addleadData = (JSON as AnyObject).value(forKey: "addLead") as? [String:Any]{
                                if let statusData = addleadData["status"] as? String{
                                    
                                    if statusData == "YES"{
                                        ShowAlert(title: "Mleads", message: "Lead Successfully Created", buttonTitle: "Ok") {
                                            for case let vc as AddLeadViewController in self.navigationController?.viewControllers ?? [UIViewController()] {
                                                NotificationCenter.default.post(name: Notification.Name("callRefreshAPI"), object: nil, userInfo: nil)

                                                self.navigationController?.popToViewController(vc, animated: true)
                                            }
                                        }
                                    }else{
                                        ShowAlert(title: "Mleads", message: "Something Went Wrong, Please try again.", buttonTitle: "Ok") {
//                                            self.navigationController?.popViewController(animated: true)
                                        }
                                    }
                                }
                            }
                        }
                        print(response.result.value ?? "")
                    }

                case .failure(let encodingError): break
                    print(encodingError)
                }


            }
   
    }
    
    
    func addLEadAPICall()  {
        
        /*
        let parameters = [
            "eventId": "1623406434",
            "createdTimeStamp": "1623409000",
            "updatedTimeStamp": "0",
            "addedLeadType": "5",
            "endDt": "11/13/2021",
            "userId": "1623302187",
            "firstName": "Test",
            "product": "",
            "process": "0",
            "followUpActionList":"2,3",
            "lastName": "Mlead",
            "street":"",
            "survey_answers":"",
            "city":"",
            "state":"",
            "country":"",
            "zip":"",
            "company":"Nikunj Mlead",
            "email":"testing@gmail.com",
            "other_email": "testing@gmail.com",
            "job_title": "LEadTest",
            "opportunity_name": "",
            "periods": "",
            "targerAmount": "",
            "targetFutureAmount": "",
            "tagetCloseDate": "",
            "status_id": "",
            "probabilityClosePer": "",
            "nextStepDate": "",
            "phone": "23423423",
            "other_phone": "23423423",
            "phone_ext": "23423423",
            "lead_status": "0",
            "notes": "My Test",
            "fileCreatedTimeStamp": "1623409000"
        ]*/
        
        let size = CGSize(width: 30, height: 30)
        startAnimating(size, message: "Loading...", type: NVActivityIndicatorType(rawValue: 29))
        
        let eventDataObj = arrEventList[0] as! [EventDetail]
        let eventDetailsObj = eventDataObj[selectedIndexForEventIndex]
        
        let strStatusData = ["Qualified","Quote submitted","Closed","Cancelled","Lose","Won"]
        var statusID = ""
        
        for i in 0...strStatusData.count-1{
            if strStatusData[i] == strStatus{
                statusID = "\(i)"
                break
            }
        }
        
        let header = ["Content-Type" : "multipart/form-data; boundary=0xKhTmLbOuNdArY---This_Is_ThE_BoUnDaRyy---pqo"]
        
        let stringsurveyQuestionsArray = surveyQuestionsIndex.map { String($0) }
        let timestamp = Date.currentTimeStamp
        
        /*
        let parameters = [
            "eventId": eventDetailsObj.eventid!,
            "createdTimeStamp": "\(timeStamp)",
            "updatedTimeStamp": "0",
            "addedLeadType": "5",
            "endDt": lblTakeActionbyObj.text ?? "",
            "userId": objLoginUserDetail.userId!,
            "firstName": txtFirstName.text ?? "",
            "product": "",
            "process": "0",
            "followUpActionList":"2,3",
            "lastName": txtLastName.text ?? "",
            "street":"",
            "survey_answers":"",
            "city":strCity,
            "state":strState,
            "country":strCountry,
            "zip":strZipcode,
            "company":txtCompanyName.text ?? "",
            "email":txtEmail.text ?? "",
            "other_email": txtOtherEmail.text ?? "",
            "job_title": "LEadTest",
            "opportunity_name": strSalesName,
            "periods": strPeriods,
            "targerAmount": strTarget,
            "targetFutureAmount": strTargetfuture,
            "tagetCloseDate": strClosingDate,
            "status_id": "",
            "probabilityClosePer": "",
            "nextStepDate": "",
            "phone": "23423423",
            "other_phone": "23423423",
            "phone_ext": "23423423",
            "lead_status": "0",
            "notes": "My Test",
            "fileCreatedTimeStamp": "\(timeStamp)"
        ] as [String : Any]*/
        /*
         let parametersData = [
                 "eventId": eventDetailsObj.eventid!,
                 "createdTimeStamp": "\(timeStamp)",
 //                "leadId": "", //- nil
                 "updatedTimeStamp": "0",
 //                "attachmentIds": "",
                 "addedLeadType": "5",  //- 5
                  "endDt": lblTakeActionbyObj.text ?? "",  //- 06/23/2021 - (Take Action By)
                 "userId": objLoginUserDetail.userId! as AnyObject, //-
                 "firstName": txtFirstName.text ?? "",
                 "product": "", //- “”
                 "process": "0", //- 0
                 "followUpActionList": strFollowUpActionsId, //- 1,2,3,0 - All selected
                 "lastName": txtLastName.text ?? "",
                 "street": strStreet, //-
                 "survey_answers": "",
 //                    stringsurveyQuestionsArray.joined(separator: ","), //- 1,2,1,2,1,1,1,2,-1,2,1,2,2,1
                 "city": strCity , //-
                 "state": strState,
                 "country": strCountry,
                 "zip": strZipcode, //- “”
                 "company": txtCompanyName.text ?? "", //-
                 "email": txtEmail.text ?? "",
                 "other_email": txtOtherEmail.text ?? "",
                 "job_title": txtJobTitle.text ?? "",
                 "opportunity_name": strSalesName,
                 "periods": strPeriods, //- Annually
                 "targerAmount": strTarget, //-
                 "targetFutureAmount": strTargetfuture,
                 "tagetCloseDate": strClosingDate, //- 05/22/2021
                 "status_id": statusID, //-  @"Qualified",@"Quote submitted",@"Closed",@"Cancelled",@"Lose",@"Won" - 1,2,3,4 - any one
                 "probabilityClosePer": strClosingPercentage, //- 50%
                 "nextStepDate": strRPFDate, //- 05/22/2021
                     "phone": txtPhoneNumber.text ?? "",
                 "other_phone": txtOtherPhone.text ?? "",
                 "phone_ext": txtPhoneExtention.text ?? "",
                 "lead_status": "\(self.selectedLeadStatus)", //- 0,1,2,3,4… - any one
                 "notes": strNotes, //- Testing Notes
                 "fileCreatedTimeStamp": "\(timeStamp)",
                 ]
         */
        
        let parameters = [
            "eventId": "1623249195",
            "createdTimeStamp": "\(timestamp)",
            "updatedTimeStamp": "0",
            "addedLeadType": "5",
            "endDt": "11/13/2021",
            "userId": "1623237966", //-
            "firstName": "Test wer ",
            "product": "",
            "process": "0",
            "followUpActionList":"2,3",
            "lastName": "Mlead werwe",
            "street":"",
            "survey_answers":"",
            "city":"",
            "state":"",
            "country":"",
            "zip":"",
            "company":"Nikunj Mlead",
            "email":"testing111867@gmail.com",
            "other_email": "testi876ng1111@gmail.com",
            "job_title": "LEadTest",
            "opportunity_name": "",
            "periods": "",
            "targerAmount": "",
            "targetFutureAmount": "",
            "tagetCloseDate": "",
            "status_id": "",
            "probabilityClosePer": "",
            "nextStepDate": "",
            "phone": "23423423",
            "other_phone": "23423423",
            "phone_ext": "23423423",
            "lead_status": "0",
            "notes": "My Test",
            "fileCreatedTimeStamp": "\(timestamp)"
        ] as [String:Any]
        
        print(parameters)
        
        Alamofire.upload(
            multipartFormData: { MultipartFormData in
                
                for (key, value) in parameters {
                    MultipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                }
                
                MultipartFormData.append(self.imageData as Data, withName: "imageUrl", fileName: "userData.jpeg", mimeType: "image/jpeg")
                
                MultipartFormData.append(self.voiceMemoData as Data, withName: "recordSoundUrl", fileName: "click.wav", mimeType: "audio/wav")
                
            }, to: WEBSERVICE_URL+ADD_LEAD_POST_URL) { (result) in
            
            switch result {
            case .success(let upload, _, _):
                
                self.stopAnimating()
                
                upload.responseJSON { response in
                    
                    if let JSON = response.result.value {
                        if let addleadData = (JSON as AnyObject).value(forKey: "addLead") as? [String:Any]{
                            if let statusData = addleadData["status"] as? String{
                                
                                if statusData == "YES"{
                                    ShowAlert(title: "Mleads", message: "Lead Successfully Created", buttonTitle: "Ok") {
                                        self.navigationController?.popViewController(animated: true)
                                    }
                                }else{
                                    ShowAlert(title: "Mleads", message: "Something Went Wrong, Please try again.", buttonTitle: "Ok") {
                                        //                                            self.navigationController?.popViewController(animated: true)
                                    }
                                }
                            }
                        }
                    }
                    print(response.result.value)
                }
            case .failure(let encodingError): break
                print(encodingError)
            }
            
            
        }
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a 1little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension EditScanLeadViewController : UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtFirstName || textField == txtLastName {
            let cs = NSCharacterSet(charactersIn: VALID_FIRST_LAST_NAME).inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")
            return string == filtered
        } else if textField == txtPhoneNumber || textField == txtOtherPhone {
            let cs = NSCharacterSet(charactersIn: PHONE_NUMBERS).inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")
            return string == filtered
        }else if textField == txtPhoneExtention {
            let cs = NSCharacterSet(charactersIn: PHONE_NUMBER_EXTENSION).inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")
            return string == filtered
        }else{
            return true
        }
    }
}

extension EditScanLeadViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var selectedImageView = UIImage()
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
                print("done")
            selectedImageView = pickedImage
        }else if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            selectedImageView = pickedImage
        }
        
        imageData = selectedImageView.jpegData(compressionQuality: 0.7)! as NSData
        btnUserSelectedImage.setImage(selectedImageView, for: .normal)
        imagePicker.dismiss(animated: true, completion: nil)
    }
}

extension EditScanLeadViewController : passFollowUpActionsDelegate{
    
    func passFollowUpActions(str: String, strIDs:String) {
        lblFollowUpActions.text = str
        strFollowUpActionsId = strIDs
    }
}

extension EditScanLeadViewController : WebServiceDelegate{
    
    func webServiceResponceSuccess(_ response: Data, apiKey: String) {
        stopAnimating()
        
        if apiKey == GET_EVENTLIST_ENTERPISE_URL
        {
            let result = handleWebService.handleGetEventList(response)
            print(result.Status)
            print(result.arrEventL)
            //MARK: EVent And Group ....
            if arrEventList.count >= 1
            {
                arrEventList.removeAllObjects()
            }
            if result.Status{
                if result.arrEventL.count > 0{
                    for i in 0..<result.arrEventL.count{
                        let eventDetailObj =  result.arrEventL[i] as! EventDetail
                        arrEventName.append(eventDetailObj.eventName ?? "")
                    }
                    arrEventList.addObjects(from: [result.arrEventL])
                    lblEventName.text = arrEventName[selectedIndexForEventIndex]
                    
                    if result.arrEventL.count == 0{
                        ShowAlert(title: "Mleads", message: "Please create Event first", buttonTitle: "Ok") {
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                    
                }
            }
            
            print(arrEventList)
            
            //arrEventList = result.arrEventL
            
            
        }
        
    }
    
    
    func webServiceResponceFailure(_ errorMessage: String) {
       self.stopAnimating()
        
        let alert = UIAlertController(title: "", message: errorMessage,  preferredStyle: .alert)
        let attributedString = Utilities.alertAttribute(titleString: "")
        alert.setValue(attributedString, forKey: "attributedTitle")
        let okAct = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        okAct.setValue(alertbtnColor, forKey: "titleTextColor")
        
        alert.addAction(okAct)
        present(alert,animated: true,completion: nil)
    }
}


extension EditScanLeadViewController : passLeadAddressDelegate{
    func passAddress(strStreet: String, strCity: String, strState: String, strCountry: String, strZipcode: String) {
        self.strStreet = strStreet
        self.strCity = strCity
        self.strState = strState
        self.strCountry = strCountry
        self.strZipcode = strZipcode
        objLeadList.city = strCity
        objLeadList.state = strState
        objLeadList.Street = strStreet
        objLeadList.country = strCountry
    }
}

extension EditScanLeadViewController : passLeadNotesDelegate{
    func passNotes(strNotesData: String) {
        self.strNotes = strNotesData
        objLeadList.notes = strNotes
    }
}

extension EditScanLeadViewController : passLeadSalesOpportunityDelegate{
    func passSalesOpportunity(strSalesName: String, strTarget: String, strPeriods: String, strTargetFuture: String, strTargetClosingDate: String, strProbabilityClosing: String, strRPFDate: String, strStrStatus: String) {
            
        self.strSalesName = strSalesName
        self.strTarget = strTarget
        self.strPeriods = strPeriods
        self.strTargetfuture = strTargetFuture
        self.strClosingDate = strTargetClosingDate
        self.strClosingPercentage = strProbabilityClosing
        self.strRPFDate = strRPFDate
        self.strStatus = strStrStatus
        
    }
}

extension EditScanLeadViewController : passLeadSurveyQuestionsDelegate {
    func passSurveyQuestions(stackLevelInterest: Int, stackBusinessPotential: Int, stacktimeFrame: Int, stackFollowUp: Int, stackEmailCatelog: Int, stackEmailLiterature: Int, stackEmailQuote: Int, stackSalesCall: Int, stackScheduleDemo: Int, stackProvidesSamples: Int, stackImmediateNeed: Int, stackPurchasingSamples: Int, stackHasFinalSay: Int, stackRecommanded: Int) {
        surveyQuestionsIndex.removeAll()
        self.strLevelInterest = stackLevelInterest
        self.strBusinessPotential = stackBusinessPotential
        self.strtimeFrame = stacktimeFrame
        self.strFollowUp = stackFollowUp
        self.strEmailCatelog = stackEmailCatelog
        self.strEmailLiterature = stackEmailLiterature
        self.strEmailQuote = stackEmailQuote
        self.strSalesCall = stackSalesCall
        self.strScheduleDemo = stackScheduleDemo
        self.strProvidesSamples = stackProvidesSamples
        self.strImmediateNeed = stackImmediateNeed
        self.strPurchasingSamples = stackPurchasingSamples
        self.strHasFinalSay = stackHasFinalSay
        self.strRecommanded = stackRecommanded
        surveyQuestionsIndex.append(stackLevelInterest)
        surveyQuestionsIndex.append(stackBusinessPotential)
        surveyQuestionsIndex.append(stacktimeFrame)
        surveyQuestionsIndex.append(stackFollowUp)
        surveyQuestionsIndex.append(stackEmailCatelog)
        surveyQuestionsIndex.append(stackEmailLiterature)
        surveyQuestionsIndex.append(stackEmailQuote)
        surveyQuestionsIndex.append(stackSalesCall)
        surveyQuestionsIndex.append(stackScheduleDemo)
        surveyQuestionsIndex.append(stackProvidesSamples)
        surveyQuestionsIndex.append(stackImmediateNeed)
        surveyQuestionsIndex.append(stackPurchasingSamples)
        surveyQuestionsIndex.append(stackHasFinalSay)
        surveyQuestionsIndex.append(stackRecommanded)
        
    }
}

extension EditScanLeadViewController : passLeadVoiceMemoDelegate{
    func passVoiceMemo(data: Data) {
        voiceMemoData = data as NSData
    }
}
