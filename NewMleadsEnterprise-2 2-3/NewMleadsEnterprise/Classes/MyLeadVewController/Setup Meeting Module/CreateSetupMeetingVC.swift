//
//  CreateSetupMeetingVC.swift
//  NewMleadsEnterprise
//
//  Created by Akshansh Modi on 28/02/21.
//  Copyright © 2021 com.Tri-Force.MLeadsEnterprise. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class CreateSetupMeetingVC: UIViewController, NVActivityIndicatorViewable,WebServiceDelegate  {

    @IBOutlet weak var txtSubject: UITextField!
    @IBOutlet weak var txtLocation: UITextField!
    @IBOutlet weak var txtDate: UITextField!
    @IBOutlet weak var txtStartTime: UITextField!
    @IBOutlet weak var txtEndTime: UITextField!
    @IBOutlet weak var viewMyLead: UIView!
    @IBOutlet weak var lblSelectLead: UILabel!
    @IBOutlet weak var lblAlarmAlert: UITextField!
    @IBOutlet weak var btnNotes: UIButton!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var ContainerView: UIView!
    
 
    
    var objLeadList = LeadList()
    let webService : WebService = WebService()
    var handleWebService : HandleWebService = HandleWebService()
    var appdelegate = AppDelegate()
    var strNotes = ""
    
    var EvntStartDate = Date()
    var EvntEndDate = Date()
    var initialStartDate = Date()
    var initialEndDate = Date()
    
    var reminderDate = Date()
    var reminderTime = Date()
    
  
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Scheduled Meetings"

        self.viewMyLead.setShadowColor()
        self.btnSave.layer.cornerRadius = 10
        self.btnSave.clipsToBounds = true
        
        self.btnNotes.layer.cornerRadius = 5
        self.btnNotes.clipsToBounds = true
    }

    
    //MARK: - Button Actions
    
    
    
     
    @IBAction func btnDateClicked(_ sender: Any) {
        view.endEditing(true)

        DatePickerPopover.appearFrom(originView: sender as! UIView, baseView: ContainerView, baseViewController: self, title: "Start Date", dateMode: .date, initialDate: self.initialStartDate, doneAction: { selectedDate in print("selectedDate \(selectedDate)")
            self.EvntStartDate = selectedDate
            let startDate = Utilities.DateToStringFormatter(Date: self.EvntStartDate, ToString: "MM-dd-yyyy")
            print("startDate : \(startDate)")
            self.txtDate.text = startDate

        }, cancelAction: {print("cancel")})
    }
    @IBAction func btnAlarmalert(_ sender: UIButton) {
        view.endEditing(true)

        DatePickerPopover.appearFrom(originView: sender as! UIView, baseView: ContainerView, baseViewController: self, title: "Start Date", dateMode: .countDownTimer, initialDate: self.initialStartDate, doneAction: { selectedDate in print("selectedDate \(selectedDate)")
            self.EvntStartDate = selectedDate
            let startDate = Utilities.DateToStringFormatter(Date: self.EvntStartDate, ToString: "HH:mm")
            print("startDate : \(startDate)")
            self.lblAlarmAlert.text = startDate

        }, cancelAction: {print("cancel")})
    }
    @IBAction func btnStartdateclicked(_ sender: Any) {
        view.endEditing(true)

        DatePickerPopover.appearFrom(originView: sender as! UIView, baseView: ContainerView, baseViewController: self, title: "Start Time", dateMode: .time, initialDate: self.initialStartDate, doneAction: { selectedDate in print("selectedDate \(selectedDate)")
            self.EvntStartDate = selectedDate
            let startDate = Utilities.DateToStringFormatter(Date: self.EvntStartDate, ToString: "HH:mm a")
            print("startDate : \(startDate)")
            self.txtStartTime.text = startDate

        }, cancelAction: {print("cancel")})
    }
    @IBAction func btnEndClicked(_ sender: Any) {
        
        
        view.endEditing(true)

        DatePickerPopover.appearFrom(originView: sender as! UIView, baseView: ContainerView, baseViewController: self, title: "End Time", dateMode: .time, initialDate: self.initialStartDate, doneAction: { selectedDate in print("selectedDate \(selectedDate)")
            self.EvntStartDate = selectedDate
            let startDate = Utilities.DateToStringFormatter(Date: self.EvntStartDate, ToString: "HH:mm a")
            print("startDate : \(startDate)")
            self.txtEndTime.text = startDate

        }, cancelAction: {print("cancel")})
    }
    
    @IBAction func Notes(_ sender: Any) {
        // CreateSetupMeetingNotesVC
        
        let vcCreateList = StoryBoard.MyLead.instantiateViewController(withIdentifier: "CreateSetupMeetingNotesVC") as! CreateSetupMeetingNotesVC
        self.navigationController?.pushViewController(vcCreateList, animated: true)
        
    }
    
    @IBAction func Save(_ sender: Any) {
        
        let timeStamp = Date.currentTimeStamp

        
//        let dict = [
//            "userId" : objLoginUserDetail.createTimeStamp! as AnyObject,
//            "leadId" : objLeadList.leadId!,
//            "eventId" : objLeadList.eventId!,
//            "type" : "L"
//        ] as [String : AnyObject]
        
        let dict = ["created_timestamp" : "\(timeStamp)",
                           "endTime" : txtEndTime.text!,
                           "leads" : objLeadList.leadId,
                           "location" : txtLocation.text!,
                           "meetingDt" : txtDate.text!,
                           "note" : strNotes,
                           "reminder" : "",
                           "startTime" : txtStartTime.text!,
                           "subject" : "",
                           "updated_timestamp" : "",
                           "userId" : objLoginUserDetail.createTimeStamp!] as [String : AnyObject]
        
        
        //Progress Bar Loding...
        let size = CGSize(width: 30, height: 30)
        startAnimating(size, message: "Loading...", type: NVActivityIndicatorType(rawValue: 29))
        
        webService.doRequestPost(ADD_MEETING_API_URL, params: dict, key: "addMeeting", delegate: self)
        
//        self.navigationController?.popViewController(animated: true)
    }
}

extension CreateSetupMeetingVC {
    
    //MARK:Webservice CAlling Function..
    func webServiceResponceSuccess(_ response: Data, apiKey: String) {
        stopAnimating()
        
        
        if apiKey == EDIT_EVENT_API_KEY
        {
            let json = JSON(data: response)
            print(json)
            if json["getTaskList"]["status"].string == "YES"
            {
                
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
