//
//  TeamMemberVC.swift
//  NewMleadsEnterprise
//
//  Created by Muzammil Pathan on 12/12/21.
//  Copyright © 2021 com.Tri-Force.MLeadsEnterprise. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class TeamMemberVC: UIViewController,NVActivityIndicatorViewable {

    @IBOutlet var tblView: UITableView!
    
    let webService : WebService = WebService()
    var handleWebService : HandleWebService = HandleWebService()
    var appdelegate = AppDelegate()
    var selectedEventObj: EventDetail =  EventDetail()
    var arrTeamMemberList = [TeamMember]()
    var arrLeadList = NSMutableArray()
    var isLeads = false
    var selectedTeamMember = TeamMember()
    var isTransferLeads = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = (isLeads ? "Select Specific Leads" : "Select Team Member")
        if isLeads
        {
            let ok = UIBarButtonItem(title:("OK"), style: .plain, target: self, action: #selector(self.btnOkClick(_:)))//#selector(addTapped)
            self.navigationItem.rightBarButtonItems = [ok]
            self.CallWebServiceToGetNotSharedLeadList()
        }
        else
        {
            self.CallWebServiceToGetAddTeamMemberList()
        }
        
        self.tblView.register(UINib(nibName: "LeadEventTblCell", bundle: nil), forCellReuseIdentifier: "LeadEventTblCell")
        
    }
    
    @IBAction func btnOkClick(_ sender: UIButton) {
        if isTransferLeads
        {
            callAPIToTransferLeads()
        }
        else
        {
            callAPIToShareLead()
        }
    }
    
    //MARK:- Webservices Custom Function Call Method...
    //
    func callAPIToShareLead()
    {
        var arrLeadIds = [String]()
        for i in 0..<self.arrLeadList.count
        {
            let lead = self.arrLeadList[i] as! LeadList
            if lead.isSelected != nil && lead.isSelected == true
            {
                arrLeadIds.append(lead.leadId!)
            }
        }
        if arrLeadIds.count == 0
        {
            let alert = UIAlertController(title: "", message: "Select one or more lead to share!",  preferredStyle: .alert)
            let attributedString = Utilities.alertAttribute(titleString: "Share")
            alert.setValue(attributedString, forKey: "attributedTitle")
            let OKAction = UIAlertAction(title: "OK", style: .default, handler: { UIAlertAction in
            })
            OKAction.setValue(alertbtnColor, forKey: "titleTextColor")
            
            alert.addAction(OKAction)
            present(alert,animated: true,completion: nil)
            return
        }
        let strIDS = arrLeadIds.joined(separator: ",")
        
        let param:[String : AnyObject] = ["currentuserid":objLoginUserDetail.createTimeStamp! as AnyObject, "leadid": strIDS as AnyObject, "eventid" : self.selectedEventObj.eventid! as AnyObject, "teammemberid" : selectedTeamMember.created_timestamp as AnyObject, "type" : "E" as AnyObject]
//            self.objLeadList.createTimeStamp
        //Progress Bar Loding...
        let size = CGSize(width: 30, height: 30)
        self.startAnimating(size, message: "Loading...", type: NVActivityIndicatorType(rawValue: 29))
        
        self.webService.doRequestPost(GET_ADDSHAREDLEAD, params: param, key: "AddShareLead", delegate: self)
    }
    func callAPIToTransferLeads()
    {
        var arrLeadIds = [String]()
        for i in 0..<self.arrLeadList.count
        {
            let lead = self.arrLeadList[i] as! LeadList
            if lead.isSelected != nil && lead.isSelected == true
            {
                arrLeadIds.append(lead.leadId!)
            }
        }
        if arrLeadIds.count == 0
        {
            let alert = UIAlertController(title: "", message: "Select one or more lead to transfer!",  preferredStyle: .alert)
            let attributedString = Utilities.alertAttribute(titleString: "Transfer")
            alert.setValue(attributedString, forKey: "attributedTitle")
            let OKAction = UIAlertAction(title: "OK", style: .default, handler: { UIAlertAction in
            })
            OKAction.setValue(alertbtnColor, forKey: "titleTextColor")
            
            alert.addAction(OKAction)
            present(alert,animated: true,completion: nil)
            return
        }
        let strIDS = arrLeadIds.joined(separator: ",")
        
        let param:[String : AnyObject] = ["userId":objLoginUserDetail.createTimeStamp! as AnyObject, "leadIds": strIDS as AnyObject, "eventId" : self.selectedEventObj.eventid! as AnyObject, "selectedId" : selectedTeamMember.created_timestamp as AnyObject, "type" : "E" as AnyObject]
//            self.objLeadList.createTimeStamp
        //Progress Bar Loding...
        let size = CGSize(width: 30, height: 30)
        self.startAnimating(size, message: "Loading...", type: NVActivityIndicatorType(rawValue: 29))
        
        self.webService.doRequestPost(TRANFER_LEADS, params: param, key: "getTransferLead", delegate: self)
    }
    func CallWebServiceToGetAddTeamMemberList()
    {
        let param:[String : AnyObject] = ["userId":objLoginUserDetail.createTimeStamp! as AnyObject,
                                          "hierarchy_type":"1" as AnyObject]
        
        
        print(param)
        //Progress Bar Loding...
        let size = CGSize(width: 30, height: 30)
        startAnimating(size, message: "Loading...", type: NVActivityIndicatorType(rawValue: 29))
        
        webService.doRequestPost(GET_ADD_TEAM_MEMBER_LIST, params: param, key: "user", delegate: self)
        
    }
    func CallWebServiceToGetNotSharedLeadList()
    {
        let param:[String : AnyObject] = ["userId":objLoginUserDetail.createTimeStamp! as AnyObject,
                                          "event_id":self.selectedEventObj.eventid as AnyObject, "selectedId": self.selectedTeamMember.created_timestamp as AnyObject]
        
        
        print(param)
        //Progress Bar Loding...
        let size = CGSize(width: 30, height: 30)
        startAnimating(size, message: "Loading...", type: NVActivityIndicatorType(rawValue: 29))
        
        webService.doRequestPost(GET_NOT_SHARED_LEAD_LIST, params: param, key: "getNotSharedLeadList", delegate: self)
        
    }
    
}
extension TeamMemberVC: WebServiceDelegate{
   
    func webServiceResponceSuccess(_ response: Data, apiKey: String) {
        stopAnimating()
        
        if  apiKey == GET_ADD_TEAM_MEMBER_LIST
        {
            print("Teammember list ...")
            let result = handleWebService.handleGetAddTeamMemberList(response)
            print(result.Status)
            arrTeamMemberList = [TeamMember]()
            if result.arrTeamMember.count == 0
            {
                let alert = UIAlertController(title: "", message: "No member available!",  preferredStyle: .alert)
                let attributedString = Utilities.alertAttribute(titleString: "Share Leads")
                alert.setValue(attributedString, forKey: "attributedTitle")
                let OKAction = UIAlertAction(title: "OK", style: .default, handler: { UIAlertAction in
                    
                })
                OKAction.setValue(alertbtnColor, forKey: "titleTextColor")
                
                alert.addAction(OKAction)
                present(alert,animated: true,completion: nil)
            }
            else
            {
                arrTeamMemberList = result.arrTeamMember
            }
            tblView.reloadData()
            print("TeamMember List",result.arrTeamMember)
        }
        else if apiKey == GET_NOT_SHARED_LEAD_LIST
        {
            print("LeadList New...")
            let result = handleWebService.handleGetEventWiseLeadList(response, isMessaging: false)
            print(result.Status)
            arrLeadList = NSMutableArray()
            if result.arrLeadList.count == 0
            {
                let alert = UIAlertController(title: "", message: "No lead available!",  preferredStyle: .alert)
                let attributedString = Utilities.alertAttribute(titleString: "Share Leads")
                alert.setValue(attributedString, forKey: "attributedTitle")
                let OKAction = UIAlertAction(title: "OK", style: .default, handler: { UIAlertAction in
                    
                })
                OKAction.setValue(alertbtnColor, forKey: "titleTextColor")
                
                alert.addAction(OKAction)
                present(alert,animated: true,completion: nil)
            }
            else
            {
                arrLeadList = result.arrLeadList
            }
            tblView.reloadData()
            print("EVENT DIST",result.arrLeadList)
        }
        else if apiKey == GET_ADDSHAREDLEAD
        {
            let json = JSON(data: response)
            print(json)

            if json["addShareLead"]["status"].string == "YES"
            {
                let alert = UIAlertController(title: "", message: "Sharing leads completed successfully.",  preferredStyle: .alert)
                let attributedString = Utilities.alertAttribute(titleString: "Share Leads")
                alert.setValue(attributedString, forKey: "attributedTitle")
                let OKAction = UIAlertAction(title: "OK", style: .default, handler: { UIAlertAction in
                    
                })
                OKAction.setValue(alertbtnColor, forKey: "titleTextColor")
                
                alert.addAction(OKAction)
                present(alert,animated: true,completion: nil)
                print("TRUE")
            }else{
                print("FALSE")
            }
        }
        else if apiKey == TRANFER_LEADS
        {
            let json = JSON(data: response)
            print(json)

            if json["addTransferLead"]["status"].string == "YES"
            {
                let alert = UIAlertController(title: "", message: "Transfer leads completed successfully.",  preferredStyle: .alert)
                let attributedString = Utilities.alertAttribute(titleString: "Transfer Leads")
                alert.setValue(attributedString, forKey: "attributedTitle")
                let OKAction = UIAlertAction(title: "OK", style: .default, handler: { UIAlertAction in
                    
                })
                OKAction.setValue(alertbtnColor, forKey: "titleTextColor")
                
                alert.addAction(OKAction)
                present(alert,animated: true,completion: nil)
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
extension TeamMemberVC:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isLeads
        {
            return arrLeadList.count
        }
        else
        {
            return arrTeamMemberList.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let objevnt:event
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeadEventTblCell", for: indexPath) as! LeadEventTblCell
        cell.btnCheckmark.isHidden = false
        cell.selectionStyle = .none
        
        
        
        if isLeads
        {
            let lead = arrLeadList[indexPath.row] as! LeadList

            if lead.isSelected != nil && lead.isSelected == true
            {
                cell.btnCheckmark.isSelected = true
            }
            else
            {
                cell.btnCheckmark.isSelected = false
            }
            if lead.addedLeadType == "7"{
                cell.lblUserName.text = "Quick Record Lead"
                cell.imgEvent.image = UIImage(named: "play")
                cell.lblCompanyName.text = ""
            }else{
                cell.lblUserName.text = lead.firstName! + " " + lead.lastName!
                cell.lblCompanyName.text = lead.company
                if let url = URL(string: lead.leadStatusURL!) {
                    cell.imgEvent.sd_setImage(with: url, placeholderImage: UIImage(named: "ic_img_user"), options: .continueInBackground)
                }
            }
        }
        else
        {
            let teamMember = arrTeamMemberList[indexPath.row]
            cell.lblUserName.text = teamMember.first_name! + " " + teamMember.last_name!
            cell.lblCompanyName.text = ""
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isLeads
        {
            if (arrLeadList[indexPath.row] as! LeadList).isSelected == nil || (arrLeadList[indexPath.row] as! LeadList).isSelected == false
            {
                (arrLeadList[indexPath.row] as! LeadList).isSelected = true
            }
            else
            {
                (arrLeadList[indexPath.row] as! LeadList).isSelected = false
            }
            self.tblView.reloadData()
        }
        else
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "TeamMemberVC") as! TeamMemberVC
            vc.selectedEventObj = self.selectedEventObj
            vc.isLeads = true
            vc.isTransferLeads = self.isTransferLeads
            vc.selectedTeamMember = arrTeamMemberList[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
