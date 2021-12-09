//
//  ScheduleTaskVC.swift
//  NewMleadsEnterprise
//
//  Created by Manish Chaudhary on 21/02/21.
//  Copyright © 2021 com.Tri-Force.MLeadsEnterprise. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class ScheduleTaskVC: UIViewController, NVActivityIndicatorViewable {

    @IBOutlet weak var txtSubject: UITextField!
    @IBOutlet weak var txtStartdate: UITextField!
    @IBOutlet weak var txtEnddate: UITextField!
    @IBOutlet weak var txtstatus: UITextField!
    @IBOutlet weak var txtPriority: UITextField!
    @IBOutlet weak var btnsetReminder: UIButton!
    
    @IBOutlet weak var btnSave: UIButton!
    
    @IBOutlet weak var txtreminderEnd: UITextField!
    
    @IBOutlet weak var viewRemdate: UIView!
    @IBOutlet weak var viewRemTime: UIView!
    @IBOutlet weak var remindertime: UITextField!
    @IBOutlet weak var ContainerView: UIView!
    
    @IBOutlet weak var btnStatus: UIButton!
    @IBOutlet weak var btnPriority: UIButton!
    
    let webService : WebService = WebService()
    var handleWebService : HandleWebService = HandleWebService()
    var appdelegate = AppDelegate()
    
    var EvntStartDate = Date()
    var EvntEndDate = Date()
    var initialStartDate = Date()
    var initialEndDate = Date()
    
    var reminderDate = Date()
    var reminderTime = Date()

    var selectedIndexForStatus = 0
    var selectedIndexForPriority = 0
    
    var statusData = [["id":"1", "value":"In-Progress"]
    ,["id":"2", "value":"Completed"], ["id":"3", "value":"Waiting For"], ["id":"4", "value":"Deferred"]]
    
    var priorityData = [["id":"1", "value":"Low"]
    ,["id":"2", "value":"Normal"], ["id":"3", "value":"High"]]
    
    var arrStatus = ["In-Progress", "Completed", "Waiting For", "Deferred"]
    var arrPriority = ["Low", "Normal", "High"]
    
    var strEventID = ""
    var strLeadID = ""
    var strType = "L"
    var objLeadList = LeadList()
    var selectedEventObj: EventDetail =  EventDetail()

    var taskData = [String:Any]()
    var isEdit = false
    var taskList:TaskList?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Schedule a Task"
        btnsetReminder.isSelected = false
        btnSave.layer.cornerRadius = btnSave.frame.height / 2
        btnSave.layer.masksToBounds = true
        
        /*
         "subject" : "MyTest",
         "taskAddedFor" : "L",
         "leadId" : "1636918132",
         "startDt" : "11\/19\/2021",
         "reminderSet" : "0",
         "priorityId" : "2",
         "reminderDt" : "1970\/01\/01",
         "userId" : "1636708917",
         "leadFirstName" : "Nikunj",
         "isWhere" : "Lead",
         "taskId" : "1506",
         "endDt" : "11\/24\/2021",
         "statusId" : "3",
         "created_timestamp" : "1637266576",
         "leadLastName" : "Gondaliya",
         "leadEmail" : "testingscannikunj@gmail.com",
         "updated_timestamp" : "",
         "reminderTime" : ""
         */
        
        if isEdit{
            txtSubject.text = taskList?.subject ?? taskData["subject"] as? String ?? ""
            
            for i in 0..<statusData.count - 1{
                let dataObj = statusData[i]
                if dataObj["id"] == taskList?.statusId ?? taskData["statusId"] as? String ?? ""{
                    txtstatus.text = dataObj["value"]
                    selectedIndexForStatus = i
                }
            }
            
          
            for i in 0..<priorityData.count - 1{
                let dataObj = priorityData[i]
                if dataObj["id"] == taskList?.priorityId ?? taskData["priorityId"] as? String ?? ""{
                    txtPriority.text = dataObj["value"]
                    selectedIndexForPriority = i
                }
            }
            
            let startData = Utilities.StringToDateFormatter(DateString: taskList?.startDate ?? taskData["startDt"] as? String ?? "", FromString: "MM/dd/yyyy")
            self.EvntStartDate = startData
            self.txtStartdate.text = taskList?.startDate ?? taskData["startDt"] as? String ?? ""
            
            let endData = Utilities.StringToDateFormatter(DateString: taskList?.endDate ?? taskData["endDt"] as? String ?? "", FromString: "MM/dd/yyyy")
            self.EvntEndDate = endData
            self.txtEnddate.text = taskList?.endDate ?? taskData["endDt"] as? String ?? ""
            
            let reminderSet = taskList?.reminderSet ?? taskData["reminderSet"] as? String
            btnsetReminder.isSelected = reminderSet == "0" ? false : true
            
            if reminderSet != "0"{
                remindertime.text = taskList?.reminderTime ?? taskData["reminderTime"] as? String ?? ""
                txtreminderEnd.text = taskList?.reminderDt ?? taskData["reminderDt"] as? String ?? ""
            }
            
//            txtStartdate.text = taskData["subject"] as? String ?? ""
//            txtSubject.text = taskData["subject"] as? String ?? ""
//            txtSubject.text = taskData["subject"] as? String ?? ""
        }
        
        // Do any additional setup after loading the view.
    }
    
    //MARK:- ACTIONS
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnsetreminder(_ sender: UIButton) {
        DispatchQueue.main.async {
            sender.isSelected = !sender.isSelected
            self.viewRemdate.isHidden = !sender.isSelected
            self.viewRemTime.isHidden = !sender.isSelected
        }
    }
    
    @IBAction func btnsaveaction(_ sender: Any) {
        
        let timeStamp = Date.currentTimeStamp
        
        let dictStatus = statusData[selectedIndexForStatus]
        let dictPriority = priorityData[selectedIndexForPriority]
        
        /*
         "subject" : "MyTest",
         "taskAddedFor" : "L",
         "leadId" : "1636918132",
         "startDt" : "11\/19\/2021",
         "reminderSet" : "0",
         "priorityId" : "2",
         "reminderDt" : "1970\/01\/01",
         "userId" : "1636708917",
         "leadFirstName" : "Nikunj",
         "isWhere" : "Lead",
         "taskId" : "1506",
         "endDt" : "11\/24\/2021",
         "statusId" : "3",
         "created_timestamp" : "1637266576",
         "leadLastName" : "Gondaliya",
         "leadEmail" : "testingscannikunj@gmail.com",
         "updated_timestamp" : "",
         "reminderTime" : ""
         */
        
        if isEdit{
            let createdTimeStamp = taskList?.created_timestamp ?? taskData["created_timestamp"] as? String ?? ""
            let dictAPI = ["created_timestamp" : createdTimeStamp,
            "endDt" : self.txtEnddate.text!,
            "eventId" : strType == "L" ? "" : selectedEventObj.eventid!,
            "leadId" : strType == "E" ? "" : taskData["leadId"] as! String,
            "priorityId" : dictPriority["id"]!,
            "reminderDt" : btnsetReminder.isSelected ? self.txtreminderEnd.text! : "",
            "reminderSet" : btnsetReminder.isSelected ? 1 : 0,
            "reminderTime" : btnsetReminder.isSelected ? self.remindertime.text! : "",
            "startDt" : self.txtStartdate.text!,
            "statusId" : dictStatus["id"]!,
            "subject" : self.txtSubject.text!,
            "type" : strType,
            "userId" : objLoginUserDetail.createTimeStamp!,
            "updated_timestamp" : "\(timeStamp)"] as [String:AnyObject]
       
            //Progress Bar Loding...
            let size = CGSize(width: 30, height: 30)
            startAnimating(size, message: "Loading...", type: NVActivityIndicatorType(rawValue: 29))
            
            webService.doRequestPost(UPDATE_TASK_API_URL, params: dictAPI, key: "updateTask", delegate: self)
            
        }else{
            let dictAPI = ["created_timestamp" : "\(timeStamp)",
            "endDt" : self.txtEnddate.text!,
            "eventId" : strType == "L" ? "" : selectedEventObj.eventid!,
            "leadId" : strType == "E" ? "" : taskData["leadId"] as! String,
            "priorityId" : dictPriority["id"]!,
            "reminderDt" : btnsetReminder.isSelected ? self.txtreminderEnd.text! : "",
            "reminderSet" : btnsetReminder.isSelected ? 1 : 0,
            "reminderTime" : btnsetReminder.isSelected ? self.remindertime.text! : "",
            "startDt" : self.txtStartdate.text!,
            "statusId" : dictStatus["id"]!,
            "subject" : self.txtSubject.text!,
            "type" : strType,
            "userId" : objLoginUserDetail.createTimeStamp!] as [String:AnyObject]
       
            //Progress Bar Loding...
            let size = CGSize(width: 30, height: 30)
            startAnimating(size, message: "Loading...", type: NVActivityIndicatorType(rawValue: 29))
            
            webService.doRequestPost(ADD_TASK_API_URL, params: dictAPI, key: "addTask", delegate: self)
        }
    }
    
    //MARK: Button Start And End Date DropDown
    @IBAction func btnStartDateDropDown(_ sender: Any) {
        view.endEditing(true)

        DatePickerPopover.appearFrom(originView: sender as! UIView, baseView: ContainerView, baseViewController: self, title: "Start Date", dateMode: .date, initialDate: self.initialStartDate, doneAction: { selectedDate in print("selectedDate \(selectedDate)")
//        DatePickerPopover.appearFrom(originView: sender as! UIView, baseView: ContainerView, baseViewController: self, title: "Event Start Date", dateMode: .date, initialDate: self.initialStartDate, doneAction: { selectedDate in print("selectedDate \(selectedDate)")
        
            
            self.EvntStartDate = selectedDate
            let startDate = Utilities.DateToStringFormatter(Date: self.EvntStartDate, ToString: "MM/dd/yyyy")
            print("startDate : \(startDate)")
            self.txtStartdate.text = startDate
//            self.lblStartDate.text = startDate
//            self.strEvntStartDate = Utilities.dateFormatter(Date: startDate, FromString: "MM-dd-yyyy", ToString: "yyyy-MM-dd")
//            self.initialStartDate = selectedDate
            
        }, cancelAction: {print("cancel")})
    }
    
    @IBAction func btnEndDateDropDown(_ sender: Any) {
        view.endEditing(true)
        
        DatePickerPopover.appearFrom(originView: sender as! UIView, baseView: ContainerView, baseViewController: self, title: "End Date", dateMode: .date, initialDate: self.initialEndDate, doneAction: { selectedDate in print("selectedDate \(selectedDate)")
            
            self.EvntEndDate = selectedDate
            let endDate = Utilities.DateToStringFormatter(Date: self.EvntEndDate, ToString: "MM/dd/yyyy")
            print("endDate : \(endDate)")
            self.txtEnddate.text = endDate
//            self.lblEndDate.text = endDate
//            self.strEventEndDate = Utilities.dateFormatter(Date: endDate, FromString: "MM-dd-yyyy", ToString: "yyyy-MM-dd")
//            self.initialEndDate = selectedDate
            
        }, cancelAction: {print("cancel")})
    }
    
    @IBAction func btnClickedStatus(_ sender: UIButton) {
        
        print("Click On Button in TeamManagement")
        StringPickerPopOver.appearFrom(originView: sender as UIView, baseView: self.btnStatus, baseViewController: self, title: "Select Status", choices: arrStatus , initialRow:selectedIndexForStatus, doneAction: { selectedRow, selectedString in
            print("row \(selectedRow) : \(selectedString)")
            
            self.txtstatus.text = selectedString
            self.selectedIndexForStatus = selectedRow
            
            
        }, cancelAction:{print("cancel")})
    }
    
    
    @IBAction func btnClickedPriority(_ sender: UIButton) {
        
        StringPickerPopOver.appearFrom(originView: sender as UIView, baseView: self.btnPriority, baseViewController: self, title: "Select Priority", choices: arrPriority , initialRow:selectedIndexForPriority, doneAction: { selectedRow, selectedString in
            print("row \(selectedRow) : \(selectedString)")
            
            self.txtPriority.text = selectedString
            self.selectedIndexForPriority = selectedRow
            
        }, cancelAction:{print("cancel")})
    }
    
    @IBAction func btnReminderDate(_ sender: Any) {
        view.endEditing(true)
        
        DatePickerPopover.appearFrom(originView: sender as! UIView, baseView: ContainerView, baseViewController: self, title: "Reminder Date", dateMode: .date, initialDate: self.initialEndDate, doneAction: { selectedDate in print("selectedDate \(selectedDate)")
            
            self.reminderDate = selectedDate
            let endDate = Utilities.DateToStringFormatter(Date: self.reminderDate, ToString: "MM/dd/yyyy")
            print("endDate : \(endDate)")
            self.txtreminderEnd.text = endDate
//            self.lblEndDate.text = endDate
//            self.strEventEndDate = Utilities.dateFormatter(Date: endDate, FromString: "MM-dd-yyyy", ToString: "yyyy-MM-dd")
//            self.initialEndDate = selectedDate
            
        }, cancelAction: {print("cancel")})
    }
    
    @IBAction func btnReminderTime(_ sender: Any) {
        view.endEditing(true)
        
        DatePickerPopover.appearFrom(originView: sender as! UIView, baseView: ContainerView, baseViewController: self, title: "Event End Date", dateMode: .time, initialDate: self.initialEndDate, doneAction: { selectedDate in print("selectedDate \(selectedDate)")
            
            self.reminderTime = selectedDate
            let endDate = Utilities.DateToStringFormatter(Date: self.reminderTime, ToString: "HH:mm")
            print("endDate : \(endDate)")
            self.remindertime.text = endDate
//            self.txtEnddate.text = endDate
//            self.lblEndDate.text = endDate
//            self.strEventEndDate = Utilities.dateFormatter(Date: endDate, FromString: "MM-dd-yyyy", ToString: "yyyy-MM-dd")
//            self.initialEndDate = selectedDate
            
        }, cancelAction: {print("cancel")})
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

//MARK:- Webservices Method...
extension ScheduleTaskVC:WebServiceDelegate{
    
    func webServiceResponceSuccess(_ response: Data, apiKey: String) {
        stopAnimating()
        
        if apiKey == ADD_TASK_API_URL
        {
            let json = JSON(data: response)
            print(json)
            if json["addTask"]["status"].string == "YES"
            {
                ShowAlert(title: "Mleads", message: "Task created successfully", buttonTitle: "OK") {
                    for case let vc as CreateTaskListing in self.navigationController?.viewControllers ?? [UIViewController()] {
                        NotificationCenter.default.post(name: Notification.Name("callRefreshTaskListAPI"), object: nil, userInfo: nil)
                        self.navigationController?.popToViewController(vc, animated: true)
                    }
                }
                
            }else{
                ShowAlert(title: "Mleads", message: "Something went wrong please try again", buttonTitle: "Ok") {
                }
            }
        }else if apiKey == UPDATE_TASK_API_URL{
            let json = JSON(data: response)
            print(json)
            if json["updateTask"]["status"].string == "YES"
            {
                ShowAlert(title: "Mleads", message: "Task updated successfully", buttonTitle: "OK") {
                    for case let vc as CreateTaskListing in self.navigationController?.viewControllers ?? [UIViewController()] {
                        NotificationCenter.default.post(name: Notification.Name("callRefreshTaskListAPI"), object: nil, userInfo: nil)
                        self.navigationController?.popToViewController(vc, animated: true)
                    }
                }
                
            }else{
                ShowAlert(title: "Mleads", message: "Something went wrong please try again", buttonTitle: "OK") {
                }
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

