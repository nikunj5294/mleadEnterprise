//
//  MyLeadViewController.swift
//  NewMleadsEnterprise
//
//  Created by Triforce New Mac on 06/07/19.
//  Copyright © 2019 com.Tri-Force.MLeadsEnterprise. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import TextFieldEffects
import JSSAlertView
//import Kingfisher

class MyLeadViewController: UIViewController,NVActivityIndicatorViewable{

    @IBOutlet var MyLeadMemberPopUpView: UIView!
    @IBOutlet var btnTeamMember: UIButton!
    @IBOutlet var btnEventsGroup: UIButton!
    @IBOutlet var btnLeadStatus: UIButton!
    
    @IBOutlet var lblTeamMember: UILabel!
    @IBOutlet var lblEventGroup: UILabel!
    @IBOutlet var lblLeadStatus: UILabel!
    
    @IBOutlet weak var lblEventTitle: UILabel!
    @IBOutlet var tblLeadView: UITableView!
    
    let webService : WebService = WebService()
    var handleWebService : HandleWebService = HandleWebService()
    var appdelegate = AppDelegate()
    
    var selectedIndexForEventsWithin = Int()
    var selectedIndexForTeamMember = Int()
    var selectedID = String()
    var reportID = String()
    var typeID = String()
    var selectedRow = Int()
    
    var arrOfDictionary = [[String : String]]()
    var arrTeamName = [String]()
    var arrLeadStatus = [String]()
    var arrEventGroup = [String]()
    var arrTeamCreatedTiemStemp = [String]()
    
    var arrTempReportsTo = NSMutableArray()
    var arrEventList = NSMutableArray()
    var arrEventLeadList = NSMutableArray()
    let dictSelectedEvent = NSMutableDictionary()//
    var eventId = String()
    var Str_EventId = String()
    var selectedIndexForEvent = Int()
    
    var selectedEventObj: EventDetail =  EventDetail()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MyLeadMemberPopUpView.isHidden = true
        
        self.navigationItem.title = "My Lead"
        if selectedEventObj.eventName != "" {
            self.navigationItem.title = selectedEventObj.eventName
        } else {
            self.navigationItem.title = "My Lead"
        }
        self.findHamburguerViewController()?.gestureEnabled = false
        
        let filter = UIBarButtonItem(image:#imageLiteral(resourceName: "filter"), style: .plain, target: self, action: #selector(self.btnFilterEventcClick(_:)))
        let search = UIBarButtonItem(image:#imageLiteral(resourceName: "search32"), style: .plain, target: self, action: #selector(self.btnSearchClick(_:)))
        
        navigationItem.rightBarButtonItems = [ filter , search ]
        
//        dictSelectedEvent.setValue("", forKey: "EventName")
//        dictSelectedEvent.setValue("", forKey: "EventId")
//        dictSelectedEvent.setValue("", forKey: "type")
        
        //Progress Bar Loding...
        let size = CGSize(width: 30, height: 30)
        startAnimating(size, message: "Loading...", type: NVActivityIndicatorType(rawValue: 29))
        //MARK: Event webcall
        self.callWebService(TypeId: objLoginUserDetail.userId!, selectedId: "")
        var all = "all"
        self.CallWebServiceMyLead(EventId: "", selectedId: objLoginUserDetail.userId!)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.callRefreshAPI), name: Notification.Name("callRefreshAPI"), object: nil)

        
        //*************
//
//        if (dictSelectedEvent.value(forKey: "EventName") == all)
//        {//(forKey: "EventName")) != nil)
//            eventId = "100"
//        }
//        else{
//            eventId = dictSelectedEvent.value(forKey: "EventId") as! String
//            Str_EventId = eventId
        //}
        //**********************
        
        //MARK: LeadList Web call
        //self.CallWebServiceMyLead(EventId: "", selectedId: objLoginUserDetail.createTimeStamp!)
      
        // Do any additional setup after loading the view.
        
        self.tblLeadView.register(UINib(nibName: "LeadEventTblCell", bundle: nil), forCellReuseIdentifier: "LeadEventTblCell")
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
       
        
        //**********************
        //MARK: LeadList Web call
        //self.CallWebServiceMyLead(EventId: eventId, selectedId: objLoginUserDetail.createTimeStamp!)
        
        //self.navigationController?.isNavigationBarHidden = true
        //Progress Bar Loding...
        //let size = CGSize(width: 30, height: 30)
        //startAnimating(size, message: "Loading...", type: NVActivityIndicatorType(rawValue: 29))
                
        //self.callWebService(TypeId: objLoginUserDetail.userId!, selectedId: "")
        
     /*   //EventName EvemtDate EventType
        let dictEvent = NSMutableDictionary()
        let dictSelectedEvent = NSMutableDictionary()
        var kEventName = "EventName"
        var eventId = String()
        if dictEvent.value(forKey: "EventName") == "all"
        {
            
        }
        if dictSelectedEvent.value(forKey: kEventName) == "all" {
            eventId = "100"
        }
        dictEvent.value(forKey: <#T##String#>)*/
        
    }
    
    //MARK:- Webservices Custom Function Call Method...
    func callWebService(TypeId:String,selectedId:String)
    {
        let param:[String : AnyObject] = ["userId":objLoginUserDetail.userId! as AnyObject,
                                          "selectedId":selectedId as AnyObject,
                                          "typeId":TypeId as AnyObject]
        
        //Progress Bar Loding...
        let size = CGSize(width: 30, height: 30)
        startAnimating(size, message: "Loading...", type: NVActivityIndicatorType(rawValue: 29))
        
        webService.doRequestPost(GET_EVENTLIST_ENTERPISE_URL, params: param, key: "eventList", delegate: self)
    }
    //
    func CallWebServiceMyLead(EventId:String,selectedId:String)
    {
        let param:[String : AnyObject] = ["userId":objLoginUserDetail.createTimeStamp! as AnyObject,
                                          "selectedId":selectedId as AnyObject,
                                          "eventId":EventId as AnyObject]
        
        
        print(param)
        //Progress Bar Loding...
        let size = CGSize(width: 30, height: 30)
        startAnimating(size, message: "Loading...", type: NVActivityIndicatorType(rawValue: 29))
        
        webService.doRequestPost(GET_LEADLIST_ENTERPISE_URL, params: param, key: "getLeadList", delegate: self)
        
    }
    
    @objc func callRefreshAPI() {
        self.CallWebServiceMyLead(EventId: "", selectedId: objLoginUserDetail.userId!)
//        self.callWebService(TypeId: objLoginUserDetail.userId!, selectedId: "")
    }
    
    //MARK:- Button Action Method...
    @IBAction func btnTeamMemberClick(_ sender: Any) {
        
        print("Click On Button in TeamManagement")
        StringPickerPopOver.appearFrom(originView: sender as! UIView, baseView: self.btnTeamMember, baseViewController: self, title: "Select Member", choices: arrTeamName , initialRow:selectedIndexForTeamMember, doneAction: { selectedRow, selectedString in
            print("row \(selectedRow) : \(selectedString)")
            
            self.selectedIndexForTeamMember = selectedRow
            self.selectedID = self.arrTeamCreatedTiemStemp[self.selectedIndexForTeamMember]
            self.reportID = self.arrTempReportsTo[self.selectedIndexForTeamMember] as! String
            print("reportID\(self.reportID)")

            self.selectedRow = selectedRow
            var reportsTo = String()

            for i in 0..<self.arrOfDictionary.count
            {
                let name = self.arrOfDictionary[i] as NSDictionary
                if (name.value(forKey: objLoginUserDetail.createTimeStamp!) != nil){
                    reportsTo = name.value(forKey: objLoginUserDetail.createTimeStamp!) as! String
                }
            }
            self.lblTeamMember.text = selectedString
            print("Report To of Login User is : \(reportsTo)")
            //self.callWebService(TypeId: self.typeID, selectedId: self.selectedID)
        }, cancelAction:{print("cancel")})
        
    }
    
    @IBAction func btnEventsGroupClick(_ sender: Any) {
        print("Click On Button in ClickEventsGroup.")
        
        if arrEventList.count >= 1 {
            let tempEventArr = arrEventList[0] as! NSArray
          // let tempEventArr = arrEventList[0] as! NSArray
            var strEventArr = [String]()
            for i in 0...(tempEventArr as AnyObject).count-1
            {
                let eventObj = tempEventArr[i] as! EventDetail
                let name = eventObj.eventName
                strEventArr.append(name!)
            }
            StringPickerPopOver.appearFrom(originView: sender as! UIView, baseView: self.btnEventsGroup, baseViewController: self, title: "Select Member", choices: strEventArr , initialRow:selectedIndexForEvent, doneAction: { selectedRow, selectedString in
                print("row \(selectedRow) : \(selectedString)")
                
                self.selectedIndexForEvent = selectedRow
                self.selectedEventObj = tempEventArr[selectedRow] as! EventDetail
                self.lblEventGroup.text = selectedString
                print("For Event = \(self.selectedIndexForEvent)")
                
                print(self.selectedEventObj.createdTimeStamp!)
                //self.callWebServiceForEventLeadList(TypeId: self.typeID)
                
                }, cancelAction:{print("cancel")})
        }
        
//            self.selectedIndexForEvent = selectedRow
//            self.selecteEventObj = tempEventArr[selectedRow] as! LeadList
//            self.lblEventGroup.text = selectedString
//            print("For Event = \(self.selectedIndexForEvent)")
//            //print("Selecte Event Id = \(self.selectedIDForEvent)")
//            print(self.selecteEventObj.createdTimeStamp!)
//            //self.lblEventGroup.text = selectedString
//            //self.CallWebServiceMyLead(EventId: <#T##String#>, selectedId: <#T##String#>)
        
        
    }
    
    @IBAction func btnLeadStatusClick(_ sender: Any) {
        print("Click On Button in LeadStatus.")
        StringPickerPopOver.appearFrom(originView: sender as! UIView, baseView: self.btnLeadStatus, baseViewController: self, title: "Select Member", choices: arrLeadStatus , initialRow:selectedIndexForTeamMember, doneAction: { selectedRow, selectedString in
            print("row \(selectedRow) : \(selectedString)")
            
            
         }, cancelAction:{print("cancel")})
    }
    
    //MARK:- Add Button Action...
    @IBAction func btnAddAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddLeadViewController") as! AddLeadViewController
        navigationController?.pushViewController(vc, animated: true)
        //self.present(vc, animated: true, completion: nil)
    }
    
    
    
    //MARK:- Filter Button..
    @IBAction func btnFilterEventcClick(_ sender: Any) {
        MyLeadMemberPopUpView.isHidden = false
    }
    
    //MARK:- Search Button Action
    @IBAction func btnSearchClick(_ sender: Any) {
        print("Search BUtton Click")
    }
    //MARK:- BackButton Action...
    @IBAction func btnBackclick(_ sender: Any) {

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let back = storyboard.instantiateViewController(withIdentifier: "DashboardViewController") as! DashboardViewController
        let navigationVc = UINavigationController(rootViewController: back)
        present(navigationVc, animated: true, completion: nil)
        
    }
    //MARK:- OUTSide Touch Animation...
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            if (touch.view == self.view) {
                self.dismiss(animated: true, completion: nil)
            }
        }
        self.MyLeadMemberPopUpView.isHidden = true
    }
    
    // Tabbar Click Event
    
    @IBAction func BTNImport(_ sender: Any) {
        let alert = UIAlertController(title: "MLeads", message: "From where do you want to import Leads?", preferredStyle: .actionSheet)
            
        alert.addAction(UIAlertAction(title: "Excel CSV File", style: .default , handler:{ (UIAlertAction)in
            print("Excel CSV File button")
        }))
            
        alert.addAction(UIAlertAction(title: "Phone Contacts", style: .default , handler:{ (UIAlertAction)in
            print("Phone Contacts button")
        }))

        alert.addAction(UIAlertAction(title: "Gmail", style: .default , handler:{ (UIAlertAction)in
            print("Gmail button")
        }))
        
        alert.addAction(UIAlertAction(title: "AWeber", style: .default , handler:{ (UIAlertAction)in
            print("AWeber button")
        }))
        
        alert.addAction(UIAlertAction(title: "Salesforce", style: .default , handler:{ (UIAlertAction)in
            print("Salesforce button")
        }))
        
        alert.addAction(UIAlertAction(title: "Hubspot", style: .default , handler:{ (UIAlertAction)in
            print("Hubspot button")
        }))
            
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))

            
            //uncomment for iPad Support
            //alert.popoverPresentationController?.sourceView = self.view

        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    @IBAction func BTNExport(_ sender: Any) {
        
        let alert = UIAlertController(title: "MLeads", message: "From where do you want to import Leads?", preferredStyle: .actionSheet)
            
        alert.addAction(UIAlertAction(title: "Excel CSV File", style: .default , handler:{ (UIAlertAction)in
            print("Excel CSV File button")
        }))
            
        alert.addAction(UIAlertAction(title: "Export To AWeber", style: .default , handler:{ (UIAlertAction)in
            print("Export To AWeber button")
        }))

        alert.addAction(UIAlertAction(title: "Export To Salesforce", style: .default , handler:{ (UIAlertAction)in
            print("Export To Salesforce button")
        }))
        
        alert.addAction(UIAlertAction(title: "Export To Hubspot", style: .default , handler:{ (UIAlertAction)in
            print("Export To Hubspot button")
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))

            //uncomment for iPad Support
            //alert.popoverPresentationController?.sourceView = self.view

        self.present(alert, animated: true, completion: {
            print("completion block")
        })
        
    }
    
    @IBAction func BTNMap(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func BTNFollowUp(_ sender: Any) {
        // Follow_UpsMyLeadVC
    
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "Follow_UpsMyLeadVC") as! Follow_UpsMyLeadVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK:- WEbservices REsponse MEthod...
extension MyLeadViewController: WebServiceDelegate{
   
    func webServiceResponceSuccess(_ response: Data, apiKey: String) {
        stopAnimating()
        
        if apiKey == GET_EVENTLIST_ENTERPISE_URL
        {
            let result = handleWebService.handleGetEventList(response)
            print(result.Status)
            print(result.teamMember)
            
            let arrTempN = NSMutableArray()
            //MARk: Team Member...
            for i in 0..<result.teamMember.count {
                
                arrTeamName.append(result.teamMember[i].firstName! + " " + result.teamMember[i].lastName!)
                arrTeamCreatedTiemStemp.append(result.teamMember[i].createTimeStamp!)
                arrTempReportsTo.add(result.teamMember[i].report)
                //arrTempExportAllowed.add(result.teamMember[i].export_allowed)
                let dictSelectedEvent: NSDictionary = NSDictionary()
//                if (self.dictSelectedEvent.value(forKey: "EventName") == "all"){
//
//                }
                lblTeamMember.text = arrTeamName[selectedIndexForTeamMember]
            }
            //MARK: EVent And Group ....
            if arrEventList.count >= 1
            {
                arrEventList.removeAllObjects()
            }
            if result.Status{
                if result.arrEventL.count > 0{
                    arrEventList.addObjects(from: [result.arrEventL])
                }
            }
            //arrEventList = result.arrEventL
            tblLeadView.reloadData()
            
        }
        else if  apiKey == GET_LEADLIST_ENTERPISE_URL
        {
            print("LeadList New...")
            let result = handleWebService.handleGetLeadList(response)
            print(result.Status)
            print(result.teamMember)
            let arrTempN = NSMutableArray()
                        
            for i in 0..<result.teamMember.count{
                arrTeamName.append(result.teamMember[i].firstName! + " " + result.teamMember[i].lastName!)
                arrTeamCreatedTiemStemp.append(result.teamMember[i].createTimeStamp!)
                arrTempReportsTo.add(result.teamMember[i].report)
                //arrTempExportAllowed.add(result.teamMember[i].export_allowed)
                let dictSelectedEvent: NSDictionary = NSDictionary()
            //   if (self.dictSelectedEvent.value(forKey: "EventName") == "all"){
            //
            //      }
                    lblTeamMember.text = arrTeamName[selectedIndexForTeamMember]
                    
            }
           
            
            
//            if result.arrLeadList.count > 0
//            {
//                arrEventList.addObjects(from: [result.arrLeadList])
//            }
            
            //MARK: EVent And Group ....
//            if arrEventLeadList.count >= 1
//            {
//                arrEventLeadList.removeAllObjects()
//            }
//            if result.Status{
//                if result.arrLeadList.count > 0
//                {
//                    arrEventList.addObjects(from: [result.arrLeadList])
//                    }
//                }
            arrEventLeadList = result.arrLeadList
            tblLeadView.reloadData()
            
            print(result.Status)
            print(result.teamMember)
            print("EVENT DIST",result.arrLeadList)
        }
        print("selectid \(selectedID) and typeid \(typeID)")
        //isFirstTimeCall = true
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

extension MyLeadViewController:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrEventLeadList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let objevnt:event
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeadEventTblCell", for: indexPath) as! LeadEventTblCell
        cell.selectionStyle = .none
        
        let objevent = arrEventLeadList[indexPath.row] as! LeadList
        
        if objevent.addedLeadType == "7"{
            cell.lblUserName.text = "Quick Record Lead"
            cell.imgEvent.image = UIImage(named: "play")
            cell.lblCompanyName.text = ""
        }else{
            cell.lblUserName.text = objevent.firstName! + " " + objevent.lastName!
            cell.lblCompanyName.text = objevent.company
            if let url = URL(string: objevent.leadStatusURL!) {
                cell.imgEvent.sd_setImage(with: url, placeholderImage: UIImage(named: "ic_img_user"), options: .continueInBackground)
//                cell.imgEvent.kf.setImage(with: url)
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let objevent = arrEventLeadList[indexPath.row] as! LeadList
        if objevent.addedLeadType == "7"{
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "QuickRecordedViewController") as! QuickRecordedViewController
            vc.objLeadData = objevent
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyLeadDetailVC") as! MyLeadDetailVC
            vc.objLeadList = objevent
            vc.delegateRefresh = self
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension MyLeadViewController : deleteDelegate{
    func refreshLeadList() {
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            self.CallWebServiceMyLead(EventId: "", selectedId: objLoginUserDetail.userId!)
        }
        
    }
}
