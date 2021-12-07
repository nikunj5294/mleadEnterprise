//
//  Follow-UpsMyLeadVC.swift
//  NewMleadsEnterprise
//
//  Created by Akshansh Modi on 09/01/21.
//  Copyright © 2021 com.Tri-Force.MLeadsEnterprise. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import TextFieldEffects
import JSSAlertView
import Alamofire

class Follow_UpsMyLeadVC: UIViewController, NVActivityIndicatorViewable {

    @IBOutlet weak var tbFollowUp: UITableView!
    @IBOutlet weak var viewFiltter: UIView!
    
    @IBOutlet weak var lblEventOfGroup: UILabel!
    @IBOutlet weak var lblTeamMember: UILabel!
    @IBOutlet weak var lblType: UILabel!
    
    
    @IBOutlet weak var btnTeamMember: UIButton!
    @IBOutlet weak var btnEventsGroup: UIButton!
    @IBOutlet weak var btnType: UIButton!
    
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
    var arrType = ["Email","SMS","Call"]
    var arrTeamCreatedTiemStemp = [String]()
    
    var arrTempReportsTo = NSMutableArray()
    var arrEventList = NSMutableArray()
    var arrEventLeadList = NSMutableArray()
    let dictSelectedEvent = NSMutableDictionary()//
    var eventId = String()
    var Str_EventId = String()
    var selectedIndexForEvent = Int()
    var selectedIndexForType = Int()
    var selectedEventObj: EventDetail =  EventDetail()
    var arrGetFollowUpdata : [[String:Any]] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Follow-Ups"
        self.findHamburguerViewController()?.gestureEnabled = false
        // Do any additional setup after loading the view.
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image:#imageLiteral(resourceName: "filter"), style: .plain, target: self, action: #selector(self.btnFilterAction(_:)))
        self.viewFiltter.isHidden = true
        
        self.callWebService(TypeId: objLoginUserDetail.userId!, selectedId: "")
    }
    
    @IBAction func btnFilterAction(_ sender: Any) {
        viewFiltter.isHidden = false
        
//        for i in 0..<arrTeamCreatedTiemStemp.count
//        {
//            if arrTeamCreatedTiemStemp[i] == objLoginUserDetail.userId
//            {
//                lblTeamMember.text = arrTeamName[i]
//            }
//        }
    }

    @IBAction func TeamMember(_ sender: Any) {
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
    
    @IBAction func EventOfGroup(_ sender: Any) {
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
                self.lblEventOfGroup.text = selectedString
                print("For Event = \(self.selectedIndexForEvent)")
                
                print(self.selectedEventObj.createdTimeStamp!)
                //self.callWebServiceForEventLeadList(TypeId: self.typeID)
                
                }, cancelAction:{print("cancel")})
        }
    }
    
    @IBAction func Type(_ sender: Any) {
        StringPickerPopOver.appearFrom(originView: sender as! UIView, baseView: self.btnType, baseViewController: self, title: "Select Type", choices: arrType , initialRow:selectedIndexForType, doneAction: { selectedRow, selectedString in
            print("row \(selectedRow) : \(selectedString)")
            
            self.selectedIndexForType = selectedRow
            self.lblType.text = selectedString
            print("For Type = \(selectedString)")
            
            }, cancelAction:{print("cancel")})
        
        self.AlamofireGetProductData()
    }
    
    @IBAction func HideFiltter(_ sender: Any) {
        viewFiltter.isHidden = true
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
    
}

extension Follow_UpsMyLeadVC : WebServiceDelegate{
    
    func webServiceResponceSuccess(_ response: Data, apiKey: String) {
        stopAnimating()
        
        if apiKey == GET_EVENTLIST_ENTERPISE_URL
        {
            let result = handleWebService.handleGetEventList(response)
            print(result.Status)
            print(result.teamMember)
            let arrTempN = NSMutableArray()
            //MARk: Team Member...
            for i in 0..<result.teamMember.count{
                
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
           
        
            arrEventLeadList = result.arrLeadList
            self.tbFollowUp.reloadData()

            print(result.Status)
            print(result.teamMember)
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
    
    func AlamofireGetProductData(){

        let url = "https://www.myleadssite.com/MLeads9.7.22/getLeadFollowup.php"
        debugPrint("URK",WEBSERVICE_URL + "getLeadFollowup.php")
        let param:[String : AnyObject] = ["userId":objLoginUserDetail.userId! as AnyObject,"type":"\(lblType.text!)" as AnyObject,"leadId":"\(lblEventOfGroup.text!)" as AnyObject,"followupActionId":"" as AnyObject,"followupdetails":"" as AnyObject]

        Alamofire.request(url, method: .post, parameters: param as Parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
            let json = JSON(data: response.data!)
            print(json)
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    //self.AIView.stopAnimating()
                    let data = response.result.value as? [String : Any] ?? [:]
                    print(data)
                    let getLeadFollowup = data["getLeadFollowup"] as? [String:Any] ?? [:]
                    if let Status = getLeadFollowup["status"] as? String {
                        if Status == "NO"{
                            print("No")
                        }
                        else
                        {
                            print("Yes")
                            self.arrGetFollowUpdata = getLeadFollowup["followupdetails"] as? [[String:Any]] ?? []
                            if getLeadFollowup.isEmpty{
                                
                            }
                            else
                            {
                                
                            }
                            self.tbFollowUp.reloadData()
                        }
                    }
                }
                break

            case .failure(_):
                //self.AIView.stopAnimating()
                //let _ = Alert(title: "Error", msg: "server or internet error", vc: self)
                break
            }
        }
    }

}

extension Follow_UpsMyLeadVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrGetFollowUpdata.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Follow_UpsMyLeadVCDataCell", for: indexPath) as! Follow_UpsMyLeadVCDataCell
        
        cell.lblName.text = self.arrGetFollowUpdata[indexPath.row]["name"] as? String ?? ""
        cell.lblDate.text = self.arrGetFollowUpdata[indexPath.row]["createddate"] as? String ?? ""
        cell.lblEmail.text = self.arrGetFollowUpdata[indexPath.row]["email"] as? String ?? ""
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}

class Follow_UpsMyLeadVCDataCell: UITableViewCell {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    
    override class func awakeFromNib() {
        
    }
}
