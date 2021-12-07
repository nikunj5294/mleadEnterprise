
import UIKit
import NVActivityIndicatorView

class CreateTaskListing: UIViewController, NVActivityIndicatorViewable  {

    var objLeadList = LeadList()
    let webService : WebService = WebService()
    var handleWebService : HandleWebService = HandleWebService()
    var appdelegate = AppDelegate()
    var arrTaskData = [[String:Any]]()
    @IBOutlet weak var tblTaskList: UITableView!
    
    @IBOutlet weak var heightConstantBottomView: NSLayoutConstraint!
    
    @IBOutlet weak var lblNoDataFound: UILabel!
    
    
    var selectedLeadID = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "Scheduled Tasks"
        
        let btnCreateTask = UIBarButtonItem(image: UIImage.init(named: "addnew") , style: .plain, target: self, action: #selector(self.btnCreateTask(_:)))
        btnCreateTask.tintColor = .white
        navigationItem.rightBarButtonItems = [ btnCreateTask]
        
        callTaskListAPI()
        NotificationCenter.default.addObserver(self, selector: #selector(self.callTaskListAPI), name: Notification.Name("callRefreshTaskListAPI"), object: nil)
        heightConstantBottomView.constant = 0
        self.view.layoutIfNeeded()
        tblTaskList.tableFooterView = UIView()
        
    }
    
    @objc func btnCreateTask(_ sender:UIButton) {
        
        let vcCreateList = StoryBoard.MyLead.instantiateViewController(withIdentifier: "ScheduleTaskVC") as! ScheduleTaskVC
        vcCreateList.objLeadList = objLeadList
        self.navigationController?.pushViewController(vcCreateList, animated: true)
    }
    
    @objc func callTaskListAPI() {
        let dict = [
            "userId" : objLoginUserDetail.createTimeStamp! as AnyObject,
            "leadId" : objLeadList.leadId!,
//            "eventId" : objLeadList.eventId!,
            "type" : "L"
        ] as [String : AnyObject]
        
        //Progress Bar Loding...
        let size = CGSize(width: 30, height: 30)
        startAnimating(size, message: "Loading...", type: NVActivityIndicatorType(rawValue: 29))
        
        webService.doRequestPost(GET_TASK_LIST_API_URL, params: dict, key: "taskList", delegate: self)
    }
    
    
    @IBAction func btnEditclicked(_ sender: Any) {
        
        let vcCreateList = StoryBoard.MyLead.instantiateViewController(withIdentifier: "ScheduleTaskVC") as! ScheduleTaskVC
        let dictObj = self.arrTaskData[self.selectedLeadID]
        vcCreateList.isEdit = true
        vcCreateList.taskData = dictObj
        self.navigationController?.pushViewController(vcCreateList, animated: true)
    }
    
    @IBAction func btnDeleteCliked(_ sender: Any) {
        
                    // create the alert
                    let alert = UIAlertController(title: "Mleads", message: "Are you sure, you want to delete this task?", preferredStyle: UIAlertController.Style.alert)

                           // add the actions (buttons)
                    alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { (Alert) in
                        print("Delete")
                        
//                        let timestamp = Date.currentTimeStamp
                        let dictObj = self.arrTaskData[self.selectedLeadID]

                        let dict = [
                            "userId" : objLoginUserDetail.createTimeStamp! as AnyObject,
                            "leadId" : dictObj["leadId"] as! String,
                            "created_timestamp": dictObj["created_timestamp"] as! String
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


//MARK:- Webservices Method...
extension CreateTaskListing:WebServiceDelegate{
    
    func webServiceResponceSuccess(_ response: Data, apiKey: String) {
        stopAnimating()
        
        if apiKey == GET_TASK_LIST_API_URL
        {
            let json = JSON(data: response)
            print(json)
            self.arrTaskData.removeAll()
            if json["getTaskList"]["status"].string == "YES"
            {
                if json["getTaskList"]["taskList"] != nil{
                    if json["getTaskList"]["taskList"].array?.count ?? 0 > 0{
                        let arrData = json["getTaskList"]["taskList"]
                        for i in 0..<arrData.count
                        {
                            let arrEvent = arrData[i]
                            self.arrTaskData.append(arrEvent.dictionaryObject!)
                        }
                        if self.arrTaskData.count == 0{
                            self.tblTaskList.isHidden = true
                            self.lblNoDataFound.isHidden = false
                        }else{
                            self.tblTaskList.isHidden = false
                            self.lblNoDataFound.isHidden = true
                        }
                        self.tblTaskList.reloadData()
                    }

                }
                
                print("TRUE")
            }else{
                print("FALSE")
            }
            let result = handleWebService.handleGetEventListWithin(response)
//        if result.Status{
//            print(result.Status)
//            print(result.teamMember)
//            let arrTempN = NSMutableArray()
//            let arrTempTeamName = NSMutableArray()
//            let arrTempExportAllowed = NSMutableArray()
//
//            }
        }else if apiKey == DELETE_TASK_API_URL{
            
            let json = JSON(data: response)
            print(json)

            if json["deleteTask"]["status"].string == "YES"
            {
                arrTaskData.remove(at: selectedLeadID)
                selectedLeadID = -1
                self.heightConstantBottomView.constant = 0
                self.view.layoutIfNeeded()
                if self.arrTaskData.count == 0{
                    self.tblTaskList.isHidden = true
                    self.lblNoDataFound.isHidden = false
                }else{
                    self.tblTaskList.isHidden = false
                    self.lblNoDataFound.isHidden = true
                }
                self.tblTaskList.reloadData()
                
                
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
        let attributedString = Utilities.alertAttribute(titleString: "")
        alert.setValue(attributedString, forKey: "attributedTitle")
        let okAct = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        okAct.setValue(alertbtnColor, forKey: "titleTextColor")
        
        alert.addAction(okAct)
        present(alert,animated: true,completion: nil)
    }
}

//MARK:-TableView DataSource & Delegate Method...
extension CreateTaskListing : UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrTaskData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let objevnt:event
//        let objevent:EventDetail
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath)
        
        let lblEventName:UILabel = cell.contentView.viewWithTag(101) as! UILabel
        let lblLocation:UILabel = cell.contentView.viewWithTag(102) as! UILabel
        let lblCity:UILabel = cell.contentView.viewWithTag(103) as! UILabel
        let lbldate:UILabel = cell.contentView.viewWithTag(104) as! UILabel
        
        let dict = arrTaskData[indexPath.row]
        
        if selectedLeadID == indexPath.row{
            cell.contentView.viewWithTag(110)?.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
        }else{
            cell.contentView.viewWithTag(110)?.backgroundColor = UIColor.white
        }
        
        lblEventName.text = dict["subject"] as? String ?? ""
        lblLocation.text = dict["startDt"] as? String ?? ""
        lblCity.text = dict["endDt"] as? String ?? ""
//        ["In-Progress", "Completed", "Waiting For", "Deferred"]
        switch dict["statusId"] as? String ?? "" {
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
        
        
        //27/09/2019 Change
        //objevnt = arrEventList[indexPath.row] as! event
//        objevent = arrEventList[indexPath.row] as! EventDetail
//
//        lblEventName.text = objevent.eventName
//        lblLocation.text = objevent.location
//        lblCity.text = objevent.city
//
//        let strDate = Utilities.dateFormatter(Date: objevent.eventDate!, FromString: "yyyy-MM-dd", ToString: "MM/dd/yyyy")
//        lbldate.text = strDate
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedLeadID = indexPath.row
        heightConstantBottomView.constant = 50
        self.view.layoutIfNeeded()
        tblTaskList.reloadData()
//        let selectedEvent = arrEventList[indexPath.row] as! EventDetail
//
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EventsDetailViewController") as! EventsDetailViewController
//
////        vc.eventID = selectedEvent.eventid!
////        vc.isViewEvent = true
//        vc.objEventDetail = selectedEvent
        
//        vc.isMyEvent = true
//        vc.isTaskView = isTaskView
//        vc.isTaskCreate = isTaskCreate
//        vc.isAttendee = isAttendee
//        vc.isMessagingToAll = isMessagingToAll
//        vc.isEventAgenda = isEventAgenda
//        vc.isbadgeEntryCheck = isbadgeEntryCheck
//        vc.isEventSponsors = isEventSponsors
//        vc.isPlaceNearBy = isPlaceNearBy
//        vc.isSendAlert = isSendAlert
//        vc.isBesocial = isBesocial
//        vc.userType = userType
        
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}
