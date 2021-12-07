//
//  EventTeamMemberViewController.swift
//  NewMleadsEnterprise
//
//  Created by Triforce New Mac on 25/06/19.
//  Copyright © 2019 com.Tri-Force.MLeadsEnterprise. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class EventTeamMemberViewController: UIViewController,WebServiceDelegate,NVActivityIndicatorViewable {

    @IBOutlet var SuperView: UIView!
    
    @IBOutlet var lblTeamMember: UILabel!
    @IBOutlet var lblEventWithin: UILabel!
    
    let webService : WebService = WebService()
    var handleWebService : HandleWebService = HandleWebService()
    var appdelegate = AppDelegate()
    
    var arrTeamName = [String]()
    var arrTeamCreatedTiemStemp = [String]()
    
    var selectedIndexForEventsWithin = Int()
    var selectedIndexForTeamMember = Int()
    
    var isFirstTimeCall = Bool()
    var selectedID = String()
    var reportID = String()
    var selectedRow = Int()
    var typeID = String()
    
    var arrTempReportsTo = NSMutableArray()
    var arrOfDictionary = [[String : String]]()
    
    var arrEventList = NSMutableArray()
    //var arrTempReportsTo = NSMutableArray()
    let arrTempCreatedTimestamp = NSMutableArray()
    
   
    //var arrOfDictionary = [[String : String]]()
    //var arrTeamName = [String]()
    //var arrTeamCreatedTiemStemp = [String]()
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showAnimate()
        
        //Progress Bar Loding...
//        let size = CGSize(width: 30, height: 30)
//        startAnimating(size, message: "Loading...", type: NVActivityIndicatorType(rawValue: 29))
//
//        let param:[String : AnyObject] = ["userId":objLoginUserDetail.userId! as AnyObject]
//        //rwebService.doRequestPost(GET_EVENTLIST_ENTERPISE_WITHIN_URL, params: param, key: "eventList", delegate: self)
//
//        self.isTaskCreate = true
//        self.isTaskView = true
//        self.isAttendee = true
//        self.isMessagingToAll = true
//        self.isEventAgenda = true
//        self.isbadgeEntryCheck = true
//        self.isEventSponsors = true
//        self.isPlaceNearBy = true
//        self.isSendAlert = true
//        self.isBesocial = true
//
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //self.navigationController?.isNavigationBarHidden = true
        
//        if isFirstTimeCall == true
//        {
//            callWebService(TypeId: typeID, selectedId: selectedID)
//        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            if (touch.view == self.view) {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    //MARK: Webservices Custom Function Call Method...
//    func callWebService(TypeId:String,selectedId:String)
//    {
//        let param:[String : AnyObject] = ["userId":objLoginUserDetail.userId! as AnyObject,
//                                          "selectedId":selectedId as AnyObject,
//                                          "typeId":TypeId as AnyObject]
//
//        //Progress Bar Loding...
//        let size = CGSize(width: 30, height: 30)
//        startAnimating(size, message: "Loading...", type: NVActivityIndicatorType(rawValue: 29))
//        //webService.doRequestPost(GET_EVENTLIST_ENTERPISE_WITHIN_URL, params: param, key: "eventList", delegate: self)
//    }
    
    /*@IBAction func btnCancelClick(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let back = storyboard.instantiateViewController(withIdentifier: "EventViewController") as! EventViewController
        let navigationVc = UINavigationController(rootViewController: back)
        present(navigationVc, animated: true, completion: nil)
    }*/
    
    
    func showAnimate()
    {
        self.modalPresentationStyle = .overCurrentContext
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    /*@IBAction func btnTeamMemberAction(_ sender: AnyObject) {
        
        print("Click On Button in TeamManagement")
        StringPickerPopOver.appearFrom(originView: sender as! UIView, baseView: nil, baseViewController: self, title: "Select Member", choices: arrTeamName , initialRow:selectedIndexForTeamMember, doneAction: { selectedRow, selectedString in
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
            print("Report To of Login User is : \(reportsTo)")
            
            if  (self.selectedID == objLoginUserDetail.createTimeStamp!)
            {
                print("loginuser")
                self.userType = "LOGINUSER"
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
            else if (self.reportID == reportsTo)
            {
                print("Same Level")
                self.userType = "SAMELEVEL"
                self.isTaskCreate = false
                self.isTaskView = false
                self.isAttendee = false
                self.isMessagingToAll = false
                self.isEventAgenda = true
                self.isbadgeEntryCheck = false
                self.isEventSponsors = false
                self.isPlaceNearBy = true
                self.isSendAlert = false
                self.isBesocial = false

            }
            else if (self.reportID == objLoginUserDetail.createTimeStamp){
                print("Team Member")
                self.userType = "TEAMMEMBER"
                self.isTaskCreate = false
                self.isTaskView = false
                self.isAttendee = true
                self.isMessagingToAll = false
                self.isEventAgenda = true
                self.isbadgeEntryCheck = false
                self.isEventSponsors = true
                self.isPlaceNearBy = true
                self.isSendAlert = false
                self.isBesocial = false

            }
            else if (self.reportID == "0")
            {
                print("Manager")
                self.userType = "MANAGER"
                self.isTaskCreate = false
                self.isTaskView = false
                self.isAttendee = true
                self.isMessagingToAll = true
                self.isEventAgenda = true
                self.isbadgeEntryCheck = true
                self.isEventSponsors = true
                self.isPlaceNearBy = true
                self.isSendAlert = false
                self.isBesocial = false

            }
            else{
                print("TeamMember of low level")
                self.userType = "TEAMMEMBERLEVEL2"
                self.isTaskCreate = false
                self.isTaskView = true
                self.isAttendee = true
                self.isMessagingToAll = false
                self.isEventAgenda = true
                self.isbadgeEntryCheck = false
                self.isEventSponsors = true
                self.isPlaceNearBy = true
                self.isSendAlert = false
                self.isBesocial = false
            }


            self.lblTeamMember.text = selectedString
            print("For Member = \(self.selectedIndexForTeamMember)")
            print("Select id = \(self.selectedID)")
            //self.callWebService(TypeId: self.typeID, selectedId: self.selectedID)

        }, cancelAction:{print("cancel")})

   }
    
    @IBAction func btnEventAction(_ sender: Any) {
        
        StringPickerPopOver.appearFrom(originView: sender as! UIView, baseView: nil, baseViewController: self, title: "Select Duration", choices: arrWithinEvents.duration , initialRow:selectedIndexForEventsWithin, doneAction: { selectedRow, selectedString in
            print("row \(selectedRow) : \(selectedString)")
            
            self.selectedIndexForEventsWithin = selectedRow
            self.typeID = arrWithinEvents.typeID[self.selectedIndexForEventsWithin]
            self.lblEventWithin.text = selectedString
            print("For Evenyt Within = \(self.selectedIndexForEventsWithin)")
            print("typeid = \(self.typeID)")
            //self.callWebService(TypeId: self.typeID, selectedId: self.selectedID)
            
        } ,cancelAction: { print("cancel")})
        //self.dismiss(animated: true, completion: nil)
    }*/
    
    //MARK: Webservices Method...
//    func webServiceResponceSuccess(_ response: Data, apiKey: String) {
//        stopAnimating()
//        
//        if apiKey == GET_EVENTLIST_ENTERPISE_WITHIN_URL
//        {
//            let result = handleWebService.handleGetAddTeamMember(response)
//            
//            if result.Status
//            {
//                var objtmMember = TeamMember()
//                let data = result.TeamMember
//                
//                let arrTempTeamName = NSMutableArray()
//                //                let arrTempCreatedTimestamp = NSMutableArray()
//                //                let arrTempReportsTo = NSMutableArray()
//                let arrTempExportAllowed = NSMutableArray()
//                
//                for i in 0...data.count-1
//                {
//                    objtmMember = data[i] as! TeamMember
//                    
//                    let Fullname = objtmMember.first_name! as String + " " + objtmMember.last_name! as String
//                    
//                    arrTempTeamName.add(Fullname)
//                    arrTempReportsTo.add(objtmMember.reportsTo! as String)
//                    arrTempExportAllowed.add(objtmMember.export_allowed! as String)
//                    arrTempCreatedTimestamp.add(objtmMember.created_timestamp! as String)
//                    
//                }
//                
//                for i in 0..<arrTempTeamName.count
//                {
//                    //arrOfDictionary.append([arrTempTeamName[i] as! String : arrTempReportsTo[i] as! String])
//                    arrOfDictionary.append([arrTempCreatedTimestamp[i] as! String : arrTempReportsTo[i] as! String])
//                }
//                print("arrOfDictionay is :\(arrOfDictionary)")
//                
//                arrTeamName = arrTempTeamName as NSArray as! [String]
//                arrTeamCreatedTiemStemp = arrTempCreatedTimestamp as NSArray as! [String]
//                
//                if arrTeamCreatedTiemStemp.contains(objLoginUserDetail.userId!)
//                {
//                    selectedIndexForTeamMember = arrTeamCreatedTiemStemp.index(of: objLoginUserDetail.userId!)!
//                }
//                
//                
//                lblTeamMember.text = arrTeamName[selectedIndexForTeamMember]
//                selectedID = arrTeamCreatedTiemStemp[selectedIndexForTeamMember]
//                
//                if arrWithinEvents.duration.contains("Today")
//                {
//                    selectedIndexForEventsWithin = arrWithinEvents.duration.index(of: "Today")!
//                    typeID = arrWithinEvents.typeID[selectedIndexForEventsWithin]
//                    lblEventWithin.text = arrWithinEvents.duration[selectedIndexForEventsWithin]
//                }
//                
//                print("selectid \(selectedID) and typeid \(typeID)")
//                
//                //callWebService(TypeId: typeID, selectedId: selectedID)
//                
//                isFirstTimeCall = true
//            }
//        }
//            
//        else if apiKey == GET_EVENTLIST_ENTERPISE_WITHIN_URL
//        {
//            
//            let result = handleWebService.handleGetMyEvents(response)
//            if result.Status
//            {
//                arrEventList = result.EventList
//                for subview in view.subviews
//                {
//                    if subview is UIImageView
//                    {
//                        subview.removeFromSuperview()
//                    }
//                }
//                
//                //tblView.reloadData()
//            }
//                
//                
//            else
//            {
//                arrEventList.removeAllObjects()
//                //tblView.reloadData()
//                //imageView = UIImageView(frame:CGRect(x: tblView.frame.origin.x, y: tblView.frame.origin.y, width: tblView.frame.width, height: tblView.frame.height))
//                //imageView?.contentMode = .scaleAspectFit
//                //imageView?.image = #imageLiteral(resourceName: "whoops-No Events Found")
//                //imageView?.backgroundColor = UIColor.white
//               // self.view.addSubview(imageView!)
//                
//                //MARK: Button AddEventss
//                //self.view.addSubview(btnAddEventOutlet)
//            }
//        }
//    }
    
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }*/

}
