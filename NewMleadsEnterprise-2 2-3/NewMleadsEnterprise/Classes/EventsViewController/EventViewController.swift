//
//  ViewController.swift
//  NewMleadsEnterprise
//
//  Created by Ashish Salet on 04/04/19.
//  Copyright © 2019 com.Tri-Force.MLeadsEnterprise. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import TextFieldEffects
import JSSAlertView

class EventViewController: UIViewController,NVActivityIndicatorViewable,UITextFieldDelegate {
    

    
    @IBOutlet var EventsTeamMemberPopupView: UIView!
    
    @IBOutlet var btnTeamMember: UIButton!
    @IBOutlet var btnEventGroup: UIButton!
    
    @IBOutlet var lblTeamMemberOutlet: UILabel!
    @IBOutlet var lblEventGroupOutlet: UILabel!
    
    @IBOutlet var tblEventsView: UITableView!
    
    let webService : WebService = WebService()
    var handleWebService : HandleWebService = HandleWebService()
    var appdelegate = AppDelegate()
    
    var arrEventList = NSMutableArray()
    var arrTempReportsTo = NSMutableArray()
    let arrTempCreatedTimestamp = NSMutableArray()
    
    var arrOfDictionary = [[String : String]]()
    var arrTeamName = [String]()
    var arrTeamCreatedTiemStemp = [String]()
    
    
    var isFirstTimeCall = Bool()
    var selectedIndexForEventsWithin = Int()
    var selectedIndexForTeamMember = Int()
    var selectedID = String()
    var reportID = String()
    var typeID = String()
    var selectedRow = Int()
    
    
    var userType = String()
    
    var isTaskCreate = Bool()
    var isTaskView = Bool()
    var isAttendee = Bool()
    var isMessagingToAll = Bool()
    var isEventAgenda = Bool()
    var isbadgeEntryCheck = Bool()
    var isEventSponsors = Bool()
    var isPlaceNearBy = Bool()
    var isSendAlert = Bool()
    var isBesocial = Bool()
    
     let arrTempN = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblEventsView.tableFooterView = UIView()
        self.navigationItem.title = "My Events"
        self.findHamburguerViewController()?.gestureEnabled = false
        //self.EventsTeamMemberPopupView.isHidden = true
        
        tblEventsView.rowHeight = UITableView.automaticDimension
        tblEventsView.estimatedRowHeight = 90
 
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image:#imageLiteral(resourceName: "filter"), style: .plain, target: self, action: #selector(self.btnFilterEventcClick(_:)))//#selector(addTapped)
        self.EventsTeamMemberPopupView.isHidden = true
        
        //Progress Bar Loding...
        let size = CGSize(width: 30, height: 30)
        startAnimating(size, message: "Loading...", type: NVActivityIndicatorType(rawValue: 29))

        //self.callWebService(TypeId: objLoginUserDetail.userId!, selectedId: self.selectedID)
        
        tblEventsView.reloadData()
        
        self.isTaskCreate = true
        self.isTaskView = true
        self.isAttendee = true
        self.isMessagingToAll = true
        self.isEventAgenda = true
        self.isbadgeEntryCheck = true
        self.isEventSponsors = true
        self.isPlaceNearBy = true
        self.isSendAlert = true
        self.isBesocial = true
        
        
        
    }
    override func viewDidAppear(_ animated:Bool)
    {
        super.viewDidAppear(animated)
        self.callWebService(TypeId: "17", selectedId: (objLoginUserDetail.createTimeStamp! as AnyObject) as! String)
    }
    //MARK:- WillAppear File.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //self.navigationController?.isNavigationBarHidden = true
        
        if arrWithinEvents.duration.contains("Today"){

            selectedIndexForEventsWithin =  arrWithinEvents.duration.index(of: "Today")!
            typeID = arrWithinEvents.typeID[selectedIndexForEventsWithin]
            lblEventGroupOutlet.text = arrWithinEvents.duration[selectedIndexForEventsWithin]
            
        }
       
       // self.callWebService(TypeId: typeID, selectedId: selectedID)
        //Progress Bar Loding...
//        let size = CGSize(width: 30, height: 30)
//        startAnimating(size, message: "Loading...", type: NVActivityIndicatorType(rawValue: 29))
//
//        self.callWebService(TypeId: objLoginUserDetail.userId!, selectedId: "17")
//        self.tblEventsView.reloadData()
//        if isFirstTimeCall == true
//        {
//            callWebService(TypeId: typeID, selectedId: selectedID)
//        }else{
//            // SQL File Code PutIt
//
//
//        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            if (touch.view == self.view) {
                self.dismiss(animated: true, completion: nil)
            }
        }
        self.EventsTeamMemberPopupView.isHidden = true
    }
    
    
    //MARK:- Webservices Custom Function Call Method...
    func callWebService(TypeId:String,selectedId:String)
    {
        let param:[String : AnyObject] = ["userId":objLoginUserDetail.createTimeStamp! as AnyObject,
                                          "selectedId":selectedId as AnyObject,
                                          "typeId":TypeId as AnyObject]

        //Progress Bar Loding...
        let size = CGSize(width: 30, height: 30)
        startAnimating(size, message: "Loading...", type: NVActivityIndicatorType(rawValue: 29))
        
        webService.doRequestPost(GET_EVENTLIST_ENTERPISE_WITHIN_URL, params: param, key: "eventList", delegate: self)
    }
    
//    @IBAction func FilterPopup(_ sender: UIButton) {
//        let filter  = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PopID")as! EventsPopupViewController
//        self.addChild(filter)
//        filter.view.frame = self.view.frame
//        self.view.addSubview(filter.view)
//        filter.didMove(toParent: self)
//        
//    }
    
    @IBAction func btnAddActionClick(_ sender: Any) {
        
        let vc1 = self.storyboard?.instantiateViewController(withIdentifier: "AddViewController") as! AddViewController
        vc1.delegate = self
        self.present(vc1, animated: true, completion: nil)
    
    }
    
    //MARK:- Filter Button..
    @IBAction func btnFilterEventcClick(_ sender: Any) {
        
        EventsTeamMemberPopupView.isHidden = false
        
        
//        for i in 0..<arrTeamCreatedTiemStemp.count
//        {
//            if arrTeamCreatedTiemStemp[i] == objLoginUserDetail.userId
//            {
//                lblTeamMemberOutlet.text = arrTeamName[i]
//            }
//        }
    }
    
    @IBAction func btnEventTeamMemberDorpDown(_ sender: Any) {
        
        print("Click On Button in TeamManagement")
        StringPickerPopOver.appearFrom(originView: sender as! UIView, baseView: self.btnTeamMember, baseViewController: self, title: "Select Member", choices: arrTeamName , initialRow:selectedIndexForTeamMember, doneAction: { selectedRow, selectedString in
            print("row \(selectedRow) : \(selectedString)")
            
            self.arrTeamName.removeAll()
            
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
            print("Report To of Login User is : \(reportsTo)")

            self.lblTeamMemberOutlet.text = selectedString
            print("For Member = \(self.selectedIndexForTeamMember)")
            print("Select id = \(self.selectedID)")
            self.callWebService(TypeId: self.typeID, selectedId: self.selectedID)
            
            
        }, cancelAction:{print("cancel")})
    }
    
    @IBAction func btnEventGroupDropDown(_ sender: Any) {
        StringPickerPopOver.appearFrom(originView: sender as! UIView, baseView: self.btnEventGroup, baseViewController: self, title: "Select Duration", choices: arrWithinEvents.duration , initialRow:selectedIndexForEventsWithin, doneAction: { selectedRow, selectedString in
            print("row \(selectedRow) : \(selectedString)")
            
            self.arrTeamName.removeAll()
            
            self.selectedIndexForEventsWithin = selectedRow
            self.typeID = arrWithinEvents.typeID[self.selectedIndexForEventsWithin]
            self.lblEventGroupOutlet.text = selectedString
            print("For Event Within = \(self.selectedIndexForEventsWithin)")
            print("typeid = \(self.typeID)")

            self.callWebService(TypeId: self.typeID, selectedId: self.selectedID)
            self.EventsTeamMemberPopupView.isHidden = true
        } ,cancelAction: { print("cancel")})
    }
    
    
    
    @IBAction func btnBackclick(_ sender: Any) {
//        let nvc = self.navigationController?.viewControllers[1]
//        self.navigationController?.popToViewController(nvc!, animated: true)
        //self.dismiss(animated: false, completion: nil)
        
        
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let back = storyboard.instantiateViewController(withIdentifier: "DashboardViewController") as! DashboardViewController
//        let navigationVc = UINavigationController(rootViewController: back)
//        present(navigationVc, animated: true, completion: nil)
        
    }
    
}

//MARK:-TableView DataSource & Delegate Method...
extension EventViewController : UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrEventList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let objevnt:event
        let objevent:EventDetail
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath)
        
        let lblEventName:UILabel = cell.contentView.viewWithTag(101) as! UILabel
        let lblLocation:UILabel = cell.contentView.viewWithTag(102) as! UILabel
        let lblCity:UILabel = cell.contentView.viewWithTag(103) as! UILabel
        let lbldate:UILabel = cell.contentView.viewWithTag(104) as! UILabel
        
        //27/09/2019 Change
        //objevnt = arrEventList[indexPath.row] as! event
        objevent = arrEventList[indexPath.row] as! EventDetail
        
        lblEventName.text = objevent.eventName
        lblLocation.text = objevent.location
        lblCity.text = objevent.city
        
        let strDate = Utilities.dateFormatter(Date: objevent.eventDate!, FromString: "yyyy-MM-dd", ToString: "MM/dd/yyyy")
        lbldate.text = strDate
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedEvent = arrEventList[indexPath.row] as! EventDetail
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EventsDetailViewController") as! EventsDetailViewController
        
//        vc.eventID = selectedEvent.eventid!
//        vc.isViewEvent = true
        vc.objEventDetail = selectedEvent
        
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
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}

//MARK:- Webservices Method...
extension EventViewController:WebServiceDelegate{
    
    func webServiceResponceSuccess(_ response: Data, apiKey: String) {
        stopAnimating()
        
        if apiKey == GET_EVENTLIST_ENTERPISE_WITHIN_URL
        {
            let result = handleWebService.handleGetEventListWithin(response)
        if result.Status{
            print(result.Status)
            print(result.teamMember)
            let arrTempN = NSMutableArray()
            let arrTempTeamName = NSMutableArray()
            let arrTempExportAllowed = NSMutableArray()
            
            
            for i in 0..<result.teamMember.count{
                
                //arrTeamName.append(result.teamMember[i].first_name! + " " + result.teamMember[i].last_name!)
                
//                arrTeamName.append(result.teamMember[i].first_name! + " " + result.teamMember[i].last_name!)
//
//                arrTeamCreatedTiemStemp.append(result.teamMember[i].created_timestamp!)
//                arrTempReportsTo.add(result.teamMember[i].reportsTo!)
//                arrTempExportAllowed.add(result.teamMember[i].export_allowed)
//
                //Update On 27/09/2019
                //08/11/2019
                arrTeamName.append(result.teamMember[i].firstName! + " " + result.teamMember[i].lastName!)
                arrTeamCreatedTiemStemp.append(result.teamMember[i].createTimeStamp!)
                arrTempReportsTo.add(result.teamMember[i].report)
                arrTempExportAllowed.add(result.teamMember[i].export_allowed)
                
                
                
            }
            
            //for i in 0..<arrTempTeamName.count
            for i in 0..<arrTeamName.count
            {
                //arrOfDictionary.append([arrTempTeamName[i] as! String : arrTempReportsTo[i] as! String])
                arrOfDictionary.append([arrTeamCreatedTiemStemp[i] as! String : arrTempReportsTo[i] as! String])
            }
            print("arrOfDictionay is :\(arrOfDictionary)")
            //arrTeamName = arrTempTeamName as NSArray as! [String]
            //arrTeamCreatedTiemStemp = arrTempCreatedTimestamp as NSArray as! [String]
            //
            if arrTeamCreatedTiemStemp.contains(objLoginUserDetail.createTimeStamp!) //arrTeamCreatedTiemStemp.contains(objLoginUserDetail.userId!)
            {
                selectedIndexForTeamMember = arrTeamCreatedTiemStemp.index(of: objLoginUserDetail.createTimeStamp!)!
            }
          
            //....
            lblTeamMemberOutlet.text = arrTeamName[selectedIndexForTeamMember]
            selectedID = arrTeamCreatedTiemStemp[selectedIndexForTeamMember]
            
            
//
//            if arrWithinEvents.duration.contains("Today"){
//
//                selectedIndexForEventsWithin =  arrWithinEvents.duration.index(of: "Today")!
//                typeID = arrWithinEvents.typeID[selectedIndexForEventsWithin]
//                lblEventGroupOutlet.text = arrWithinEvents.duration[selectedIndexForEventsWithin]
//
//            }
            //MARK: Event List
            //MARK: EVent And Group ....
            
            //26-09-2019
            
            print(result)
            arrEventList = result.arrEventL
            tblEventsView.reloadData()
            print("selectid \(selectedID) and typeid \(typeID)")
            isFirstTimeCall = true
            }
        }
//        else{
//            arrEventList.removeAllObjects()
//            //tblEventsView.reloadData()
//        }
       
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

extension EventViewController: dismissAddMenuPopUpDelegate{
    func pressAddButtonClicked(index: Int) {
        
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            switch index {
            case 0:
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddLeadViewController")as! AddLeadViewController
                self.navigationController?.pushViewController(vc, animated: true)
            case 1:
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddEventViewController") as! AddEventViewController
                self.navigationController?.pushViewController(vc, animated: true)
            case 2:
                 let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddLeadGroupViewController") as! AddLeadGroupViewController
                 self.navigationController?.pushViewController(vc, animated: true)
            case 3:
                print("3")
            case 4:
                print("4")
            default:
                print("dismiss")
            }
        }
        
    }
    
    
}

