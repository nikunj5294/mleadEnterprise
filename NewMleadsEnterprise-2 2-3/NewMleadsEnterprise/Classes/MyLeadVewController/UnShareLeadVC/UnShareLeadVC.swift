//
//  UnShareLeadVC.swift
//  NewMleadsEnterprise
//
//  Created by Muzammil Pathan on 13/12/21.
//  Copyright © 2021 com.Tri-Force.MLeadsEnterprise. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

struct UserWiseLeadList {
    var member:TeamMember?
    var leadList:[LeadList]?
}
class UnShareLeadVC: UIViewController,NVActivityIndicatorViewable {

    @IBOutlet weak var lblNoData: UILabel!
    @IBOutlet weak var lblTeamMember: UILabel!

    @IBOutlet weak var btnUnShare: RoundedButton!
    @IBOutlet weak var tblView: UITableView!
    
    let webService : WebService = WebService()
    var handleWebService : HandleWebService = HandleWebService()
    var appdelegate = AppDelegate()
    var selectedEventObj: EventDetail =  EventDetail()
    var arrTeamMemberList = [TeamMember]()
    var arrUserWiseLeadList = [UserWiseLeadList]()
    var selectedTeamMember: TeamMember?
    var arrTeamName = [String]()
    var selectedIndexForTeamMember = Int()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblView.register(UINib(nibName: "LeadEventTblCell", bundle: nil), forCellReuseIdentifier: "LeadEventTblCell")

        self.navigationItem.title = self.selectedEventObj.eventName
        self.CallWebServiceToGetSharedLeadList()
        
        
    }
    @IBAction func btnTeamMemberClick(_ sender: Any) {
        print("Click On Button in TeamManagement")
        StringPickerPopOver.appearFrom(originView: sender as! UIView, baseView: self.lblTeamMember, baseViewController: self, title: "Select Member", choices: arrTeamName , initialRow:selectedIndexForTeamMember, doneAction: { selectedRow, selectedString in
            print("row \(selectedRow) : \(selectedString)")
            
            self.selectedIndexForTeamMember = selectedRow
            if selectedRow != self.arrTeamMemberList.count
            {
                self.selectedTeamMember = self.arrTeamMemberList[self.selectedIndexForTeamMember]
            }
            else{
                self.selectedTeamMember = nil
            }
           
            self.lblTeamMember.text = selectedString
            self.tblView.reloadData()
            //self.callWebService(TypeId: self.typeID, selectedId: self.selectedID)
        }, cancelAction:{print("cancel")})
    }

    @IBAction func btnUnShareClick(_ sender: Any) {
        var arrLeadIds = [String]()
        for i in 0..<self.arrUserWiseLeadList.count
        {
            for k in 0..<self.arrUserWiseLeadList[i].leadList!.count
            {
                let lead = self.arrUserWiseLeadList[i].leadList![k]
                if lead.isSelected != nil && lead.isSelected == true
                {
                    arrLeadIds.append(lead.sharedID!)
                }
            }
            
        }
        let strIDS = arrLeadIds.joined(separator: ",")
        
        let param:[String : AnyObject] = ["userId":objLoginUserDetail.createTimeStamp! as AnyObject, "shared_leadIds": strIDS as AnyObject]
//            self.objLeadList.createTimeStamp
        //Progress Bar Loding...
        let size = CGSize(width: 30, height: 30)
        self.startAnimating(size, message: "Loading...", type: NVActivityIndicatorType(rawValue: 29))
        
        self.webService.doRequestPost(UN_SHARE_LEAD, params: param, key: "unshareLead", delegate: self)
    }
    //MARK:- Webservices Custom Function Call Method...
    //
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
    func CallWebServiceToGetSharedLeadList()
    {
        let param:[String : AnyObject] = ["userId":objLoginUserDetail.createTimeStamp! as AnyObject,
                                          "eventId":self.selectedEventObj.eventid as AnyObject]
        
        print(param)
        //Progress Bar Loding...
        let size = CGSize(width: 30, height: 30)
        startAnimating(size, message: "Loading...", type: NVActivityIndicatorType(rawValue: 29))
        
        webService.doRequestPost(GET_SHARED_LEAD_LIST, params: param, key: "getSharedLeadList", delegate: self)
        
    }
}
extension UnShareLeadVC: WebServiceDelegate{
   
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
                self.arrTeamName = [String]()
                arrTeamMemberList.forEach { tm in
                    self.arrTeamName.append(tm.first_name! + " " + tm.last_name!)
                }
                selectedIndexForTeamMember = self.arrTeamMemberList.count
                self.arrTeamName.append("All Team Member")
                lblTeamMember.text = arrTeamName[selectedIndexForTeamMember]
                self.CallWebServiceToGetSharedLeadList()

            }
            tblView.reloadData()
            print("TeamMember List",result.arrTeamMember)
            
        }
        else if apiKey == GET_SHARED_LEAD_LIST
        {
            print("LeadList New...")
            let result = handleWebService.handleGetSharedLeadList(response,eventID: self.selectedEventObj.eventid!)
            print(result.Status)
            arrUserWiseLeadList = [UserWiseLeadList]()
            if result.arrUserWiseLead.count == 0
            {
                self.lblNoData.text = "No leads have been shared, in irder to Un-share"
            }
            else
            {
                self.lblNoData.text = ""
                self.arrUserWiseLeadList = result.arrUserWiseLead
                
                arrTeamMemberList = [TeamMember]()
                self.arrTeamName = [String]()
                self.arrUserWiseLeadList.forEach { UL in
                    arrTeamMemberList.append(UL.member!)
                    self.arrTeamName.append(UL.member!.first_name! + " " + UL.member!.last_name!)
                }
                self.selectedTeamMember = nil
                selectedIndexForTeamMember = self.arrTeamMemberList.count
                self.arrTeamName.append("All Team Member")
                lblTeamMember.text = arrTeamName[selectedIndexForTeamMember]
            }
            tblView.reloadData()
            print("EVENT DIST",result.arrUserWiseLead)
        }
        else if apiKey == UN_SHARE_LEAD
        {
            let json = JSON(data: response)
            print(json)

            if json["unshareLead"]["status"].string == "YES"
            {
                let alert = UIAlertController(title: "", message: "Unshare leads successfully.",  preferredStyle: .alert)
                let attributedString = Utilities.alertAttribute(titleString: "Unshare Leads")
                alert.setValue(attributedString, forKey: "attributedTitle")
                let OKAction = UIAlertAction(title: "OK", style: .default, handler: { UIAlertAction in
                    self.CallWebServiceToGetSharedLeadList()
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
extension UnShareLeadVC:UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if selectedTeamMember == nil
        {
            return self.arrUserWiseLeadList.count
        }
        else
        {
            return 1
        }
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selectedTeamMember != nil
        {
            if arrUserWiseLeadList[self.selectedIndexForTeamMember].member!.created_timestamp == selectedTeamMember?.created_timestamp!
            {
                return arrUserWiseLeadList[self.selectedIndexForTeamMember].leadList!.count
            }
            else{
                return 0
            }
            
        }
        else if selectedTeamMember == nil
        {
            return arrUserWiseLeadList[section].leadList!.count
        }
        else
        {
            return 0
        }
        
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if selectedTeamMember != nil && arrUserWiseLeadList[self.selectedIndexForTeamMember].member!.created_timestamp == selectedTeamMember?.created_timestamp!
        {
            let viewBG = UIView(frame: CGRect(x: 8, y: 0, width: tableView.frame.size.width - 16, height: 40))
            let lblHeader = UILabel(frame: CGRect(x: 8, y: 4, width: tableView.frame.size.width - 32, height: 32))
            lblHeader.textColor = .white
            lblHeader.backgroundColor = .lightGray
            lblHeader.text = arrUserWiseLeadList[self.selectedIndexForTeamMember].member!.first_name! + " " + arrUserWiseLeadList[self.selectedIndexForTeamMember].member!.last_name!
            lblHeader.setCornerRadius_Extension(3)
            viewBG.addSubview(lblHeader)
            return viewBG
        }
        else if selectedTeamMember == nil{
            let viewBG = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 40))
            let lblHeader = UILabel(frame: CGRect(x: 8, y: 4, width: tableView.frame.size.width - 16, height: 32))
            lblHeader.textColor = .white
            lblHeader.backgroundColor = .lightGray
            lblHeader.text = arrUserWiseLeadList[section].member!.first_name! + " " + arrUserWiseLeadList[section].member!.last_name!
            lblHeader.setCornerRadius_Extension(3)
            
            viewBG.addSubview(lblHeader)
            return viewBG
        }
        else
        {
            return nil
        }
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        if selectedTeamMember != nil && arrUserWiseLeadList[self.selectedIndexForTeamMember].member!.created_timestamp == selectedTeamMember?.created_timestamp!
//        {
//            return arrUserWiseLeadList[self.selectedIndexForTeamMember].member!.first_name! + " " + arrUserWiseLeadList[self.selectedIndexForTeamMember].member!.last_name!
//        }
//        else if selectedTeamMember == nil{
//            return arrUserWiseLeadList[section].member!.first_name! + " " + arrUserWiseLeadList[section].member!.last_name!
//        }
//        else
//        {
//            return nil
//        }
//
//    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let objevnt:event
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeadEventTblCell", for: indexPath) as! LeadEventTblCell
        cell.btnCheckmark.isHidden = false
        cell.selectionStyle = .none

        if selectedTeamMember != nil && arrUserWiseLeadList[self.selectedIndexForTeamMember].member!.created_timestamp == selectedTeamMember?.created_timestamp!
        {
            let lead = arrUserWiseLeadList[self.selectedIndexForTeamMember].leadList![indexPath.row]

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
        else if selectedTeamMember == nil
        {
            let lead = arrUserWiseLeadList[indexPath.section].leadList![indexPath.row]

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
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedTeamMember != nil && arrUserWiseLeadList[self.selectedIndexForTeamMember].member!.created_timestamp == selectedTeamMember?.created_timestamp!
        {
            if (arrUserWiseLeadList[self.selectedIndexForTeamMember].leadList![indexPath.row]).isSelected == nil || (arrUserWiseLeadList[self.selectedIndexForTeamMember].leadList![indexPath.row]).isSelected == false
                {
                (
                    arrUserWiseLeadList[self.selectedIndexForTeamMember].leadList![indexPath.row]).isSelected = true
                }
                else
                {
                    (arrUserWiseLeadList[self.selectedIndexForTeamMember].leadList![indexPath.row]).isSelected = false
                }
        }
        else
        {
            if (arrUserWiseLeadList[indexPath.section].leadList![indexPath.row]).isSelected == nil || (arrUserWiseLeadList[indexPath.section].leadList![indexPath.row]).isSelected == false
                {
                (
                    arrUserWiseLeadList[indexPath.section].leadList![indexPath.row]).isSelected = true
                }
                else
                {
                    (arrUserWiseLeadList[indexPath.section].leadList![indexPath.row]).isSelected = false
                }
        }
        
            self.tblView.reloadData()
        var isFoundSelected = false
        for i in 0..<arrUserWiseLeadList.count
        {
            for k in 0..<arrUserWiseLeadList[i].leadList!.count
            {
                if (arrUserWiseLeadList[i].leadList![k]).isSelected != nil && (arrUserWiseLeadList[i].leadList![k]).isSelected!
                {
                    isFoundSelected = true
                    break
                }
            }
            
        }
        if isFoundSelected
        {
            self.btnUnShare.isHidden = false
        }
        else{
            self.btnUnShare.isHidden = true
        }

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
