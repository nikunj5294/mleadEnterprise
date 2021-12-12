//
//  EmailStatisticsViewController.swift
//  NewMleadsEnterprise
//
//  Created by Triforce New Mac on 09/01/20.
//  Copyright © 2020 com.Tri-Force.MLeadsEnterprise. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class EmailStatisticsViewController: UIViewController,NVActivityIndicatorViewable {

    @IBOutlet var btnTeamMember: UIButton!
    @IBOutlet var lblTeamMember: UILabel!
    @IBOutlet var btnEventGroup: UIButton!
    @IBOutlet var lblEventGroup: UILabel!
    @IBOutlet var btnEmailStatus: UIButton!
    @IBOutlet var lblEmailStatus: UILabel!
    
    @IBOutlet var EmailStaticsPopupView: UIView!
    @IBOutlet var tableView: UITableView!
    
    var arrEmailStatus = [String]()
    var arrEmailList = NSMutableArray()
    var arrOfDictionary = [[String : String]]()
    
    
    //let dictSelectedEvent: NSDictionary = NSDictionary()
    
    let webService : WebService = WebService()
    var handleWebService : HandleWebService = HandleWebService()
    var appdelegate = AppDelegate()
    
    var dictSelectedEvent = NSMutableDictionary()
    var strEvent = String()
    
    var selectedIndexForEventsWithin = Int()
    var selectedIndexForTeamMember = Int()
    var selectedID = String()
    var reportID = String()
    var typeID = String()
    var selectedRow = Int()
    
    var arrTeamMamber = [String]()
    var selectedUserID = String()
    var arrEventList = NSMutableArray()
    var selectedIndex: Int = 0
    var selecteEventObj: EventDetail =  EventDetail()
    var selectedIDForTeamMember = String()
    var selectedIndexForEvent = Int()
    var selectedIndexForEmailStatus = Int()
    
    var arrTeamName = [String]()
    var arrTeamCreatedTiemStemp = [String]()
    var arrTempReportsTo = NSMutableArray()
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.navigationItem.title = "Email Statistics"
        self.findHamburguerViewController()?.gestureEnabled = false
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image:#imageLiteral(resourceName: "filter"), style: .plain, target: self, action: #selector(self.btnFilterClick(_:)))//#selector(addTapped)
        EmailStaticsPopupView.isHidden = true
        
        //self.callWebService(TypeId: self.typeID, selectedId: self.selectedID)
        
        //MARK: WEB SERVICES CALL TEAM MEMBER LIST...
        let param:[String : AnyObject] = ["userId":objLoginUserDetail.createTimeStamp! as AnyObject, "hierarchy_type":"1" as AnyObject]
        
        let size = CGSize(width: 30, height: 30)
        startAnimating(size, message: "Loading...", type: NVActivityIndicatorType(rawValue: 29))
        
        webService.doRequestPost(GET_ADD_TEAM_MEMBER_LIST, params: param, key: "user", delegate: self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
           if let touch = touches.first {
               if (touch.view == self.view) {
                   self.dismiss(animated: true, completion: nil)
               }
           }
           self.EmailStaticsPopupView.isHidden = true
       }

    //MARK:- Webservices Custom Function Call Method...
   /* func callWebService(TypeId:String,selectedId:String)
    {
        let param:[String : AnyObject] = ["userId":objLoginUserDetail.createTimeStamp! as AnyObject,
                                          "selectedId":selectedId as AnyObject,
                                          "typeId":TypeId as AnyObject]
        
        //Progress Bar Loding...
        let size = CGSize(width: 30, height: 30)
        startAnimating(size, message: "Loading...", type: NVActivityIndicatorType(rawValue: 29))
        
        webService.doRequestPost(GET_EVENTLIST_ENTERPISE_URL, params: param, key: "eventList", delegate: self)
    }*/
    
 
    
 //MARK:- Filter Button..
    @IBAction func btnFilterClick(_ sender: Any) {
        
        EmailStaticsPopupView.isHidden = false
        
//
        for i in 0..<arrTeamCreatedTiemStemp.count
        {
            if arrTeamCreatedTiemStemp[i] == objLoginUserDetail.userId
            {
             //   lblTeamMember.text = arrTeamName[i]
                lblTeamMember.text = arrTeamMamber[i]
            }
        }
    }
    //MARK:- Button Action Method...
    
//    @IBAction func btnTeamMemberAction(_ sender: Any) {
//        print("Click On Button in TeamManagement")
//        StringPickerPopOver.appearFrom(originView: sender as! UIView, baseView: self.btnTeamMember, baseViewController: self, title: "Select Member", choices: arrTeamName , initialRow:selectedIndexForTeamMember, doneAction: { selectedRow, selectedString in
//            print("row \(selectedRow) : \(selectedString)")
//
//            self.selectedIndexForTeamMember = selectedRow
//            self.selectedID = self.arrTeamCreatedTiemStemp[self.selectedIndexForTeamMember]
//            self.reportID = self.arrTempReportsTo[self.selectedIndexForTeamMember] as! String
//            print("reportID\(self.reportID)")
//
//            self.selectedRow = selectedRow
//            var reportsTo = String()
//
//            for i in 0..<self.arrOfDictionary.count
//            {
//                let name = self.arrOfDictionary[i] as NSDictionary
//                if (name.value(forKey: objLoginUserDetail.createTimeStamp!) != nil){
//                    reportsTo = name.value(forKey: objLoginUserDetail.createTimeStamp!) as! String
//                }
//            }
//            self.lblTeamMember.text = selectedString
//            print("Report To of Login User is : \(reportsTo)")
//            //self.callWebService(TypeId: self.typeID, selectedId: self.selectedID)
//        }, cancelAction:{print("cancel")})
//    }
    
     
    
    //MARK:- BUtton Action Method...
    
    @IBAction func btnTeamMemberAction(_ sender: Any) {
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
    @IBAction func btnEmailStatus(_ sender: Any) {
        
        StringPickerPopOver.appearFrom(originView: sender as! UIView, baseView: btnEmailStatus , baseViewController: self, title: "Select Email Status", choices: ["Delivered", "Opens", "Hard Bounces", "Soft Bounces", "Unsubscribed", "All"] , initialRow:selectedIndexForEmailStatus, doneAction: { selectedRow, selectedString in
            print("row \(selectedRow) : \(selectedString)")
            self.lblEmailStatus.text = selectedString
            self.selectedIndexForEmailStatus = selectedRow
            },cancelAction: { print("cancel")})
        
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
    
    //MARK: Email Staatic Webservies Method call....
    func callWebServiceForEmailStatusList(TypeId:String,selectedId:String)
    {
        let param:[String : AnyObject] = ["userId":objLoginUserDetail.userId! as AnyObject,
                                          "selectedId":selectedId as AnyObject,
                                          "eventId":TypeId as AnyObject]
        
        //Progress Bar Loding...
        let size = CGSize(width: 30, height: 30)
        startAnimating(size, message: "Loading...", type: NVActivityIndicatorType(rawValue: 29))
        
       webService.doRequestPost(GET_EMAIL_STATISTICS_URL, params: param, key: "getEmailstatistics", delegate: self)
    }
}

//MARK:- TableView Delegate Method...
extension EmailStatisticsViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrEmailList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
         let cell = tableView.dequeueReusableCell(withIdentifier: "EmailCell", for: indexPath)
        
        return cell
    }
    
}



//MARK:- WebServices Delegate Method...
extension EmailStatisticsViewController: WebServiceDelegate{
    func webServiceResponceSuccess(_ response: Data, apiKey: String) {
        stopAnimating()
                
       /* if apiKey == GET_EVENTLIST_ENTERPISE_URL
        {
            let result = handleWebService.handleGetEventList(response)
            print(result.Status)
            print(result.teamMember)
            let arrTempN = NSMutableArray()
            
            for i in 0..<result.teamMember.count
            {
                arrTeamName.append(result.teamMember[i].firstName! + " " + result.teamMember[i].lastName!)
                arrTeamCreatedTiemStemp.append(result.teamMember[i].createTimeStamp!)
                arrTempReportsTo.add(result.teamMember[i].report)
                //arrTempExportAllowed.add(result.teamMember[i].export_allowed)
                
                var eventID = String()
                if( [dictSelectedEvent.value(forKey: "EventName")] == "all")
                {
                     eventID = "100"
                }
                else
                {
                    print("Commented...")
                    //eventID = dictSelectedEvent.value(forKey: "EventId") as! String
                    //strEvent = eventID
                }
//
            }
            for i in 0..<arrTeamName.count
            {
                arrOfDictionary.append([arrTeamCreatedTiemStemp[i] as! String : arrTempReportsTo[i] as! String])
            }
            print(arrOfDictionary)
            if arrTeamCreatedTiemStemp.contains(objLoginUserDetail.createTimeStamp!)
            {
                selectedIndexForTeamMember = arrTeamCreatedTiemStemp.index(of: objLoginUserDetail.createTimeStamp!)!
            }
            //self.lblTeamMember.text = arrTeamMamber[selectedIndexForTeamMember]
//                arrEventList = result.arrEventL
//                tblLeadView.reloadData()
        }*/
            //print("selectid \(selectedID) and typeid \(typeID)")
        
        
        //MARK: Email Statsctics Api REsponse...
        if apiKey == GET_EMAIL_STATISTICS_URL
        {
            let result = handleWebService.handleGetEmailStatiscs(response)
            print(result.Status)
          //  print(result.teamMember)
            
        }
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
                //arrTeamMamber.append("All")
               // arrTeamCreatedTiemStemp.append("100")
                //if arrTeamCreatedTiemStemp.contains(objLoginUserDetail.createTimeStamp!)
                //{
                //    selectedIndexForTeamMember = arrTeamCreatedTiemStemp.index(of: objLoginUserDetail.createTimeStamp!)!
                //}
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
            //if arrEventList.count >= 1
            if arrEventList.count >= 0{
                let eventObj = EventDetail()
                eventObj.eventName = "All"
                eventObj.createdTimeStamp = "all"
                
                let temparr = arrEventList[0] as! NSArray
                (temparr as! NSMutableArray).add(eventObj)
                lblEventGroup.text = (temparr[selectedIndex] as? EventDetail)?.eventName
                self.selecteEventObj = temparr[selectedIndex] as! EventDetail
                
                if selectedIndexForEmailStatus == 0 {
                    self.lblEmailStatus.text = "Delivered"
                }
             //   self.callWebServiceForEmailStatusList(TypeId: self.typeID, selectedId: self.selecteEventObj.eventid!)
            }
            EmailStaticsPopupView.isHidden = true
            print(selectedUserID)
         //   print(self.selecteEventObj.eventid!)
            print(self.selecteEventObj.createdTimeStamp!)
            self.callWebServiceForEmailStatusList(TypeId: self.selecteEventObj.createdTimeStamp!, selectedId:selectedUserID )
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

