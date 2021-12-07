//
//  MyLeadDetailVC.swift
//  NewMleadsEnterprise
//
//  Created by Chetansinh on 18/02/21.
//  Copyright © 2021 com.Tri-Force.MLeadsEnterprise. All rights reserved.
//

import UIKit
import MessageUI
import NVActivityIndicatorView
import CoreLocation
import Contacts

protocol deleteDelegate {
    func refreshLeadList()
}

class MyLeadDetailVC: UIViewController, NVActivityIndicatorViewable {

    var objLeadList = LeadList()
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblCompany: UILabel!
    @IBOutlet weak var lblJOB: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblExt: UILabel!
    @IBOutlet weak var lblLeadStatus: UILabel!
    @IBOutlet weak var imgLeadImage: UIImageView!
    @IBOutlet weak var btnVoiceMemo: UIButton!
    
    @IBOutlet weak var viewLeadAction: UIView!
    @IBOutlet weak var viewLeadReserch: UIView!
    
    let webService : WebService = WebService()
    var handleWebService : HandleWebService = HandleWebService()
    var appdelegate = AppDelegate()
    
    var delegateRefresh: deleteDelegate?
    
    var store: CNContactStore!
    var isAPIRequired = false

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "View Lead"
        
        if isAPIRequired{
            
            let param:[String : AnyObject] = ["user_id":objLoginUserDetail.userId! as AnyObject,
                                              "leadId":objLeadList.leadId as AnyObject]
            
            //Progress Bar Loding...
            let size = CGSize(width: 30, height: 30)
            startAnimating(size, message: "Loading...", type: NVActivityIndicatorType(rawValue: 29))
            
            webService.doRequestPost(GET_LEAD_BY_ID_API_URL, params: param, key: "leadDetail", delegate: self)
            
        }else{
            setupData()
        }
        self.viewLeadReserch.isHidden = true
        
        
        let edit = UIBarButtonItem(image:UIImage(named: "edit_lead"), style: .plain, target: self, action: #selector(self.btnEditEventClick(_:)))
        let delete = UIBarButtonItem(image:UIImage(named: "delete_lead"), style: .plain, target: self, action: #selector(self.btnDeleteClick(_:)))
        
        navigationItem.rightBarButtonItems = [ edit , delete ]
        
        store = CNContactStore()
       
    }
    
    func setupData() {
        self.lblName.text = "\(objLeadList.firstName ?? "")" + " " + "\(objLeadList.lastName ?? "")"
        self.lblCompany.text = "\(objLeadList.company ?? "")"
        self.lblJOB.text = "\(objLeadList.jobTitle ?? "")"
        self.lblEmail.text = "\(objLeadList.email ?? "")"
        self.lblPhone.text = "\(objLeadList.phone ?? "")"
        self.lblExt.text = "\(objLeadList.phoneExt ?? "")"
        self.lblLeadStatus.text = "\(objLeadList.status ?? "")"
        
        if let url = URL(string: "\(objLeadList.leadStatusURL ?? "")") {
            self.imgLeadImage.sd_setImage(with: url, placeholderImage: UIImage(named: "ic_img_user"), options: .continueInBackground)
//            self.imgLeadImage.kf.setImage(with: url)
        }
    }
    
    private func checkContactsAccess() {
        switch CNContactStore.authorizationStatus(for: .contacts) {
                // Update our UI if the user has granted access to their Contacts
        
            
        case .authorized:
                self.accessGrantedForContacts()

                // Prompt the user for access to Contacts if there is no definitive answer
        case .notDetermined :
                self.requestContactsAccess()

                // Display a message if the user has denied or restricted access to Contacts
        case .denied,
             .restricted:
                let alert = UIAlertController(title: "Privacy Warning!",
                    message: "Permission was not granted for Contacts.",
                    preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            }
        }

        private func requestContactsAccess() {

            store.requestAccess(for: .contacts) {granted, error in
                if granted {
                        self.accessGrantedForContacts()
                        return
                   // }
                }
            }
        }
    
    func saveContact(){
            do{
                let contact = CNMutableContact()
                contact.givenName = lblName.text!
            contact.phoneNumbers = [CNLabeledValue(
                label:CNLabelPhoneNumberiPhone,
                                        value:CNPhoneNumber(stringValue:"\(String(describing: lblPhone.text!))")),
                      CNLabeledValue(
                    label:CNLabelPhoneNumberiPhone,
                        value:CNPhoneNumber(stringValue:"\(String(describing: lblPhone.text!))"))]

        
            let saveRequest = CNSaveRequest()
            saveRequest.add(contact, toContainerWithIdentifier:nil)
                do {
                    try store.execute(saveRequest)
                    let alert = UIAlertController(title: "", message: "Lead added Successfully To Contacts",  preferredStyle: .alert)
                    let attributedString = Utilities.alertAttribute(titleString: "Success")
                    alert.setValue(attributedString, forKey: "attributedTitle")
                    let OKAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    OKAction.setValue(alertbtnColor, forKey: "titleTextColor")
                    
                    alert.addAction(OKAction)
                    present(alert,animated: true,completion: nil)
                } catch {
                    
                    print("error")
                }
            
        }
    }

        // This method is called when the user has granted access to their address book data.
        private func accessGrantedForContacts() {
            //Update UI for grated state.
            //...
            saveContact()
        }
    
    //MARK:- Filter Button..
    @IBAction func btnEditEventClick(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(identifier: "EditScanLeadViewController") as! EditScanLeadViewController
        vc.objLeadList = objLeadList
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK:- Search Button Action
    @IBAction func btnDeleteClick(_ sender: Any) {
        
        let alertController = UIAlertController(title: "MLeads", message: "All follow-ups in this lead will be deleted along with tasks and meetings; Are you sure you want to delete the lead?", preferredStyle: .alert)
        
        let alertaction1 = UIAlertAction(title: "Yes", style: .default) { (action) in
            let param:[String : AnyObject] = ["leadId": self.objLeadList.leadId as AnyObject]
//            self.objLeadList.createTimeStamp 
            //Progress Bar Loding...
            let size = CGSize(width: 30, height: 30)
            self.startAnimating(size, message: "Loading...", type: NVActivityIndicatorType(rawValue: 29))
            
            self.webService.doRequestPost(DELETE_LEAD_API_URL, params: param, key: "deleteLead", delegate: self)
        }
        
        let alertaction2 = UIAlertAction(title: "No", style: .cancel) { (action) in
        }
        
        alertController.addAction(alertaction1)
        alertController.addAction(alertaction2)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func btnLeadAction(_ sender: Any) {
        self.viewLeadAction.isHidden = false
        self.viewLeadReserch.isHidden = true
    }
    
    @IBAction func btnLeadReserch(_ sender: Any) {
        self.viewLeadAction.isHidden = true
        self.viewLeadReserch.isHidden = false
    }
    
    @IBAction func btnEmailPressed(_ sender:UIButton) {
        let vc = StoryBoard.MyLead.instantiateViewController(withIdentifier: "MyLeadEmailPopupVC") as! MyLeadEmailPopupVC
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func btnCalllPressed(_ sender:UIButton) {
        
        let objAlertActionSheet = UIAlertController(title: "Select Number", message: "", preferredStyle: .actionSheet)
        
        let action1 = UIAlertAction(title: objLeadList.phone ?? "", style: .default) { action in
            self.dialNumber(number: "\(self.objLeadList.phone ?? "")")
        }
        
        let action2 = UIAlertAction(title: objLeadList.otherPhone ?? "", style: .default) { action in
            self.dialNumber(number: "\(self.objLeadList.otherPhone ?? "")")
        }
        
        let action3 = UIAlertAction(title: "Cancel", style: .cancel) { action in
            objAlertActionSheet.dismiss(animated: true, completion: nil)
        }
        
        objAlertActionSheet.addAction(action1)
        objAlertActionSheet.addAction(action2)
        objAlertActionSheet.addAction(action3)
        self.present(objAlertActionSheet, animated: true, completion: nil)
        
        
    }
    func dialNumber(number : String) {

     if let url = URL(string: "tel://\(number)"),
       UIApplication.shared.canOpenURL(url) {
          if #available(iOS 10, *) {
            UIApplication.shared.open(url, options: [:], completionHandler:nil)
           } else {
               UIApplication.shared.openURL(url)
           }
       } else {
                // add error message here
       }
    }
    @IBAction func btnMessagePressed(_ sender:UIButton) {
        
        let objAlertActionSheet = UIAlertController(title: "Select Number", message: "", preferredStyle: .actionSheet)
        
        let action1 = UIAlertAction(title: objLeadList.phone ?? "", style: .default) { action in
            self.sendSMS(mobileNumber: self.objLeadList.phone ?? "")
        }
        
        let action2 = UIAlertAction(title: objLeadList.otherPhone ?? "", style: .default) { action in
            self.sendSMS(mobileNumber: self.objLeadList.otherPhone ?? "")
        }
        
        let action3 = UIAlertAction(title: "Cancel", style: .cancel) { action in
            objAlertActionSheet.dismiss(animated: true, completion: nil)
        }
        
        objAlertActionSheet.addAction(action1)
        objAlertActionSheet.addAction(action2)
        objAlertActionSheet.addAction(action3)
        self.present(objAlertActionSheet, animated: true, completion: nil)
        
        
        
//        if let number = objLeadList.phone {
//            if (MFMessageComposeViewController.canSendText()) {
//                let controller = MFMessageComposeViewController()
//                controller.body = "Text Body"
//                controller.recipients = [number]
//                controller.messageComposeDelegate = self
//                self.present(controller, animated: true, completion: nil)
//            }
//        }
        
    }
    
    @IBAction func btnCreateTaskPressed(_ sender:UIButton) {
        
        let vcCreateList = StoryBoard.MyLead.instantiateViewController(withIdentifier: "CreateTaskListing") as! CreateTaskListing
        vcCreateList.objLeadList = objLeadList
        self.navigationController?.pushViewController(vcCreateList, animated: true)
    }
    @IBAction func btnSetUpMeetingPressed(_ sender:UIButton) {
        // SetupMeetingList
        
        let vcCreateList = StoryBoard.MyLead.instantiateViewController(withIdentifier: "SetupMeetingList") as! SetupMeetingList
        vcCreateList.objLeadList = objLeadList
        self.navigationController?.pushViewController(vcCreateList, animated: true)
    }
    
    @IBAction func btnPhoneContact(_ sender:UIButton) {
        
//        let store = CNContactStore()
//        let contact = CNMutableContact()
//        contact.familyName = "Tester"
//        contact.givenName = "Bad"
//        contact.nam
//        // Address
//        let address = CNMutablePostalAddress()
//        address.street = "Your Street"
//        address.city = "Your City"
//        address.state = "Your State"
//        address.postalCode = "Your ZIP/Postal Code"
//        address.country = "Your Country"
//        let home = CNLabeledValue<CNPostalAddress>(label:CNLabelHome, value:address)
//        contact.postalAddresses = [home]
//        // Save
//        let saveRequest = CNSaveRequest()
//        saveRequest.add(contact, toContainerWithIdentifier: nil)
//        try? store.execute(saveRequest)
        
        checkContactsAccess()
        
    }
    
    @IBAction func btnManualFollowUPPressed(_ sender:UIButton) {
        // ManualFollow_Up
        
        let vcCreateList = StoryBoard.MyLead.instantiateViewController(withIdentifier: "ManualFollow_Up") as! ManualFollow_Up
        self.navigationController?.pushViewController(vcCreateList, animated: true)
    }
    
    @IBAction func btnStopDripEmailPressed(_ sender:UIButton) {
        
    }
    @IBAction func btnExpenseTrackingPressed(_ sender:UIButton) {
        // ExpenseTrackingVC
        let vcCreateList = StoryBoard.MyLead.instantiateViewController(withIdentifier: "ExpenseTrackingVC") as! ExpenseTrackingVC
        self.navigationController?.pushViewController(vcCreateList, animated: true)
    }
    
    @IBAction func btnLeadFollowUpPressed(_ sender:UIButton) {
        
        let vcCreateList = StoryBoard.MyLead.instantiateViewController(withIdentifier: "LeadFolllowUpsViewController") as! LeadFolllowUpsViewController
        vcCreateList.objLeadList = objLeadList
        self.navigationController?.pushViewController(vcCreateList, animated: true)
        
    }
    @IBAction func btnSalesOpportunityPressed(_ sender:UIButton) {
        
        let vcCreateList = StoryBoard.MyLead.instantiateViewController(withIdentifier: "SalesOpportunityListViewController") as! SalesOpportunityListViewController
        vcCreateList.objLeadList = objLeadList
        self.navigationController?.pushViewController(vcCreateList, animated: true)
        
    }
    @IBAction func btnUpdateContactInfoPressed(_ sender:UIButton) {
        
        let vcCreateList = StoryBoard.MyLead.instantiateViewController(withIdentifier: "ExpenseTrackingVC") as! ExpenseTrackingVC
        self.navigationController?.pushViewController(vcCreateList, animated: true)
        
    }
    
    
    @IBAction func btnGoogleSearchClicked(_ sender: Any) {
        
        let urlString = "\(self.lblName.text ?? "") \(self.lblCompany.text ?? "")".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        guard let url = URL(string: "https://www.google.de/search?q=\(urlString!)") else { return }
        UIApplication.shared.open(url)
    }
    
    @IBAction func btnWebsiteclicked(_ sender: Any) {
        
        let domain = objLeadList.email?.components(separatedBy: "@")
        if domain?.count == 1 || domain?.count == 0{
            return
        }
        guard let url = URL(string: "https://\(domain![1])") else { return }
        UIApplication.shared.open(url)
    }
    
    
    @IBAction func btnSearchProfileClicked(_ sender: Any) {
        
        if (objLeadList.lastName ?? "").count > 0{
            guard let url = URL(string: "http://www.linkedin.com/pub/dir/?first=\(objLeadList.firstName ?? "")&last=\(objLeadList.lastName ?? "")&search=Go)") else { return }
            UIApplication.shared.open(url)
        }else{
            let alert = UIAlertController(title: "", message: "Please enter last name for show your profile",  preferredStyle: .alert)
            let attributedString = Utilities.alertAttribute(titleString: "")
            alert.setValue(attributedString, forKey: "attributedTitle")
            let okAct = UIAlertAction(title: "Ok", style: .default) { handler in
            }
            okAct.setValue(alertbtnColor, forKey: "titleTextColor")
            alert.addAction(okAct)
            present(alert,animated: true,completion: nil)
        }
        
        
    }
    
    @IBAction func btnMapSearchclicked(_ sender: Any) {
    
        
        if (objLeadList.city ?? "").count == 0{
            let alert = UIAlertController(title: "", message: "Please enter the address for lead to show on the map",  preferredStyle: .alert)
            let attributedString = Utilities.alertAttribute(titleString: "")
            alert.setValue(attributedString, forKey: "attributedTitle")
            let okAct = UIAlertAction(title: "Ok", style: .default) { handler in
            }
            okAct.setValue(alertbtnColor, forKey: "titleTextColor")
            alert.addAction(okAct)
            present(alert,animated: true,completion: nil)
        }else{
            let myAddress =
            "\(objLeadList.Street ?? ""),\(objLeadList.city ?? ""),\(objLeadList.state ?? ""),\(objLeadList.country ?? ""),\(objLeadList.zipCode ?? "")"
            let geoCoder = CLGeocoder()
            geoCoder.geocodeAddressString(myAddress) { (placemarks, error) in
                guard let placemarks = placemarks?.first else { return }
                let location = placemarks.location?.coordinate ?? CLLocationCoordinate2D()
                guard let url = URL(string:"http://maps.apple.com/?daddr=\(location.latitude),\(location.longitude)") else { return }
                UIApplication.shared.open(url)
            }
        }
    }
    
    
    @IBAction func btnFacebookConnectClicked(_ sender: Any) {
        let urlString = "\(self.lblName.text ?? "") \(self.lblCompany.text ?? "")".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        guard let url = URL(string: "https://www.facebook.com/search.php?q=\(urlString!)") else { return }
        UIApplication.shared.open(url)
    }
    
    @IBAction func btnTwitterConnectClicked(_ sender: Any) {
        let urlString = "\(self.lblName.text ?? "") \(self.lblCompany.text ?? "")".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        guard let url = URL(string: "https://twitter.com/search?q=\(urlString ?? "")&src=typd&mode=users") else { return }
        UIApplication.shared.open(url)
    }
    
    
    
    //MARK:- Private Functions
    func sendSMS(mobileNumber:String) {
        if (MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController()
            controller.body = "Text Body"
            controller.recipients = [mobileNumber]
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        }
    }
}


extension MyLeadDetailVC:MFMessageComposeViewControllerDelegate {
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch (result.rawValue) {
        case MessageComposeResult.cancelled.rawValue:
            print("Message was cancelled")
            self.dismiss(animated: true, completion: nil)
        case MessageComposeResult.failed.rawValue:
            print("Message failed")
            self.dismiss(animated: true, completion: nil)
        case MessageComposeResult.sent.rawValue:
            print("Message was sent")
            self.dismiss(animated: true, completion: nil)
        default:
            break;
        }
    }
}


//MARK:- WEbservices REsponse MEthod...
extension MyLeadDetailVC: WebServiceDelegate{
    
    func webServiceResponceSuccess(_ response: Data, apiKey: String) {
        stopAnimating()
        
        if apiKey == DELETE_LEAD_API_URL
        {
            let json = JSON(data: response)
            
            if json["getDeleteLead"]["status"].string == "YES"
            {
                delegateRefresh?.refreshLeadList()
                self.navigationController?.popViewController(animated: true)
            }else{
                let alertController = UIAlertController(title: "MLeads", message: "Something went wrong ", preferredStyle: .alert)
                let alertaction1 = UIAlertAction(title: "Ok", style: .cancel) { (action) in
                    
                }
                alertController.addAction(alertaction1)
                self.present(alertController, animated: true, completion: nil)
            }
            
        }
            
//            if result.arrLeadList.count > 0
//            {
//                arrEventList.addObjects(from: [result.arrLeadList])
//            }
            
            //MARK: EVent And Group ....
//            if arrEventLeadList.count >= 1
//            {
//                arrEventLeadList.removeAllObjects()
//            }
//            if result.Status{
//                if result.arrLeadList.count > 0
//                {
//                    arrEventList.addObjects(from: [result.arrLeadList])
//                    }
//                }
         
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
