//
//  ScheduledTaskDetailViewController.swift
//  NewMleadsEnterprise
//
//  Created by Triforce New Mac on 24/10/19.
//  Copyright © 2019 com.Tri-Force.MLeadsEnterprise. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class ScheduledTaskDetailViewController: UIViewController, NVActivityIndicatorViewable {

    
    @IBOutlet var lblSubject: UILabel!
    @IBOutlet var lblStartDate: UILabel!
    @IBOutlet var lblEndDate: UILabel!
    @IBOutlet var lblStatus: UILabel!
    @IBOutlet var lblPriority: UILabel!
    
    @IBOutlet var lblEventName: UILabel!
    @IBOutlet var lblEventDate: UILabel!
    
    @IBOutlet var lblFirstName: UILabel!
    @IBOutlet var lblLastName: UILabel!
    @IBOutlet var lblCompany: UILabel!
    
    @IBOutlet var btnViewLeadDetail: UIButton!
    @IBOutlet var btnMarkAsCompleted: UIButton!
    
    var objTaskList = TaskList()
    
    let webService : WebService = WebService()
    var handleWebService : HandleWebService = HandleWebService()
    //var appdelegate = AppDelegate()
    
    var timeStamp = String()
    var strTaskStartDate = String()
    var strTaskEndDate = String()
    
    var strReminderDate = String()
    var strReminderTime = String()
    
    var selectedIndexForStatus = Int()
    var selectedIDForStatus = String()
    
    var selectedIndexForPriority = Int()
    var selectedIDForPriority = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Scheduled Task View"
        self.findHamburguerViewController()?.gestureEnabled = false
        
        let param = ["created_timestamp":timeStamp,
                     "userId":objLoginUserDetail.userId!,
                     "isEvent":"N"] as [String : Any]
        
        let size = CGSize(width: 30, height: 30)
        startAnimating(size, message: "Loading...", type: NVActivityIndicatorType(rawValue: 29))
        
        webService.doRequestPost(GET_TASK_DETAIL_API_URL, params: param as [String : AnyObject], key: "taskDetail", delegate: self)
    }
    
    @IBAction func btnViewLeadDetailAction(_ sender: Any) {
        
    }
    
    @IBAction func btnMarkAsCompletAction(_ sender: Any) {
        
        let param = ["subject":objTaskList.subject!,
                     "startDt":strTaskStartDate,
                     "endDt":strTaskEndDate,
                     "statusId":objTaskList.statusId,
                     "priorityId":objTaskList.priorityId,
                     "userId":objLoginUserDetail.userId,
                     "created_timestamp":objTaskList.created_timestamp,
                     "eventId":objTaskList.eventId,
                     "leadId":objTaskList.leadId,
                     "reminderSet":objTaskList.reminderSet,
                     "reminderDt":strReminderDate,
                     "reminderTime":strReminderTime,
                     "taskIdentifier":objTaskList.taskIdentifire] as [String : Any]


        let size = CGSize(width: 30, height: 30)
        startAnimating(size, message: "Loading...", type: NVActivityIndicatorType(rawValue: 29))

        webService.doRequestPost(UPDATE_TASK_API_URL, params: param as [String : AnyObject], key: "updateTask", delegate: self)
        
    }
}

extension ScheduledTaskDetailViewController: WebServiceDelegate{
    func webServiceResponceSuccess(_ response: Data, apiKey: String) {
        stopAnimating()
        
        if apiKey == GET_TASK_DETAIL_API_URL
        {
            let result = handleWebService.handleGetTaskListDetail(response)
            
            if result.Status
            {
                objTaskList = result.TaskListDetail
                
                lblSubject.text = objTaskList.subject
                lblStartDate.text = objTaskList.startDate
                lblEndDate.text = objTaskList.endDate
                lblEventName.text = objTaskList.eventName
                lblEventDate.text = objTaskList.eventDate
            
                lblFirstName.text = objTaskList.lFirstName
                lblLastName.text = objTaskList.lLastName
                lblCompany.text = objTaskList.lCompany
                
                if arrStatus.StatusId.contains(objTaskList.statusId!)
                {
                    selectedIndexForStatus = arrStatus.StatusId.index(of: objTaskList.statusId!)!
                    selectedIDForStatus = arrStatus.StatusId[selectedIndexForStatus]
                }
                lblStatus.text = arrStatus.StatusName[selectedIndexForStatus]
                
                if arrPriority.PriorityId.contains(objTaskList.priorityId!)
                {
                    selectedIndexForPriority = arrPriority.PriorityId.index(of: objTaskList.priorityId!)!
                    selectedIDForPriority = arrPriority.PriorityId[selectedIndexForPriority]
                }
                lblPriority.text = arrPriority.PriorityName[selectedIndexForPriority]
                
                if objLoginUserDetail.userId == objTaskList.userId && arrStatus.StatusName[selectedIndexForStatus] != "Completed"
                {
                    btnMarkAsCompleted.isHidden = false
                }
                else
                {
                    btnMarkAsCompleted.isHidden = true
                }
                
                strTaskStartDate = Utilities.dateFormatter(Date: objTaskList.startDate!, FromString: "MM/dd/yyyy", ToString: "yyyy-MM-dd")
                
                strTaskEndDate = Utilities.dateFormatter(Date: objTaskList.endDate!, FromString: "MM/dd/yyyy", ToString: "yyyy-MM-dd")
                
                
                if objTaskList.reminderDt == "00/00/0000"
                {
                    strReminderDate = ""
                }
                else
                {
                    strReminderDate = Utilities.dateFormatter(Date: objTaskList.reminderDt!, FromString: "MM/dd/yyyy", ToString: "yyyy-MM-dd")
                }
                
                if objTaskList.reminderTime == "00:00:00"
                {
                    strReminderTime = ""
                }
                else
                {
                    strReminderTime = Utilities.dateFormatter(Date: objTaskList.reminderTime!, FromString: "HH:mm:ss", ToString: "HH:mm")
                }
            }
        }
        else if apiKey == UPDATE_TASK_API_URL
        {
            let json = JSON(data: response)
            
            if json["updateTask"]["status"].string == "YES"
            {
                let alert = UIAlertController(title: "", message: "Task Completed Successfully.",  preferredStyle: .alert)
                let attributedString = Utilities.alertAttribute(titleString: "Update Task!")
                alert.setValue(attributedString, forKey: "attributedTitle")
                let okAct = UIAlertAction(title: "OK", style: .default, handler: {UIAlertAction in
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
        
        let alert = UIAlertController(title: nil, message: errorMessage,  preferredStyle: .alert)
        let okAct = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        okAct.setValue(alertbtnColor, forKey: "titleTextColor")
        
        alert.addAction(okAct)
        present(alert,animated: true,completion: nil)
    }
    
    
}
