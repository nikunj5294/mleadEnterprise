//
//  ScheduledTasksViewController.swift
//  NewMleadsEnterprise
//
//  Created by Triforce New Mac on 17/10/19.
//  Copyright © 2019 com.Tri-Force.MLeadsEnterprise. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import MessageUI

class ScheduledTasksViewController: UIViewController, NVActivityIndicatorViewable{

    @IBOutlet var FilterView: UIView!
    @IBOutlet var tblScheduledTasks: UITableView!
    
    
    @IBOutlet var btnTeamMember: UIButton!
    @IBOutlet var lblTeamMember: UILabel!
    
    @IBOutlet var btnDuration: UIButton!
    @IBOutlet var lblDuration: UILabel!
    
    @IBOutlet var btnStatus: UIButton!
    @IBOutlet var lblStatus: UILabel!
    @IBOutlet weak var heightConstantBottomView: NSLayoutConstraint!

    let webService : WebService = WebService()
    var handleWebService : HandleWebService = HandleWebService()
    var appdelegate = AppDelegate()
    
    var exportedLeadsData = String()
    var currentDate_Time = String()
    
    var arrTeamMamber = [String]()
    var selectedIDForTeamMember = String()
    var arrTeamCreatedTiemStemp = [String]()
    var selectedIndexForTeamMember = Int()
    var selectedStringForTeamMamber = String()
    
    var selectedIndexForDuration = Int()
    
    var selectedIndexForStatus = Int()
    
    var arrTaskList = NSMutableArray()
    var statusArr = NSMutableArray()
    
    var selectedUserID = String()
    var durationID = String()
    var statusID = String()
    var selectedEventObj: EventDetail =  EventDetail()
    var selectedRow = -1
    var isfromreport = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Scheduled Tasks"
        self.findHamburguerViewController()?.gestureEnabled = false
        
        let add = UIBarButtonItem(image:UIImage(named: "plus"), style: .plain, target: self, action: #selector(self.btnAdd(_:)))//#selector(addTapped)
        let filter = UIBarButtonItem(image:UIImage(named: "filter"), style: .plain, target: self, action: #selector(self.btnFilter(_:)))
        let export = UIBarButtonItem(image:#imageLiteral(resourceName: "Icon-40"), style: .plain, target: self, action: #selector(btnExportTapped))//)btnExportAction
        let fixedSpace = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        fixedSpace.width = -26.0
        
        if isfromreport {
            self.navigationItem.rightBarButtonItems = [filter,export]
            self.FilterView.isHidden = false
        }else{
            self.navigationItem.rightBarButtonItems = [add]
            self.FilterView.isHidden = true
        }
       
//        tblScheduledTasks.rowHeight = 63
        tblScheduledTasks.rowHeight = UITableView.automaticDimension
        tblScheduledTasks.estimatedRowHeight = 63
        
            
        //MARK: WEB SERVICES CALL TEAM MEMBER LIST...
        let param:[String : AnyObject] = ["userId":objLoginUserDetail.createTimeStamp! as AnyObject, "hierarchy_type":"1" as AnyObject]
        
        let size = CGSize(width: 30, height: 30)
        startAnimating(size, message: "Loading...", type: NVActivityIndicatorType(rawValue: 29))
        
        webService.doRequestPost(GET_ADD_TEAM_MEMBER_LIST, params: param, key: "user", delegate: self)
        
        let dict1 = ["value":"InProgress","id":"1"]
        let dict2 = ["value":"Completed","id":"2"]
        let dict3 = ["value":"Waiting","id":"3"]
        let dict4 = ["value":"Deferred","id":"4"]
        
        statusArr.add(dict1)
        statusArr.add(dict1)
        statusArr.add(dict3)
        statusArr.add(dict4)
        
        self.view.layoutIfNeeded()
    }
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        heightConstantBottomView.constant = 0
        selectedRow = -1
        callTaskListAPI()
    }
    
    //MARK:- WEBServices Function in Schedual Task....
    @objc func callTaskListAPI() {
        var name = String()
        if let eventid = selectedEventObj.eventid {
            name = eventid
        }
        
        
        let dict = [
            "userId" : objLoginUserDetail.createTimeStamp! as AnyObject,
            "leadId" : "",
            "eventId" : name,
            "type" : "E"
        ] as [String : AnyObject]
        
        //Progress Bar Loding...
        let size = CGSize(width: 30, height: 30)
        startAnimating(size, message: "Loading...", type: NVActivityIndicatorType(rawValue: 29))
        
        webService.doRequestPost(GET_TASK_LIST_API_URL, params: dict, key: "taskList", delegate: self)
    }
    func callWebServiceForScheduledTask(selectedId:String,typeId:String,statusId:String)
    {
    
        
        var param: [String : Any] = [String : Any]()
        if typeId == "17"
        {
            param = ["userId":objLoginUserDetail.createTimeStamp!,
                     "selectedId":selectedId,
                     "typeId":"0",
                     "statusId":statusId] as [String : Any]
        }else
        {
            param = ["userId":objLoginUserDetail.createTimeStamp!,
                     "selectedId":selectedId,
                     "typeId":typeId,
                     "statusId":statusId] as [String : Any]
        }
//        //MARK: Progress Bar ....
        let size = CGSize(width: 30, height: 30)
        startAnimating(size, message: "Loading...", type: NVActivityIndicatorType(rawValue: 29))
        
        webService.doRequestPost(GET_SCHEDULED_TASKS_URL, params: param as [String : AnyObject], key: "taskList", delegate: self)
    }
    //MARK:- Button Add Action...
    @IBAction func btnAdd(_ sender: Any) {
        let vc = StoryBoard.MyLead.instantiateViewController(withIdentifier: "ScheduleTaskVC") as! ScheduleTaskVC
        vc.strType = "E"
        vc.selectedEventObj = selectedEventObj
        self.navigationController?.pushViewController(vc, animated: true)
    }
    //MARK:- Button Filter Action...
    @IBAction func btnFilter(_ sender: Any) {
        self.FilterView.isHidden = false
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            if (touch.view == self.view) {
                self.dismiss(animated: true, completion: nil)
            }
        }
        self.FilterView.isHidden = true
    }
    
    //MARK:- Export Button Action...
    @objc func btnExportTapped()  {
        
        var isAllowed: Bool = true
        if (objLoginUserDetail.export_allowed?.isEqual("1"))! {
            isAllowed = true
        }
        
        if isAllowed
        {
            var myExportContent = String()
            myExportContent += "List of Task.\nNote : *= Required Fields\nNote : Priority must be number for e.g ,1=Low,2=Normal,3=High\nTeam Member Name*,Event/Lead Group Name,Lead Name,Subject*,Start Date*,End Date*,Status*,Priority*\n"
            
            if arrTaskList.count > 0
            {
                for k in 0..<arrTaskList.count
                {
                    let myTask: TaskList? = (arrTaskList[k] as? TaskList)
                    // Team Member Name.
                    if ((myTask?.teamMember) != nil) && !((myTask?.teamMember?.isEmpty)!)
                    {
                        let name: String? = "\(myTask!.teamMember!)"
                        if self.isAddQuoteCharater(name!) {
                            myExportContent += "\"\(name!)\","
                        }
                        else {
                            myExportContent += "\(name!),"
                        }
                    }
                    else
                    {
                        myExportContent += ","
                    }
                    // Event/Lead Group Name
                    var eventName: String = ""
                    if !(myTask?.isWhere == "Lead") {
                        eventName = (myTask!.eventName!)
                    }
                    if  !(eventName.isEmpty) {
                        let name: String = "\(eventName)"
                        if self.isAddQuoteCharater(name) {
                            myExportContent += "\"\(name)\","
                        }
                        else {
                            myExportContent += "\(name),"
                        }
                    }
                    else {
                        myExportContent += ","
                    }
                    // Add Lead Name
                    var leadName: String = ""
                    if (myTask?.isWhere == "Lead") {
                        leadName = (myTask!.eventName!)
                    }
                    if  (leadName.characters.count ) > 0 {
                        let name: String = "\(leadName)"
                        if self.isAddQuoteCharater(name) {
                            myExportContent += "\"\(name)\","
                        }
                        else {
                            myExportContent += "\(name),"
                        }
                    }
                    else {
                        myExportContent += ","
                    }
                    // Add Subject.
                    if (myTask!.subject != nil) && (myTask?.subject?.characters.count)! > 0 {
                        let subject: String = "\(myTask!.subject!)"
                        if self.isAddQuoteCharater(subject) {
                            myExportContent += "\"\(subject)\","
                        }else
                        {
                            myExportContent += "\(subject),"
                                        
                        }
                    }else{
                        myExportContent += ","
                    }

                    if (myTask!.startDate != nil) && (myTask?.startDate?.characters.count)! > 0 {
                        let startDate: String = "\(myTask!.startDate!)"
                        if self.isAddQuoteCharater(startDate) {
                            myExportContent += "\"\(startDate)\","
                        }
                        else {
                            myExportContent += "\(startDate),"
                        }
                    }
                    else {
                        myExportContent += ","
                    }
                    // Add End Date.

                        if  (myTask?.endDate?.characters.count)! > 0{
                            let endDate: String = "\(myTask!.endDate!)"
                                if self.isAddQuoteCharater(endDate) {
                                    myExportContent += "\"\(endDate)\","
                                }
                                else {
                                    myExportContent += "\(endDate),"
                                }
                            }
                            else {
                                myExportContent += ","
                            }
                      //Add Status
                        if (myTask?.statusId?.characters.count)! > 0 {
   
                            let index: Int? = (statusArr.value(forKey: "id") as! NSArray).index(of: myTask?.statusId ?? String())
                            let strNewStatus: String? = (statusArr.value(forKey: "value") as? NSArray)?.object(at: index!) as! String?
                                if self.isAddQuoteCharater(strNewStatus!) {
                                    myExportContent += "\"\(strNewStatus!)\","
                                }
                                else {
                                    myExportContent += "\(strNewStatus!),"
                                }
                            }
                            else {
                                myExportContent += ","
                            }
                    
                        // Add Priority.
                        if  (myTask?.priorityId?.characters.count)! > 0 {
                            let priority: String = "\(myTask!.priorityId!)"
                               if self.isAddQuoteCharater(priority) {
                                    myExportContent += "\"\(priority)\""
                                }
                                else {
                                    myExportContent += "\(priority)"
                                }
                        }
                            myExportContent += "\(CSV_NEW_LINE_INDICATOR)"
                        }
                
                        // Get Current Date and time.
                        let currentDate = Date()
                        let format = DateFormatter()
                        format.dateFormat = "yyyy-MM-dd-HH-mm-ss"
                        let currentDateAndTime: String = format.string(from: currentDate)
                        exportedLeadsData = myExportContent
                        print(exportedLeadsData)
                        currentDate_Time = currentDateAndTime
                        var path = String()
                        let csvdata = self.exportedLeadsData.data(using: .utf8)
                        
                        let documentdirectory = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
                        let documentPath = documentdirectory.appendingPathComponent(objLoginUserDetail.createTimeStamp!)
                        print(documentPath!.path)
                        let fullname = self.lblTeamMember.text?.components(separatedBy: " ")
                        print(fullname!)
                            
                        let name = self.lblTeamMember.text!
                        path = "\(documentPath!.path)/\(name)_TaskList.csv"
                        print(path)
                            
       
                        if !FileManager.default.fileExists(atPath: documentPath!.path){
                            do{
                                try FileManager.default.createDirectory(atPath: documentPath!.path, withIntermediateDirectories: true, attributes: nil)
                                let a = FileManager.default.createFile(atPath: path, contents: csvdata, attributes: nil)
                                print(a)
                            }catch let error as NSError {
                                NSLog("Unable to create directory \(error.debugDescription)")
                            }
                        }
                        else
                        {
                            if FileManager.default.fileExists(atPath: path) {
                                do
                                {
                                    try FileManager.default.removeItem(atPath: path)
                                }catch let error as NSError {
                                    NSLog("Unable to delete file \(error.debugDescription)")
                                }
                                    
                            }
                            let a = FileManager.default.createFile(atPath: path, contents: csvdata, attributes: nil)
                                print(a)
                            }

                let viewAlert : UIAlertController = UIAlertController(title: "", message: "", preferredStyle: UIAlertController.Style.alert)
                //let viewAlert : UIAlertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
                let attributedString = Utilities.alertAttribute(titleString: "Select Export")
                viewAlert.setValue(attributedString, forKey: "attributedTitle")
                
                let SendmailAct = UIAlertAction(title: "Send Mail With CSV", style: UIAlertAction.Style.default , handler: { action in
                                
                    let param = ["template_code":"SCHEDULE_TASK_REPORT_MOBILE","userId":objLoginUserDetail.createTimeStamp!] as [String : String]
                    //Progess Bar...
                    let size = CGSize(width: 30, height: 30)
                    self.startAnimating(size, message: "Loading...", type: NVActivityIndicatorType(rawValue: 29))
                               
                    self.webService.doRequestPost(Get_EmailTamplate_API, params: param as [String : AnyObject], key: "getEmailTemplate", delegate: self as WebServiceDelegate)
                        
                })
                
                let saveCSVAct = UIAlertAction(title: "Save CSV File", style: UIAlertAction.Style.destructive , handler: { action  in
                               
                    let alert = UIAlertController(title: "File saved successfully to documents folder.", message: "",  preferredStyle: .alert)
                    let okAct = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                                
                    okAct.setValue(alertbtnColor, forKey: "titleTextColor")
                                
                    alert.addAction(okAct)
                    self.present(alert,animated: true,completion: nil)
                    })
                            
                    let cancelAct = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
                    SendmailAct.setValue(UIColor.black, forKey: "titleTextColor")
                    saveCSVAct.setValue(UIColor.black, forKey: "titleTextColor")
                    cancelAct.setValue(alertbtnColor, forKey: "titleTextColor")
                    viewAlert.addAction(SendmailAct)
                    viewAlert.addAction(saveCSVAct)
                    viewAlert.addAction(cancelAct)
                    self.present(viewAlert, animated: true, completion: nil)
                }
                    else
                    {
                        let alert = UIAlertController(title: "", message: "",  preferredStyle: .alert)
                        let attributedString = Utilities.alertAttribute(titleString: "No Task Found.")
                        alert.setValue(attributedString, forKey: "attributedTitle")
                        let okAct = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                                
                        okAct.setValue(alertbtnColor, forKey: "titleTextColor")
                                
                        alert.addAction(okAct)
                        present(alert,animated: true,completion: nil)
  
                }
        }
        else {
            let alert = UIAlertController(title: "", message: "",  preferredStyle: .alert)
            let attributedString = Utilities.alertAttribute(titleString: "Export Not Allowed.")
            alert.setValue(attributedString, forKey: "attributedTitle")
            let okAct = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            okAct.setValue(alertbtnColor, forKey: "titleTextColor")
            
            alert.addAction(okAct)
            present(alert,animated: true,completion: nil)
        }
}
    
func isAddQuoteCharater(_ string: String) -> Bool {
    //        var isYes: Bool = false
    //        if string.range(of: ",") != NSNotFound || string.rangeOf("\n")?.lowerBound != NSNotFound || (string as NSString).rangeOf("\"").lo != NSNotFound {
    //            isYes = true
    //        }
            return true
}
    
    //MARK:- BUTTon Action MEthod...
    @IBAction func btnTeamMemberAction(_ sender: Any) {
        StringPickerPopOver.appearFrom(originView: sender as! UIView, baseView: btnTeamMember, baseViewController: self, title: "Select Member", choices: arrTeamMamber , initialRow:selectedIndexForTeamMember, doneAction: { selectedRow, selectedString in
            print("row \(selectedRow) : \(selectedString)")
            
            self.selectedIndexForTeamMember = selectedRow
            self.selectedUserID = self.arrTeamCreatedTiemStemp[self.selectedIndexForTeamMember]
            self.lblTeamMember.text = selectedString
            
            print("For Member = \(self.selectedIndexForTeamMember)")
            print("Select Member id = \(self.selectedIDForTeamMember)")
            
            self.callWebServiceForScheduledTask(selectedId: self.selectedUserID, typeId: self.durationID, statusId: self.statusID)
            self.FilterView.isHidden = true
        },cancelAction: { print("cancel")})
        
    }

    @IBAction func btnDurationAction(_ sender: Any) {
        StringPickerPopOver.appearFrom(originView: sender as! UIView, baseView: btnDuration, baseViewController: self, title: "Select Duration", choices: arrWithinEvents.duration , initialRow:selectedIndexForDuration, doneAction: { selectedRow, selectedString in
            print("row \(selectedRow) : \(selectedString)")
            
            self.selectedIndexForDuration = selectedRow
            self.durationID = arrWithinEvents.typeID[self.selectedIndexForDuration]
            self.lblDuration.text = selectedString
            
            print("selectUserid \(self.selectedUserID) and Durationid \(self.durationID) and typeid \(self.statusID)")
            
            self.callWebServiceForScheduledTask(selectedId: self.selectedUserID, typeId: self.durationID, statusId: self.statusID)
            self.FilterView.isHidden = true
            },cancelAction: { print("cancel")})
    }
    
    @IBAction func btnStatusAction(_ sender: Any) {
        StringPickerPopOver.appearFrom(originView: sender as! UIView, baseView: btnStatus, baseViewController: self, title: "Select Duration", choices: arrStatus.StatusName , initialRow:selectedIndexForStatus, doneAction: { selectedRow, selectedString in
            print("row \(selectedRow) : \(selectedString)")
            
            self.selectedIndexForStatus = selectedRow
            self.statusID = arrStatus.StatusId[self.selectedIndexForStatus]
            self.lblStatus.text = selectedString
            
            print("selectUserid \(self.selectedUserID) and Durationid \(self.durationID) and typeid \(self.statusID)")
            
            self.callWebServiceForScheduledTask(selectedId: self.selectedUserID, typeId: self.durationID, statusId: self.statusID)
            self.FilterView.isHidden = true
            },cancelAction: { print("cancel")})
    }
    @IBAction func btnEditclicked(_ sender: Any) {
        
        let vcCreateList = StoryBoard.MyLead.instantiateViewController(withIdentifier: "ScheduleTaskVC") as! ScheduleTaskVC
//        let dictObj = self.arrTaskData[self.selectedLeadID]
        vcCreateList.strType = "E"
        vcCreateList.selectedEventObj = selectedEventObj
        vcCreateList.isEdit = true
        let task = self.arrTaskList[self.selectedRow] as! TaskList
        vcCreateList.taskList = task
        self.navigationController?.pushViewController(vcCreateList, animated: true)
    }
    
    
    
    @IBAction func btnDeleteCliked(_ sender: Any) {
        
                    // create the alert
                    let alert = UIAlertController(title: "Mleads", message: "Are you sure, you want to delete this task?", preferredStyle: UIAlertController.Style.alert)

                           // add the actions (buttons)
                    alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { (Alert) in
                        print("Delete")
                        
//                        let timestamp = Date.currentTimeStamp
                        let task = self.arrTaskList[self.selectedRow] as! TaskList

                        let dict = [
                            "userId" : objLoginUserDetail.createTimeStamp! as AnyObject,
                            "eventId" : task.eventId!,
                            "created_timestamp": task.created_timestamp!
                            ] as [String : AnyObject]
                        
                        //Progress Bar Loding...
                        let size = CGSize(width: 30, height: 30)
                        self.startAnimating(size, message: "Loading...", type: NVActivityIndicatorType(rawValue: 29))
                        
                        self.webService.doRequestPost(DELETE_TASK_API_URL, params: dict, key: "deleteTask", delegate: self)
                        
                        
                    }))
                    alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))

                    // show the alert
                    self.present(alert, animated: true, completion: nil)
    }
}

//MARK:- TableView Delegate And DataSource Method...
extension ScheduledTasksViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrTaskList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath)
        
        let lblEventName:UILabel = cell.contentView.viewWithTag(101) as! UILabel
        let lblLocation:UILabel = cell.contentView.viewWithTag(102) as! UILabel
        let lblCity:UILabel = cell.contentView.viewWithTag(103) as! UILabel
        let lbldate:UILabel = cell.contentView.viewWithTag(104) as! UILabel
        
        let taskList = arrTaskList[indexPath.row] as! TaskList
        
        if selectedRow == indexPath.row{
            cell.contentView.viewWithTag(110)?.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
        }else{
            cell.contentView.viewWithTag(110)?.backgroundColor = UIColor.white
        }
        
        lblEventName.text = taskList.subject
        lblLocation.text = taskList.startDate
        lblCity.text = taskList.endDate
//        ["In-Progress", "Completed", "Waiting For", "Deferred"]
        switch taskList.statusId {
        case "1":
            lbldate.text = "In-Progress"
        case "2":
            lbldate.text = "Completed"
        case "3":
            lbldate.text = "Waiting For"
        case "4":
            lbldate.text = "Deferred"
        default:
            print("")
        }
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRow = indexPath.row
        heightConstantBottomView.constant = 50
        self.view.layoutIfNeeded()
        tblScheduledTasks.reloadData()
        
//        let tempTaskList = arrTaskList[indexPath.row] as! TaskList
//
//        print(tempTaskList.subject!)
//
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ScheduledTaskDetailViewController") as! ScheduledTaskDetailViewController
//        vc.objTaskList = tempTaskList
//        vc.timeStamp = tempTaskList.created_timestamp!
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 120
//    }
}

//MARK:- Webservices Delegate Method...
extension ScheduledTasksViewController:WebServiceDelegate{
    func webServiceResponceSuccess(_ response: Data, apiKey: String) {
        stopAnimating()
        
        if apiKey == GET_ADD_TEAM_MEMBER_LIST
        {
            let result = handleWebService.handleGetAddTeamMember(response)
            
            if result.Status
            {
                
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
                }
                arrTeamMamber.append("All")
                arrTeamCreatedTiemStemp.append("100")
                if arrTeamCreatedTiemStemp.contains(objLoginUserDetail.createTimeStamp!)
                {
                    selectedIndexForTeamMember = arrTeamCreatedTiemStemp.index(of: objLoginUserDetail.createTimeStamp!)!
                }
                lblTeamMember.text = arrTeamMamber[selectedIndexForTeamMember]
                selectedUserID = arrTeamCreatedTiemStemp[selectedIndexForTeamMember]
                
                if arrWithinEvents.duration.contains("Today")
                {
                    selectedIndexForDuration = arrWithinEvents.duration.index(of: "Today")!
                    durationID = arrWithinEvents.typeID[selectedIndexForDuration]
                    lblDuration.text = arrWithinEvents.duration[selectedIndexForDuration]
                }
                
                if arrStatus.StatusName.contains("In-Progress")
                {
                    selectedIndexForStatus = arrStatus.StatusName.index(of: "In-Progress")!
                    statusID = arrStatus.StatusId[selectedIndexForStatus]
                }
                lblStatus.text = arrStatus.StatusName[selectedIndexForStatus]
                print("selectUserid \(selectedUserID) and Durationid \(durationID) and typeid \(statusID)")
                
                self.callWebServiceForScheduledTask(selectedId: self.selectedUserID, typeId: self.durationID, statusId: self.statusID)
            }
        }
        
        else if apiKey == GET_SCHEDULED_TASKS_URL{
             let result = handleWebService.handleGetSchedualTasksList(response)
            if result.Status
            {
                arrTaskList.removeAllObjects()
                arrTaskList = result.TaskList
                if arrTaskList.count == 0
                {
                    arrTaskList.removeAllObjects()
                    tblScheduledTasks.reloadData()
                    stopAnimating()
                }
                else
                {
                    tblScheduledTasks.reloadData()
                    stopAnimating()
                }
            }
        }
        
        else if apiKey == Get_EmailTamplate_API
        {
            let result  = handleWebService.getEmailTemplate(response)
            stopAnimating()
            let mailComposeViewController = configuredMailComposeViewController(reslt: result)
            if MFMailComposeViewController.canSendMail() {
                self.present(mailComposeViewController, animated: true, completion: nil)
            } else {
                self.showSendMailErrorAlert()
            }
            
        }
        else if apiKey == GET_TASK_LIST_API_URL
        {
            let result = handleWebService.handleGetTaskList(response)
            if result.Status
            {
                arrTaskList = result.TaskList
                if arrTaskList.count == 0
                {
                    arrTaskList.removeAllObjects()
                    tblScheduledTasks.reloadData()
                    stopAnimating()
                }
                else
                {
                    tblScheduledTasks.reloadData()
                    stopAnimating()
                }
            }
        }
        else if apiKey == DELETE_TASK_API_URL{
            
            let json = JSON(data: response)
            print(json)

            if json["deleteTask"]["status"].string == "YES"
            {
                arrTaskList.removeObject(at: selectedRow)
                selectedRow = -1
                self.heightConstantBottomView.constant = 0
                self.view.layoutIfNeeded()
                if self.arrTaskList.count == 0{
                    self.tblScheduledTasks.isHidden = true
//                    self.lblNoDataFound.isHidden = false
                }else{
                    self.tblScheduledTasks.isHidden = false
//                    self.lblNoDataFound.isHidden = true
                }
                self.tblScheduledTasks.reloadData()
                
                
//                if json["getTaskList"]["taskList"] != nil{
//                    if json["getTaskList"]["taskList"].array?.count ?? 0 > 0{
//                        let arrData = json["getTaskList"]["taskList"]
//                        for i in 0..<arrData.count
//                        {
//                            let arrEvent = arrData[i]
//                            self.arrTaskData.append(arrEvent.dictionaryObject!)
//                        }
//                        self.tblTaskList.reloadData()
//                    }
//
//                }
//
                print("TRUE")
            }else{
                print("FALSE")
            }
            
        }
        
    }
    
    func webServiceResponceFailure(_ errorMessage: String) {
        stopAnimating()
        
        let alert = UIAlertController(title: "", message: errorMessage,  preferredStyle: .alert)
        let attributedString = Utilities.alertAttribute(titleString: "Internet Not Access.")
        alert.setValue(attributedString, forKey: "attributedTitle")
        let okAct = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        okAct.setValue(alertbtnColor, forKey: "titleTextColor")
        
        alert.addAction(okAct)
        present(alert,animated: true,completion: nil)
    }

}

//MARK:- Export Mail Delegate Method...
extension ScheduledTasksViewController: MFMailComposeViewControllerDelegate{
    
    func configuredMailComposeViewController(reslt : JSON) -> MFMailComposeViewController {
         let mailComposerVC = MFMailComposeViewController()
                mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
                let mailto = objLoginUserDetail.email
//                mailComposerVC.setToRecipients([mailto!])
                var subject = reslt["template_subject"].string
                subject = subject?.replacingOccurrences(of: "###USER_NAME###", with: self.lblTeamMember.text!)
                mailComposerVC.setSubject(subject! as String)
                var messagebody = reslt["template_body"].string
                messagebody = messagebody?.replacingOccurrences(of: "&amp;", with: "&")
                messagebody = messagebody?.replacingOccurrences(of: "&lt;", with: "<")
                messagebody = messagebody?.replacingOccurrences(of: "&gt;", with: ">")
                messagebody = messagebody?.replacingOccurrences(of: "&apos;", with: "'")
                messagebody = messagebody?.replacingOccurrences(of: "&quot;", with: "\"")
                messagebody = messagebody?.replacingOccurrences(of: "###FIRST_NAME###", with: objLoginUserDetail.firstName!)
                messagebody = messagebody?.replacingOccurrences(of: "\n", with: "<br />")
                messagebody = messagebody?.replacingOccurrences(of: "\r", with: "")
                messagebody = messagebody?.replacingOccurrences(of: "\t", with: "")
                
                mailComposerVC.setMessageBody(messagebody! , isHTML: true)
                var csvData: NSData?
                let documentdirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
              //  var fullname = self.lblTeamMember.text?.components(separatedBy: " ")
                let name = self.lblTeamMember.text!
                print(name)
                var path = String()
        //        var firstname = String()
        //        var lastname = String()
                
                path = "\(documentdirectory)/\(objLoginUserDetail.createTimeStamp!)/\(name)_TaskList.csv"
                print(path)
        //        if fullname! == ["All"]
        //        {
        //            path = "\(documentdirectory)/\(objLoginUserDetail.LoginUserCreatedTimeStamp!)/\((fullname?[0])!)_TaskList.csv"
        //        }else{
        //         firstname = fullname![0]
        //         lastname = fullname![1]
        //        path = "\(documentdirectory)/\(objLoginUserDetail.LoginUserCreatedTimeStamp!)/\("\(firstname)-\(lastname)")_TaskList.csv"
        //        print(path)
        //        }
                if FileManager.default.fileExists(atPath: path) {
                    
                   // csvData = path.data(using: .utf8) as NSData?
                    csvData = exportedLeadsData.data(using: .utf8) as NSData?
                    mailComposerVC.addAttachmentData(csvData! as Data, mimeType: "text/csv", fileName: "\("\(name)")_TaskList.csv")
        //            if fullname! == ["All"]
        //            {
        //                //mailComposerVC.addAttachmentData(csvData! as Data, mimeType: "text/csv", fileName: "\("\(fullname!)")_TaskList.csv")
        //                mailComposerVC.addAttachmentData(csvData! as Data, mimeType: "text/csv", fileName: "\((fullname?[0])!)_TaskList.csv")
        //            }else{
        //            mailComposerVC.addAttachmentData(csvData! as Data, mimeType: "text/csv", fileName: "\("\(firstname)-\(lastname)")_TaskList.csv")
        //            }
                }
        return mailComposerVC
    }
    
     func showSendMailErrorAlert() {
            let alert = UIAlertController(title: "", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.",  preferredStyle: .alert)
            let attributedString = Utilities.alertAttribute(titleString: "Could Not Send Email")
            alert.setValue(attributedString, forKey: "attributedTitle")
            let okAct = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            okAct.setValue(alertbtnColor, forKey: "titleTextColor")
            
            alert.addAction(okAct)
            present(alert,animated: true,completion: nil)
        }
        
        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            
            switch (result)
            {
            case .cancelled:
                print("Mail cancelled");
                break;
            case .saved:
                print("Mail saved");
                break;
            case .sent:
                print("Mail sent");
                
                let alert = UIAlertController(title: "", message: "Email sent successfully.",  preferredStyle: .alert)
                let attributedString = Utilities.alertAttribute(titleString: "Success")
                alert.setValue(attributedString, forKey: "attributedTitle")
                let okAct = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                
                okAct.setValue(alertbtnColor, forKey: "titleTextColor")
                
                alert.addAction(okAct)
                present(alert,animated: true,completion: nil)

                break;
            case .failed:
                print("Mail sent failure:, \(error?.localizedDescription)");
                
                let alert = UIAlertController(title: "", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.",  preferredStyle: .alert)
                let attributedString = Utilities.alertAttribute(titleString: "Could Not Send Email")
                alert.setValue(attributedString, forKey: "attributedTitle")
                let okAct = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                
                okAct.setValue(alertbtnColor, forKey: "titleTextColor")
                
                alert.addAction(okAct)
                present(alert,animated: true,completion: nil)
                
                break;
    //        default:
    //            break;
            }
            controller.dismiss(animated: true, completion: nil)
        }
}
