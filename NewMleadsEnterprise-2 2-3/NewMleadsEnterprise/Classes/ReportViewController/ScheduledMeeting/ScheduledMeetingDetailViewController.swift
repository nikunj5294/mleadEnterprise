//
//  ScheduledMeetingDetailViewController.swift
//  NewMleadsEnterprise
//
//  Created by Triforce New Mac on 04/11/19.
//  Copyright © 2019 com.Tri-Force.MLeadsEnterprise. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class ScheduledMeetingDetailViewController: UIViewController,NVActivityIndicatorViewable{

    @IBOutlet var lblSubject: UILabel!
    @IBOutlet var lblLocation: UILabel!
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var lblStartTime: UILabel!
    @IBOutlet var lblEndTime: UILabel!
    @IBOutlet var lblLeadName: UILabel!
    @IBOutlet var lblReminder: UILabel!
    @IBOutlet var txtNote: UITextView!
    
    @IBOutlet var lblEventName: UILabel!
    @IBOutlet var lblEventDate: UILabel!
    
    @IBOutlet var lblFirstName: UILabel!
    @IBOutlet var lblLastName: UILabel!
    @IBOutlet var lblCompany: UILabel!
    
    var selectedTakeActionDate = Date()
    
    var objTaskList = MeetingList()
    
    var strTaskStartTime = String()
    var strTaskEndTime = String()
    
    let webService : WebService = WebService()
    var handleWebService : HandleWebService = HandleWebService()
    
    var timeStamp = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Scheduled Meeting Detail"
    
        let param = ["created_timestamp":timeStamp,"userId":objLoginUserDetail.userId!] as [String : Any]

        let size = CGSize(width: 30, height: 30)
        startAnimating(size, message: "Loading...", type: NVActivityIndicatorType(rawValue: 29))

        webService.doRequestPost(GET_MEETING_DETAIL_API_URL, params: param as [String : AnyObject], key: "meetingDetail", delegate: self)
    }
//    @IBAction func btnTakenActionByClicked(_ sender: Any) {
//
//        self.view.endEditing(true)
//        
//        DatePickerPopover.sharedInstance.selectedDate = selectedTakeActionDate
//        DatePickerPopover.appearFrom(originView: sender as! UIView, baseView: btnTakeActionByObj, baseViewController: self, title: "Take Action By", dateMode: .date, initialDate: selectedTakeActionDate, doneAction: { selectedDate in print("selectedDate \(selectedDate)")
//
//            self.selectedTakeActionDate = selectedDate
//            let startDate = Utilities.DateToStringFormatter(Date: self.selectedTakeActionDate, ToString: "MM/dd/yyyy")
//            self.lblTakeActionbyObj.text = startDate
////            self.selectedTakeActionDate = Utilities.dateFormatter(Date: startDate, FromString: "MM-dd-yyyy", ToString: "yyyy-MM-dd")
//
//        }, cancelAction: {print("cancel")})
//
//    }
}

extension ScheduledMeetingDetailViewController: WebServiceDelegate{
    func webServiceResponceSuccess(_ response: Data, apiKey: String) {
        stopAnimating()
        
        
        if apiKey == GET_MEETING_DETAIL_API_URL
        {
            let result = handleWebService.handleGetMeetingListDetail(response)
            if result.Status
            {
                objTaskList = result.MeetingListDetail
                
                lblSubject.text = objTaskList.subject
                lblLocation.text = objTaskList.location
                lblDate.text = objTaskList.meetingDate
                lblStartTime.text = objTaskList.startTime
                lblEndTime.text = objTaskList.endTime
                lblLeadName.text = objTaskList.leadId
                lblReminder.text = objTaskList.alertTime
                txtNote.text = objTaskList.note
                
                lblEventName.text = objTaskList.eventName
                lblEventDate.text = objTaskList.eventDate
                
                lblFirstName.text = objTaskList.leadFirstName
                lblLastName.text = objTaskList.leadLastName
                lblCompany.text = objTaskList.leadCompany
                
                //strTaskStartTime = Utilities.dateFormatter(Date: objTaskList.startTime!, FromString: "HH:mm:ss", ToString: "hh:mm A")
                
                //strTaskEndTime = Utilities.dateFormatter(Date: objTaskList.endTime!, FromString: "HH:mm:ss", ToString: "hh:mm A")
//                if objTaskList.reminderTime == "00:00:00"
//                {
//                    strReminderTime = ""
//                }
//                else
//                {
//                    strReminderTime = Utilities.dateFormatter(Date: objTaskList.reminderTime!, FromString: "HH:mm:ss", ToString: "HH:mm")
//                }
                print("sucess.")
            }
        }
    }
    
    func webServiceResponceFailure(_ errorMessage: String) {
        stopAnimating()
        
        let alert = UIAlertController(title: nil, message: errorMessage,  preferredStyle: .alert)
        let okAct = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        okAct.setValue(alertbtnColor, forKey: "titleTextColor")
        
        alert.addAction(okAct)
        present(alert,animated: true,completion: nil)
    }
}
