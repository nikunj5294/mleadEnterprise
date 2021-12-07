//
//  LeadFolllowUpsViewController.swift
//  NewMleadsEnterprise
//
//  Created by sam rathod on 04/12/21.
//  Copyright © 2021 com.Tri-Force.MLeadsEnterprise. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class LeadFolllowUpsViewController: UIViewController,NVActivityIndicatorViewable {

    var objLeadList = LeadList()
    let webService : WebService = WebService()
    var handleWebService : HandleWebService = HandleWebService()
    var appdelegate = AppDelegate()
    var arrTaskData = [[String:Any]]()
    var arrDropDownData = [[String:Any]]()
    var arrStringDropdown = NSMutableArray()
    @IBOutlet weak var tblTaskList: UITableView!
    
    @IBOutlet weak var heightConstantBottomView: NSLayoutConstraint!
    
    @IBOutlet weak var lblNoDataFound: UILabel!
    @IBOutlet weak var txtLeadname: UITextField!
    @IBOutlet weak var txtType: UITextField!
  
    var selectedLeadStatus = 0
    var selectedActionLeadStatus:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Follow-Up"
        // Do any additional setup after loading the view.
        
        txtLeadname.text = "\(objLeadList.firstName!) \(objLeadList.lastName!)"
        
        callgetLeadFollowupAPI()
    }
    
    
    func callgetLeadFollowupAPI() {
        
        let dict = [
            "leadId" : objLeadList.leadId!,
            "userId" : objLoginUserDetail.createTimeStamp! as AnyObject,
            "type" : "followuplist"
            ] as [String : AnyObject]
        
        //Progress Bar Loding...
        let size = CGSize(width: 30, height: 30)
        startAnimating(size, message: "Loading...", type: NVActivityIndicatorType(rawValue: 29))
        
        webService.doRequestPost(getLeadFollowup_LIST_API_URL, params: dict, key: "getLeadFollowup", delegate: self)
    }
    
    @IBAction func btnTypeClicked(_ sender: Any) {
        
        self.view.endEditing(true)
        
        StringPickerPopOver.appearFrom(originView: sender as! UIView, baseView: self.view , baseViewController: self, title: "Select Status", choices: arrStringDropdown as! [String] , initialRow:selectedLeadStatus, doneAction: { selectedRow, selectedString in
            print("row \(selectedRow) : \(selectedString)")
            
            self.txtType.text = selectedString
            self.selectedLeadStatus = selectedRow
            
            let arrEvent = self.arrDropDownData[selectedRow]
            self.selectedActionLeadStatus = (arrEvent["id"] as? String)!
            
            self.callgetLeadListFollowupAPI()
            },cancelAction: { print("cancel")})
    }
    
    func callgetLeadListFollowupAPI() {
        
        let dict = [
            "leadId" : objLeadList.leadId!,
            "userId" : objLoginUserDetail.createTimeStamp! as AnyObject,
            "type" : "followuplist",
            "followupActionId" : "\(self.selectedActionLeadStatus)"
            ] as [String : AnyObject]
    
        //Progress Bar Loding...
        let size = CGSize(width: 30, height: 30)
        startAnimating(size, message: "Loading...", type: NVActivityIndicatorType(rawValue: 29))
        
        webService.doRequestPost(getLeadFollowup_LIST_API_URL, params: dict, key: "getLeadFollowup", delegate: self)
    }
    
    @IBAction func btnLeadClicked(_ sender: Any) {
        
    }
    
}

//MARK:- Webservices Method...
extension LeadFolllowUpsViewController:WebServiceDelegate{
    
    func webServiceResponceSuccess(_ response: Data, apiKey: String) {
        stopAnimating()
        
        if apiKey == getLeadFollowup_LIST_API_URL
        {
            let json = JSON(data: response)
            print(json)
            if json["getLeadFollowup"]["status"].string == "YES"
            {
                if json["getLeadFollowup"]["followuplist"] != nil{
                    if json["getLeadFollowup"]["followuplist"].array?.count ?? 0 > 0{
                        let arrData = json["getLeadFollowup"]["followuplist"]
                        
                        arrDropDownData.removeAll()
                        arrStringDropdown.removeAllObjects()
                        
                        for i in 0..<arrData.count
                        {
                            let arrEvent = arrData[i]
                            self.arrDropDownData.append(arrEvent.dictionaryObject!)
                            self.arrStringDropdown.add(arrEvent["name"].string ?? "")
                            print(arrStringDropdown)
                        }
                        self.tblTaskList.reloadData()
                    }

                }
            }else{
                print("FALSE")
            }
            let result = handleWebService.handleGetEventListWithin(response)

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
extension LeadFolllowUpsViewController : UITableViewDelegate,UITableViewDataSource
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
        
//        if selectedLeadID == indexPath.row{
//            cell.contentView.viewWithTag(110)?.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
//        }else{
//            cell.contentView.viewWithTag(110)?.backgroundColor = UIColor.white
//        }
        
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
        
      //  selectedLeadID = indexPath.row
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
