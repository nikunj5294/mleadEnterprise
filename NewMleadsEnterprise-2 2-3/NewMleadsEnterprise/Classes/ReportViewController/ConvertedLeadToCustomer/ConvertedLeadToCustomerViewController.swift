//
//  ConvertedLeadToCustomerViewController.swift
//  NewMleadsEnterprise
//
//  Created by Triforce New Mac on .
//  Copyright © 2019 com.Tri-Force.MLeadsEnterprise. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class ConvertedLeadToCustomerViewController: UIViewController,NVActivityIndicatorViewable {

    
    @IBOutlet var btnTeamMember: UIButton!
    @IBOutlet var lblTeamMember: UILabel!
    @IBOutlet var btnEventGroup: UIButton!
    @IBOutlet var lblEventGroup: UILabel!
    
    var arrTeamMamber = [String]()
    var selectedIndexForTeamMember = Int()
    var selectedUserID = String()
    var arrTeamCreatedTiemStemp = [String]()
    var selectedIDForTeamMember = String()
    var typeID = String()
    
    var arrEventList = NSMutableArray()
    var selectedIndexForEvent = Int()
    var selecteEventObj: EventDetail =  EventDetail()
    var selectedIndex: Int = 0
    
    let webService : WebService = WebService()
    var handleWebService : HandleWebService = HandleWebService()
    var appdelegate = AppDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Converted Lead to customer"
        
        //MARK: WEB SERVICES CALL TEAM MEMBER LIST...
        let param:[String : AnyObject] = ["userId":objLoginUserDetail.createTimeStamp! as AnyObject, "hierarchy_type":"1" as AnyObject]
        
        let size = CGSize(width: 30, height: 30)
        startAnimating(size, message: "Loading...", type: NVActivityIndicatorType(rawValue: 29))
        
        webService.doRequestPost(GET_ADD_TEAM_MEMBER_LIST, params: param, key: "user", delegate: self)
    }
    
    //MARK:- WEBServices Function in Userwise Event Lead List....
       func callWebServiceForEventLeadList(TypeId:String)
       {
           let param:[String : AnyObject] = ["userId":objLoginUserDetail.createTimeStamp! as AnyObject,
                                             "typeId":TypeId as AnyObject]
           //MARK: Progress Bar ....
           let size = CGSize(width: 30, height: 30)
           startAnimating(size, message: "Loading...", type: NVActivityIndicatorType(rawValue: 29))
               
           webService.doRequestPost(GET_EventList_For_User_Api, params: param as [String : AnyObject], key: "eventList", delegate: self)
       }
    
    //MARK:- Button ACtion Method...
    
    @IBAction func btnTeamMamberAction(_ sender: Any) {
        StringPickerPopOver.appearFrom(originView: sender as! UIView, baseView: btnTeamMember , baseViewController: self, title: "Select Member", choices: arrTeamMamber , initialRow:selectedIndexForTeamMember, doneAction: { selectedRow, selectedString in
            print("row \(selectedRow) : \(selectedString)")
        
            self.selectedIndexForTeamMember = selectedRow
            self.selectedUserID = self.arrTeamCreatedTiemStemp[self.selectedIndexForTeamMember]
            self.lblTeamMember.text = selectedString
        
            print("For Member = \(self.selectedIndexForTeamMember)")
            print("Select Member id = \(self.selectedIDForTeamMember)")
            //self.callWebServiceForEventLeadList(TypeId: self.typeID)
            
        },cancelAction: { print("cancel")})
    }
    
    @IBAction func btnEventGroupAction(_ sender: Any) {
        if arrEventList.count >= 1
        {
            let tempEventArr = (arrEventList[0] as! NSArray)
            var eventArr = [String]()
            for i in 0...tempEventArr.count-1
            {
                let eventObj = tempEventArr[i] as! EventDetail
                let name = eventObj.eventName
                eventArr.append(name!)
            }
               
            StringPickerPopOver.appearFrom(originView: sender as! UIView, baseView: btnEventGroup , baseViewController: self, title: "Select Event", choices: eventArr , initialRow:selectedIndexForEvent, doneAction: { selectedRow, selectedString in
                print("row \(selectedRow) : \(selectedString)")
                   
                self.selectedIndexForEvent = selectedRow
                self.selecteEventObj = tempEventArr[selectedRow] as! EventDetail
                self.lblEventGroup.text = selectedString
                print("For Event = \(self.selectedIndexForEvent)")
                //print("Selecte Event Id = \(self.selectedIDForEvent)")
                print(self.selecteEventObj.createdTimeStamp!)
                //self.callWebServiceForEventLeadList(TypeId: self.typeID)
            },cancelAction: { print("cancel")})
        }
    }
    
    @IBAction func btnGenerateReportAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ConvertedLeadToCustomDetailViewController") as! ConvertedLeadToCustomDetailViewController
        vc.objSelectedEvenId = selecteEventObj
        self.navigationController?.pushViewController(vc, animated: true)
    }
    //MARK:-
}

//MARK:- Webservice Delegate MEthod...
extension ConvertedLeadToCustomerViewController: WebServiceDelegate{
    
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
                
                self.callWebServiceForEventLeadList(TypeId: self.typeID)
            }
        }
        else if apiKey == GET_EventList_For_User_Api
        {
            stopAnimating()
            let result = handleWebService.handleGetEventLeadList(response)
                       
            if arrEventList.count >= 1
            {
                arrEventList.removeAllObjects()
            }
            if result.Status
            {
                if result.arrEventList.count > 0
                {
                    arrEventList.addObjects(from: [result.arrEventList])
                }
            }
            if arrEventList.count >= 1 {
                let eventObj = EventDetail()
                eventObj.eventName = "All"
                eventObj.createdTimeStamp = "all"
                           
                let temparr = arrEventList[0] as! NSArray
                (temparr as! NSMutableArray).add(eventObj)
                lblEventGroup.text = (temparr[selectedIndex] as? EventDetail)?.eventName
                self.selecteEventObj = temparr[selectedIndex] as! EventDetail
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
