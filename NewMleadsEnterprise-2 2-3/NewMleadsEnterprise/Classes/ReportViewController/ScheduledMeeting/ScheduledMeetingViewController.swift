//
//  ScheduledMeetingViewController.swift
//  NewMleadsEnterprise
//
//  Created by Triforce New Mac on 01/11/19.
//  Copyright © 2019 com.Tri-Force.MLeadsEnterprise. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import MessageUI

class ScheduledMeetingViewController: UIViewController, NVActivityIndicatorViewable{

    @IBOutlet var tblSchedulMeeting: UITableView!
    @IBOutlet var FilterView: UIView!
    
    @IBOutlet var btnTeamMember: UIButton!
    @IBOutlet var lblTeamMember: UILabel!
    
    
    @IBOutlet var btnDuration: UIButton!
    @IBOutlet var lblDuration: UILabel!
    
    var arrTaskList = NSMutableArray()
    
    var arrTeamMamber = [String]()
    var selectedIDForTeamMember = String()
    var arrTeamCreatedTiemStemp = [String]()
    var selectedIndexForTeamMember = Int()
    var selectedStringForTeamMamber = String()
    
    var selectedIndexForDuration = Int()
    
    var selectedUserID = String()
    var durationID = String()
    
    var exportedLeadsData = String()
    var currentDate_Time = String()
    var statusArr = NSMutableArray()
    
    let webService : WebService = WebService()
    var handleWebService : HandleWebService = HandleWebService()
    var appdelegate = AppDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Scheduled Meeting"
        self.findHamburguerViewController()?.gestureEnabled = false
        let filter = UIBarButtonItem(image:#imageLiteral(resourceName: "filter"), style: .plain, target: self, action: #selector(self.btnFilter(_:)))//#selector(addTapped)
        let export = UIBarButtonItem(image:#imageLiteral(resourceName: "Icon-40"), style: .plain, target: self, action: #selector(btnExportTapped))
        
        let fixedSpace = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        fixedSpace.width = -26.0
               
        self.navigationItem.rightBarButtonItems = [filter,fixedSpace,export]

        self.FilterView.isHidden = true
        
        tblSchedulMeeting.rowHeight = 160
        
        //MARK: WEB SERVICES CALL TEAM MEMBER LIST...
        let param:[String : AnyObject] = ["userId":objLoginUserDetail.createTimeStamp! as AnyObject, "hierarchy_type":"1" as AnyObject]
        
        let size = CGSize(width: 30, height: 30)
        startAnimating(size, message: "Loading...", type: NVActivityIndicatorType(rawValue: 29))
        
        webService.doRequestPost(GET_ADD_TEAM_MEMBER_LIST, params: param, key: "user", delegate: self)
        
    }

    //MARK:- WEBServices Function in Schedual Meeting Task....
    func callWebServiceForScheduledTask(selectedId:String,typeId:String)
    {
        var param: [String : Any] = [String : Any]()
        if typeId == "17"
        {
            param = ["userId":objLoginUserDetail.createTimeStamp!,
                     "selectedId":selectedId,
                     "typeId":"0"] as [String : Any]
        }else
        {
            param = ["userId":objLoginUserDetail.createTimeStamp!,
                     "selectedId":selectedId,
                     "typeId":typeId] as [String : Any]
        }
        //MARK: Progress Bar ....
        let size = CGSize(width: 30, height: 30)
        startAnimating(size, message: "Loading...", type: NVActivityIndicatorType(rawValue: 29))
        
        webService.doRequestPost(GET_SCHEDULED_MEETINGS_URL, params: param as [String : AnyObject], key: "meetingList", delegate: self)
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
                myExportContent += "List of Meeting.\nNote : *= Required Fields\nTeam Member Name*,Lead name*,Subject*,Location*,Date*,Start Time*,End Time*,Notes*\n"
                
                if arrTaskList.count > 0
                {
                    for k in 0..<arrTaskList.count
                    {
                        let myMeeting: MeetingList? = (arrTaskList[k] as? MeetingList)
                        // Team Member Name.
                        if ((myMeeting?.teamMember) != nil) && !((myMeeting?.teamMember?.isEmpty)!)
                        {
                            let name: String? = "\(myMeeting!.teamMember!)"
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
                        if !(myMeeting?.leadFirstName == "Lead") {
                            eventName = (myMeeting!.leadFirstName!)
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
                       /* var leadName: String = ""
                        if (myMeeting?.isWhere == "Lead") {
                            leadName = (myMeeting!.eventName!)
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
                        }*/
                        
                        //Add Location.
                        if (myMeeting!.location != nil) && (myMeeting?.location?.characters.count)! > 0 {
                            let location: String = "\(myMeeting!.location!)"
                            if self.isAddQuoteCharater(location) {
                                myExportContent += "\"\(location)\","
                            }else
                            {
                                myExportContent += "\(location),"
                                            
                            }
                        }else{
                            myExportContent += ","
                        }
                        
                        // Add Subject.
                        if (myMeeting!.subject != nil) && (myMeeting?.subject?.characters.count)! > 0 {
                            let subject: String = "\(myMeeting!.subject!)"
                            if self.isAddQuoteCharater(subject) {
                                myExportContent += "\"\(subject)\","
                            }else
                            {
                                myExportContent += "\(subject),"
                                            
                            }
                        }else{
                            myExportContent += ","
                        }
                        //Add Meeting Date:-
                        if (myMeeting!.meetingDate != nil) && (myMeeting?.meetingDate?.characters.count)! > 0 {
                            let startDate: String = "\(myMeeting!.meetingDate!)"
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
                        //Add Start Time For Meeting:
                        if  (myMeeting?.startTime?.characters.count)! > 0{
                        let endDate: String = "\(myMeeting!.startTime!)"
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
                        
                        //Add End Time for Meeting.
                        if  (myMeeting?.endTime?.characters.count)! > 0{
                        let endDate: String = "\(myMeeting!.endTime!)"
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
                        
                        //Add View Note
                            if (myMeeting?.note?.characters.count)! > 0 {
                                let strNote: String? = "\(myMeeting?.note)"
                                    if self.isAddQuoteCharater(strNote!) {
                                        myExportContent += "\"\(strNote!)\","
                                    }
                                    else {
                                        myExportContent += "\(strNote!),"
                                    }
                                }
                                else {
                                    myExportContent += ","
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
                            //let documentdirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
                            let documentdirectory = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
                            let documentPath = documentdirectory.appendingPathComponent(objLoginUserDetail.createTimeStamp!)
                            print(documentPath!.path)
                            let fullname = self.lblTeamMember.text?.components(separatedBy: " ")
                            print(fullname!)
                                
                            let name = self.lblTeamMember.text!
                            path = "\(documentPath!.path)/\(name)_MeetingList.csv"
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
                                    
                        let param = ["template_code":"SCHEDULE_MEETING_REPORT_MOBILE","userId":objLoginUserDetail.createTimeStamp!] as [String : String]
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
    //MARK:- Button Action...
    @IBAction func btnTeamMemberAction(_ sender: Any) {
        StringPickerPopOver.appearFrom(originView: sender as! UIView, baseView: btnTeamMember, baseViewController: self, title: "Select Member", choices: arrTeamMamber , initialRow:selectedIndexForTeamMember, doneAction: { selectedRow, selectedString in
            print("row \(selectedRow) : \(selectedString)")
            
            self.selectedIndexForTeamMember = selectedRow
            self.selectedUserID = self.arrTeamCreatedTiemStemp[self.selectedIndexForTeamMember]
            self.lblTeamMember.text = selectedString
            
            print("For Member = \(self.selectedIndexForTeamMember)")
            print("Select Member id = \(self.selectedIDForTeamMember)")
            
            self.callWebServiceForScheduledTask(selectedId: self.selectedUserID, typeId: self.durationID)
        },cancelAction: { print("cancel")})
    }
    
    @IBAction func btnDurationAction(_ sender: Any) {
        StringPickerPopOver.appearFrom(originView: sender as! UIView, baseView: btnDuration, baseViewController: self, title: "Select Duration", choices: arrWithinEvents.duration , initialRow:selectedIndexForDuration, doneAction: { selectedRow, selectedString in
            print("row \(selectedRow) : \(selectedString)")
            
            self.selectedIndexForDuration = selectedRow
            self.durationID = arrWithinEvents.typeID[self.selectedIndexForDuration]
            self.lblDuration.text = selectedString
            
            print("selectUserid \(self.selectedUserID) and Durationid \(self.durationID)")
            
            self.callWebServiceForScheduledTask(selectedId: self.selectedUserID, typeId: self.durationID)
            self.FilterView.isHidden = true
        },cancelAction: { print("cancel")})
    }
    
}

//MARK: UITableView Delegate And DataSource Method...
extension ScheduledMeetingViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrTaskList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let objTaskList : MeetingList
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        objTaskList = arrTaskList[indexPath.row] as! MeetingList
        
        let lblMeetingName:UILabel = cell.contentView.viewWithTag(101) as! UILabel
        let lblLocation:UILabel = cell.contentView.viewWithTag(102) as! UILabel
        let lblDate:UILabel = cell.contentView.viewWithTag(103) as! UILabel
        let lblStartTime:UILabel = cell.contentView.viewWithTag(104) as! UILabel
        let lblEndTime:UILabel = cell.contentView.viewWithTag(105) as! UILabel
        
        lblMeetingName.text = objTaskList.subject
        lblLocation.text = objTaskList.location
        lblDate.text = objTaskList.meetingDate
        lblStartTime.text = objTaskList.startTime
        lblEndTime.text = objTaskList.endTime
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tempTaskList = arrTaskList[indexPath.row] as! MeetingList
        
        print(tempTaskList.subject!)
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ScheduledMeetingDetailViewController") as! ScheduledMeetingDetailViewController
        vc.objTaskList = tempTaskList
        //vc.timeStamp = tempTaskList.created_timestamp!
        vc.timeStamp = tempTaskList.createdTimeStamp!
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
}

//MARK: Webservices Delegate Method...
extension ScheduledMeetingViewController: WebServiceDelegate{
    
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
                self.callWebServiceForScheduledTask(selectedId: self.selectedUserID, typeId: self.durationID)
            }
        }
        
        
        else if apiKey == GET_SCHEDULED_MEETINGS_URL{
            let result = handleWebService.handleGetSchedualMeetingTasksList(response)
            if result.Status
            {
                arrTaskList = result.MeetingList
                if arrTaskList.count == 0
                {
                    arrTaskList.removeAllObjects()
                    tblSchedulMeeting.reloadData()
                    stopAnimating()
                }
                else
                {
                    tblSchedulMeeting.reloadData()
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
extension ScheduledMeetingViewController: MFMailComposeViewControllerDelegate{
    
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
                
                path = "\(documentdirectory)/\(objLoginUserDetail.createTimeStamp!)/\(name)_MeetingList.csv"
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
                    mailComposerVC.addAttachmentData(csvData! as Data, mimeType: "text/csv", fileName: "\("\(name)")_MeetingList.csv")
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

