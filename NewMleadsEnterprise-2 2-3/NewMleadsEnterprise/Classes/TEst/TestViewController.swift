//
//  WebViewController.swift
//  NewMleadsEnterprise
//
//  Created by Triforce New Mac on 18/09/19.
//  Copyright © 2019 com.Tri-Force.MLeadsEnterprise. All rights reserved.
//

//MARK: WEservices CAll REsponse DAta
/* //TEmporary File Create in ....
 func handleGetEventList(_ response: Data) -> (Status: Bool, teamMember: [UserDetail], arrEvent: NSMutableArray)
 {
 var isStatus:Bool = false
 let json = JSON(data: response)
 
 //var arrTeamMember = [TeamMember]()
 var arrTeamMember = [UserDetail]()
 var arrEvents = NSMutableArray()
 let arrAllEvents = NSMutableArray()
 
 if json["eventList"]["status"].string == "YES"
 {
 isStatus = true
 let eventArr = json["eventList"]["eventArr"]
 
 for i in 0..<eventArr.count
 {
 let eventArr = eventArr[i]
 let evetwiseArr = eventArr["eventWiseArr"]
 let userDetailArr = eventArr["userDetailArr"]
 
 //                let teamMember : TeamMember = TeamMember()
 //                teamMember.first_name = userDetailArr["first_name"].string
 //                teamMember.last_name = userDetailArr["last_name"].string
 //                teamMember.created_timestamp = userDetailArr["created_timestamp"].string
 //                teamMember.export_allowed = userDetailArr["export_allowed"].string
 //                teamMember.reportsTo = userDetailArr["reportsTo"].string
 
 // Update For 27/09/2019
 let teamMember : UserDetail = UserDetail()
 teamMember.userId = userDetailArr["id"].string
 teamMember.firstName = userDetailArr["first_name"].string
 teamMember.userName = ""
 teamMember.lastName = userDetailArr["last_name"].string
 teamMember.email = userDetailArr["email"].string
 teamMember.companyName = userDetailArr["companyName"].string
 teamMember.companyWebsite = userDetailArr["companyWebSite"].string
 teamMember.report = userDetailArr["reportsTo"].string
 teamMember.createTimeStamp = userDetailArr["created_timestamp"].string
 teamMember.AddedUserFor = userDetailArr["AddedUserFor"].string
 
 for i in 0..<evetwiseArr.count
 {
 let dic : [String: JSON] = evetwiseArr[i].dictionary!
 arrEvents.add(dic.keys)
 }
 
 for i in 0..<evetwiseArr.count
 {
 var dicEvent : [String : Any] = evetwiseArr[i].dictionaryObject!
 
 for j in 0..<arrEvents.count
 {
 if((dicEvent["\(arrEvents.object(at: j))"]) != nil)
 {
 let tempArr: NSMutableArray = dicEvent["\(arrEvents.object(at: j))"] as! NSMutableArray
 let dic = NSMutableDictionary()
 for k in 0..<tempArr.count
 {
 dicEvent = tempArr.object(at: k) as! [String : Any]
 let objEvent : EventDetail = EventDetail()
 objEvent.eventName = dicEvent["eventName"] as? String
 objEvent.createdTimeStamp = (dicEvent["eventId"] as! String)
 objEvent.location =  dicEvent["location"] as! String
 objEvent.city =  dicEvent["city"] as! String
 objEvent.eventDate = dicEvent["eventDate"] as! String
 objEvent.AddedFor = dicEvent["AddedFor"] as! String
 objEvent.event_registration = dicEvent["event_registration"] as! String
 objEvent.bSocial = dicEvent["b_social"] as! String
 arrAllEvents.add(objEvent)
 objEvent.organizerId = dicEvent["organizerId"] as! String
 //objEvent.eventType = dicEvent[k] as? String
 objEvent.eventType = arrEvents[j] as? String
 objEvent.eventTag = 100+j
 
 }
 dic.setValue(arrAllEvents, forKey:arrEvents.object(at: j) as! String)
 }
 }
 }
 
 arrTeamMember.append(teamMember)
 
 print(teamMember)
 
 print(evetwiseArr)
 print(userDetailArr)
 }
 print(eventArr)
 }
 
 return (isStatus, arrTeamMember, arrAllEvents)
 }*/



import UIKit
import WebKit
import NVActivityIndicatorView

class TestViewController: UIViewController,NVActivityIndicatorViewable {

//    @IBOutlet var EventsTeamMemberPopupView: UIView!
//
//    @IBOutlet var btnTeamMember: UIButton!
//    @IBOutlet var btnEventGroup: UIButton!
//
//    @IBOutlet var lblTeamMemberOutlet: UILabel!
//    @IBOutlet var lblEventGroupOutlet: UILabel!
//
//    @IBOutlet var tblEventsView: UITableView!
    @IBOutlet var popUpView: UIView!
    @IBOutlet var btnTeamMember: UIButton!
    @IBOutlet var lblTeamMember: UILabel!
    
    @IBOutlet var btnEventGroup: UIButton!
    @IBOutlet var lblEventGroup: UILabel!
    
    @IBOutlet var tblview: UITableView!
    
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
    
    
//    @IBOutlet var webView: WKWebView!
//    var appdelegate:AppDelegate = AppDelegate()
//    var req: URLRequest? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "My TEst Events Page"
        self.findHamburguerViewController()?.gestureEnabled = false
        self.popUpView.isHidden = true
        
        let param:[String : AnyObject] = ["userId":objLoginUserDetail.userId! as AnyObject]

        let size = CGSize(width: 30, height: 30)
        startAnimating(size, message: "Loading...", type: NVActivityIndicatorType(rawValue: 29))

       webService.doRequestPost(GET_ADD_TEAM_MEMBER_LIST, params: param, key: "user", delegate: self)
        
    }
    
    @IBAction func btnFltr(_ sender: Any) {
        self.popUpView.isHidden = false
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            if (touch.view == self.view) {
                self.dismiss(animated: true, completion: nil)
            }
        }
        self.popUpView.isHidden = true
    }
    
    //MARK: Webservices Custom Function Call Method...
    func callWebService(TypeId:String,selectedId:String)
    {
        let param:[String : AnyObject] = ["userId":objLoginUserDetail.createTimeStamp! as AnyObject,"selectedId":selectedId as AnyObject,"typeId":TypeId as AnyObject]
        
        //Progress Bar Loding...
        let size = CGSize(width: 30, height: 30)
        startAnimating(size, message: "Loading...", type: NVActivityIndicatorType(rawValue: 29))
        
        webService.doRequestPost(GET_EVENTLIST_ENTERPISE_URL_TESTING, params: param, key: "eventList", delegate: self)
    }
    
    @IBAction func btnTeamAction(_ sender: Any) {
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
            print("Report To of Login User is : \(reportsTo)")
            
            self.lblTeamMember.text = selectedString
            print("For Member = \(self.selectedIndexForTeamMember)")
            print("Select id = \(self.selectedID)")
        //    self.callWebService(TypeId: self.typeID, selectedId: self.selectedID)
            
            
        }, cancelAction:{print("cancel")})
    }
    
    @IBAction func btnEventAction(_ sender: Any) {
        StringPickerPopOver.appearFrom(originView: sender as! UIView, baseView: self.btnEventGroup, baseViewController: self, title: "Select Duration", choices: arrWithinEvents.duration , initialRow:selectedIndexForEventsWithin, doneAction: { selectedRow, selectedString in
            print("row \(selectedRow) : \(selectedString)")
            
            self.selectedIndexForEventsWithin = selectedRow
            self.typeID = arrWithinEvents.typeID[self.selectedIndexForEventsWithin]
            self.lblEventGroup.text = selectedString
            print("For Evenyt Within = \(self.selectedIndexForEventsWithin)")
            print("typeid = \(self.typeID)")
            
            self.callWebService(TypeId: self.typeID, selectedId: self.selectedID)
            
        } ,cancelAction: { print("cancel")})
    }
}

extension TestViewController: UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrEventList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let objevent:EventDetail
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let lblEventName:UILabel = cell.contentView.viewWithTag(1) as! UILabel
        let lblLocation:UILabel = cell.contentView.viewWithTag(2) as! UILabel
        let lblCity:UILabel = cell.contentView.viewWithTag(3) as! UILabel
       // let lbldate:UILabel = cell.contentView.viewWithTag(4) as! UILabel
        
        //27/09/2019 Change
        //objevnt = arrEventList[indexPath.row] as! event
        objevent = arrEventList[indexPath.row] as! EventDetail
        
        lblEventName.text = objevent.eventName
        lblLocation.text = objevent.location
        lblCity.text = objevent.city
        
      //  let strDate = Utilities.dateFormatter(Date: objevent.eventDate!, FromString: "yyyy-MM-dd", ToString: "MM/dd/yyyy")
        //lbldate.text = strDate
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
}

extension TestViewController:WebServiceDelegate{
    
    func webServiceResponceSuccess(_ response: Data, apiKey: String)
    {
        self.stopAnimating()
        
        if apiKey == GET_ADD_TEAM_MEMBER_LIST
        {
            let result = handleWebService.handleGetAddTeamMember(response)
            
            if result.Status
            {
                print(result.Status)
                
                let arrTempTeamName = NSMutableArray()
                let arrTempCreatedTimestamp = NSMutableArray()
                let arrTempReportsTo = NSMutableArray()
                let arrTempExportAllowed = NSMutableArray()
                
                for i in 0...result.teamMember.count-1
                {
                    arrTeamName.append(result.teamMember[i].first_name!  + " " + result.teamMember[i].last_name!)
                    arrTempReportsTo.add(result.teamMember[i].reportsTo!)
                    arrTempExportAllowed.add(result.teamMember[i].export_allowed!)
                    arrTeamCreatedTiemStemp.append(result.teamMember[i].created_timestamp!)
                    //arrTempCreatedTimestamp.add(result.teamMember[i].created_timestamp!)
                    
                    
//                    if arrTeamCreatedTiemStemp[i] == objLoginUserDetail.userId
//                    {
//                        lblTeamMember.text = arrTeamName[i]
//                    }
                }
                for i in 0..<arrTeamName.count
                {
                    //arrOfDictionary.append([arrTempTeamName[i] as! String : arrTempReportsTo[i] as! String])
                    arrOfDictionary.append([arrTeamCreatedTiemStemp[i] as! String : arrTempReportsTo[i] as! String])
                }
                //arrTeamName = arrTempTeamName as NSArray as! [String]
                //arrTeamCreatedTiemStemp = arrTempCreatedTimestamp as NSArray as! [String]
                
                if arrTeamCreatedTiemStemp.contains(objLoginUserDetail.userId!)
                {
                    selectedIndexForTeamMember = arrTeamCreatedTiemStemp.index(of: objLoginUserDetail.userId!)!
                }
                
                lblTeamMember.text = arrTeamName[selectedIndexForTeamMember]
                selectedID = arrTeamCreatedTiemStemp[selectedIndexForTeamMember]
                
                if arrWithinEvents.duration.contains("Today")
                {
                    selectedIndexForEventsWithin = arrWithinEvents.duration.index(of: "Today")!
                    typeID = arrWithinEvents.typeID[selectedIndexForEventsWithin]
                    lblEventGroup.text = arrWithinEvents.duration[selectedIndexForEventsWithin]
                }
                
                print("selectid \(selectedID) and typeid \(typeID)")
                
            //    callWebService(TypeId: typeID, selectedId: selectedID)
            }
        }
        
        else if apiKey == GET_EVENTLIST_ENTERPISE_URL_TESTING
        {
            
            let result = handleWebService.handleGetEventListWithin(response)
            print(result.Status)
            //print(result.teamMember)
            
            if result.Status
            {
               // arrEventList = result.arrEvent
                tblview.reloadData()
            }
            else{
                arrEventList.removeAllObjects()
                tblview.reloadData()
            }
        }
    }
    
    func webServiceResponceFailure(_ errorMessage: String) {
       self.stopAnimating()
        
        let alert = UIAlertController(title: "", message: errorMessage,  preferredStyle: .alert)
        let attributedString = Utilities.alertAttribute(titleString: "")
        alert.setValue(attributedString, forKey: "attributedTitle")
        let okAct = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        okAct.setValue(alertbtnColor, forKey: "titleTextColor")
        
        alert.addAction(okAct)
        present(alert,animated: true,completion: nil)
    }
}


//Email
/*extension ConvertedLeadToCustomDetailViewController: MFMailComposeViewControllerDelegate{
    
    func configuredMailComposeViewController(result : JSON) -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        let mailto = objLoginUserDetail.email
        mailComposerVC.setToRecipients([mailto!])
        
        //MASSAGE SUBJECT...
        var subject = result["template_subject"].string
        // subject = subject?.replacingOccurrences(of: "###USER_NAME###", with: selectedObj.firstName!)
        if(objSelectedEvenId != nil)
        {
            isGroup = objSelectedEvenId.isGroup!
            eventsName = objSelectedEvenId.eventName!
        }
        else{
            isGroup = false
            eventsName = "ALL"
        }
        
        if(subject != nil){
            if(isGroup){
                subject = subject?.replacingOccurrences(of: "###EVENT_NAME###", with: eventsName)
            }else{
                subject = subject?.replacingOccurrences(of: "###EVENT_NAME###", with: eventsName)
            }
        }
        mailComposerVC.setSubject(subject! as String)
        
        //MESSAGE BODY....
        var messagebody = result["template_body"].string
        if messagebody != nil{
            print("selectedEvent:\(objSelectedEvenId.eventName)")
            var dtFormatter1: DateFormatter?
            var sentDate: Date?
            var dtFormatter2: DateFormatter?
            dtFormatter1 = DateFormatter()
            dtFormatter1?.dateFormat = "yyyy-MM-dd"
            sentDate = dtFormatter1?.date(from: objSelectedEvenId.eventDate!)
            dtFormatter2 = DateFormatter()
            dtFormatter2?.dateFormat = "MM/dd/yyyy"
            
            if objSelectedEvenId != nil{
                
                if isGroup{
                    messagebody = messagebody?.replacingOccurrences(of: "&amp;", with: "&")
                    messagebody = messagebody?.replacingOccurrences(of: "&lt;", with: "<")
                    messagebody = messagebody?.replacingOccurrences(of: "&gt;", with: ">")
                    messagebody = messagebody?.replacingOccurrences(of: "&apos;", with: "'")
                    messagebody = messagebody?.replacingOccurrences(of: "&quot;", with: "\"")
                    messagebody = messagebody?.replacingOccurrences(of: "###FIRST_NAME###", with: objLoginUserDetail.firstName!)
                    messagebody = messagebody?.replacingOccurrences(of: "###EVENT_NAME###", with:" Group Name: \(objSelectedEvenId.eventName!)")
                    messagebody = messagebody?.replacingOccurrences(of: "###EVENT_DATE###", with: "Group Date:\(dtFormatter2?.string(from: sentDate!))!")
                    messagebody = messagebody?.replacingOccurrences(of: "###EVENT_LOCATION###", with: "Lead Source:\(objSelectedEvenId.location)")
                    messagebody = messagebody?.replacingOccurrences(of: "###TEAM_MEMBER_NAME###", with: "Team Member Name: \(objLoginUserDetail.firstName!), \(objLoginUserDetail.lastName!)")
                }else{
                     messagebody = messagebody?.replacingOccurrences(of: "###FIRST_NAME###", with: objLoginUserDetail.firstName!)
                    
                    if (objSelectedEvenId.createdTimeStamp == "-1") {
                        messagebody = messagebody?.replacingOccurrences(of: "###EVENT_NAME###", with:" Event Name: \(objSelectedEvenId.eventName!)")
                        messagebody = messagebody?.replacingOccurrences(of: "###EVENT_DATE###", with: "-")
                        messagebody = messagebody?.replacingOccurrences(of: "###EVENT_LOCATION###", with: "-")
                    }
                    else{
                        messagebody = messagebody?.replacingOccurrences(of: "###EVENT_NAME###", with:"Event Name: \(objSelectedEvenId.eventName!)")
                        messagebody = messagebody?.replacingOccurrences(of: "###EVENT_DATE###", with: "Event Date:\(dtFormatter2?.string(from: sentDate!))!")
                        messagebody = messagebody?.replacingOccurrences(of: "###EVENT_LOCATION###", with: "Event Location:\(objSelectedEvenId.location)")
                        
                    }
                    messagebody = messagebody?.replacingOccurrences(of: "###TEAM_MEMBER_NAME###", with: "Team Member Name: \(objLoginUserDetail.firstName!), \(objLoginUserDetail.lastName!)")
                }
            }
            else{
                messagebody = messagebody?.replacingOccurrences(of: "###FIRST_NAME###", with: objLoginUserDetail.firstName!)
                messagebody = messagebody?.replacingOccurrences(of: "###EVENT_NAME###", with:" Event Name: \(objSelectedEvenId.eventName!)")
                messagebody = messagebody?.replacingOccurrences(of: "###EVENT_DATE###", with: "-")
                messagebody = messagebody?.replacingOccurrences(of: "###EVENT_LOCATION###", with: "-")
            }
        }
        //messagebody = MessageBody()
        print("topBody:\(messagebody!)")
             
        messagebody = messagebody?.replacingOccurrences(of: "\n", with: "<br />")
        messagebody = messagebody?.replacingOccurrences(of: "\r", with: "")
        messagebody = messagebody?.replacingOccurrences(of: "\t", with: "")
               
        mailComposerVC.setMessageBody(messagebody! , isHTML: true)
        
        let imageData: Data? = self.getImageForReport()
        if imageData != nil {
            mailComposerVC.addAttachmentData(imageData!, mimeType: "image/jpg", fileName: ".jpg")
        }
            
            
            return mailComposerVC
        }
    
        //MARK:Show Send Mail...
        func showSendMailErrorAlert() {
                
            let alert = UIAlertController(title: "", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.",  preferredStyle: .alert)
            let attributedString = Utilities.alertAttribute(titleString: "Could Not Send Email")
            alert.setValue(attributedString, forKey: "attributedTitle")
            let OKAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            OKAction.setValue(alertbtnColor, forKey: "titleTextColor")
                
            alert.addAction(OKAction)
            present(alert,animated: true,completion: nil)
        }
    
    //MARK: Image Get...
    func getImageForReport() -> Data {
        let screenSize: CGSize = ContainerView.frame.size
        let colorSpaceRef: CGColorSpace? = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let ctx = CGContext(data: nil, width: Int(screenSize.width), height: Int(screenSize.height), bitsPerComponent: 8, bytesPerRow: 4 * Int(screenSize.width), space: colorSpaceRef!, bitmapInfo: bitmapInfo.rawValue)
        ctx?.translateBy(x: 0.0, y: screenSize.height)
        ctx?.scaleBy(x: 1.0, y: -1.0)
        ContainerView.layer.render(in: ctx!)
        let cgImage: CGImage = ctx!.makeImage()!
        let image = UIImage(cgImage: cgImage)
        return image.jpegData(compressionQuality: 1.0)!
    }
    
    //MARK:
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
            }
            controller.dismiss(animated: true, completion: nil)
        }
}*/
