//
//  SalesOpportunityListViewController.swift
//  NewMleadsEnterprise
//
//  Created by sam rathod on 04/12/21.
//  Copyright © 2021 com.Tri-Force.MLeadsEnterprise. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class SalesOpportunityListViewController:UIViewController, NVActivityIndicatorViewable {

    var objLeadList = LeadList()
    let webService : WebService = WebService()
    var handleWebService : HandleWebService = HandleWebService()
    var appdelegate = AppDelegate()
    var arrTaskData = [[String:Any]]()

    @IBOutlet weak var tblTaskList: UITableView!
    var delegateSalesOpportunity:passLeadSalesOpportunityDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Sales Opportunity List"
        // Do any additional setup after loading the view.
        
        let btnCreateTask = UIBarButtonItem(image: UIImage.init(named: "addnew") , style: .plain, target: self, action: #selector(self.btnCreateTask(_:)))
        btnCreateTask.tintColor = .white
        navigationItem.rightBarButtonItems = [ btnCreateTask]
        callSalesListAPI()
        
    }
    func callSalesListAPI() {
        
        let dict = [
            "leadId" : objLeadList.leadId!,
            "Id" : "",
            "type" : "List"
            ] as [String : AnyObject]
        
        

        //Progress Bar Loding...
        let size = CGSize(width: 30, height: 30)
        startAnimating(size, message: "Loading...", type: NVActivityIndicatorType(rawValue: 29))
        
        webService.doRequestPost(GET_SALESOPPORTUNITY_LIST_API_URL, params: dict, key: "leadDetail", delegate: self)
        
        
    }
    
    @objc func btnCreateTask(_ sender:UIButton) {
        // CreateSetupMeetingVC
       
        
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "SalesOpportunityViewController") as! SalesOpportunityViewController
        vc.delegateSalesOpportunity = self
        navigationController?.pushViewController(vc, animated: true)
    }

}
extension SalesOpportunityListViewController : passLeadSalesOpportunityDelegate{
    func passSalesOpportunity(strSalesName: String, strTarget: String, strPeriods: String, strTargetFuture: String, strTargetClosingDate: String, strProbabilityClosing: String, strRPFDate: String, strStrStatus: String) {
            
//        self.strSalesName = strSalesName
//        self.strTarget = strTarget
//        self.strPeriods = strPeriods
//        self.strTargetfuture = strTargetFuture
//        self.strClosingDate = strTargetClosingDate
//        self.strClosingPercentage = strProbabilityClosing
//        self.strRPFDate = strRPFDate
//        self.strStatus = strStrStatus
    }
}
//MARK:- Webservices Method...
extension SalesOpportunityListViewController:WebServiceDelegate{
    
    func webServiceResponceSuccess(_ response: Data, apiKey: String) {
        stopAnimating()
        
        if apiKey == GET_SALESOPPORTUNITY_LIST_API_URL
        {
            let json = JSON(data: response)
            print(json)
            if json["getOpportunity"]["status"].string == "YES"
            {
                if json["getOpportunity"]["leadDetail"] != nil{
                    if json["getOpportunity"]["leadDetail"].array?.count ?? 0 > 0{
                        let arrData = json["getOpportunity"]["leadDetail"]
                        for i in 0..<arrData.count
                        {
                            let arrEvent = arrData[i]
                            self.arrTaskData.append(arrEvent.dictionaryObject!)
                        }
                        self.tblTaskList.reloadData()
                    }

                }
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
extension SalesOpportunityListViewController : UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrTaskData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let objevnt:event
//        let objevent:EventDetail
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath)
        
        let lblsubject:UILabel = cell.contentView.viewWithTag(101) as! UILabel
        let lblLocation:UILabel = cell.contentView.viewWithTag(102) as! UILabel
        let lblDate:UILabel = cell.contentView.viewWithTag(103) as! UILabel
        let lblstartTime:UILabel = cell.contentView.viewWithTag(104) as! UILabel
       

        let dict = arrTaskData[indexPath.row]
        
        lblsubject.text = dict["opportunity_name"] as? String ?? ""
        lblLocation.text = dict["targetAmount"] as? String ?? ""
        lblDate.text = dict["nextStepDate"] as? String ?? ""
        lblstartTime.text = dict["periods"] as? String ?? ""
        
        
        /*
         [{"meetingId":"1436","subject":"Testing Meeting","location":"Ahmedabad","startTime":"02:06","endTime":"13:06","meetingDt":"10\/07\/2021","note":"","leads":"1633018600","leadFirstName":"End","leadLastName":"Date","leadEmail":"data@gmail.ckm","createdDt":"2021-10-06 13:37:23","updatedDt":"","created_timestamp":"1633509444","updated_timestamp":"","reminder":"08:00"}]}
         */
        
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
