//
//  UpgradeViewController.swift
//  NewMleadsEnterprise
//
//  Created by MAC on 04/10/20.
//  Copyright © 2020 com.Tri-Force.MLeadsEnterprise. All rights reserved.
//

import UIKit
import NVActivityIndicatorView


class cellUpgradeData: UITableViewCell {
    @IBOutlet weak var lblTitleObj: UILabel!
    @IBOutlet weak var txtViewObj: UITextView!
    @IBOutlet weak var heightConstraintOfLinkButton: NSLayoutConstraint!
    
    @IBOutlet weak var btnLink: UIButton!
}

class UpgradeViewController: UIViewController,NVActivityIndicatorViewable {

    var arrsections = ["MLeads Paid Subscription Plan","Subscription","iTunes Subscription Terms"]
    var arrTitles = [["➤ Unlimited Leads","➤ Unlimited Access to All Features","➤ No Annual Contract Required","➤ Subscribe for: 3,6,or 12 months","➤ Include all features like Leads research, Leads follow-up, Track Sales, Sales opportunity","➤ Import and Export Leads","➤ Measure Reports"],[],["Your MLeads subscription follows all of Apple's standard iTunes subscription terms and conditions:","1. Payment will be charged to iTunes Account at confirmation of purchase","2. Subscription automatically renews unless autorenew is turned off at least 24-hours before the end of the current period","3. Account will be charged for renewal within 24-hours prior to the end if the current period,and identify the cost of renewal","4. Subscriptions may be managed by the user and auto-renewal may be turned off by going to the user's Account Setting after purchase","5. Any unused portion of a free trial period,if offered, will be forfeited when the user purchases a subscription to that publication,where applicable","For more information please review terms of use and privacy policy on below link https://myleadssite.com/terms.php"]]
    
    @IBOutlet weak var tblViewObj: UITableView!
    @IBOutlet weak var btnTeamMember: UIButton!
    
    @IBOutlet weak var lblMemberName: UILabel!
    
    @IBOutlet weak var viewMemberSelection: UIView!
    
    let webService : WebService = WebService()
    var handleWebService : HandleWebService = HandleWebService()
    var appdelegate = AppDelegate()
    var arrTeamMamber = [String]()
    var arrTeamCreatedTiemStemp = [String]()
    var selectedIndexForTeamMember = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Select Subscription Type"
        callWebService()
        
        viewMemberSelection.layer.borderWidth = 1
        viewMemberSelection.layer.cornerRadius = 5
        viewMemberSelection.layer.borderColor = UIColor(named: "app_theme_color")?.cgColor
        tblViewObj.estimatedRowHeight = 50
        tblViewObj.rowHeight = UITableView.automaticDimension
        tblViewObj.reloadData()
        // Do any additional setup after loading the view.
    }
    
    //MARK:- Button Actions
    @IBAction func btnSelectMemberClicked(_ sender: Any) {
        
            print("Click On Button in TeamManagement")
            StringPickerPopOver.appearFrom(originView: sender as! UIView, baseView: self.btnTeamMember, baseViewController: self, title: "Select Member", choices: arrTeamMamber , initialRow:selectedIndexForTeamMember, doneAction: { selectedRow, selectedString in
                print("row \(selectedRow) : \(selectedString)")
                
                self.selectedIndexForTeamMember = selectedRow
                print("For Member = \(self.selectedIndexForTeamMember)")
            //    self.callWebService(TypeId: self.typeID, selectedId: self.selectedID)
                
                
            }, cancelAction:{print("cancel")})
        
    }
    
    
    //MARK:- Webservices Custom Function Call Method...
      func callWebService()
      {
        
//        "hierarchy_type" = 1;
//           userId = 1602056281;
        
//        key : "userId"
//         - value : 1602056027
//        key : "hierarchy_type"
//        - value : 1
        
//        getAddTeamMemberList.php
//        getAddTeamMemberList.php
        
//        https://www.myleadssite.com/MLeads9.7.22/getAddTeamMemberList.php
//        https://www.myleadssite.com/MLeads9.7.22/getAddTeamMemberList.php
        
//        request string: user={"userId":"1602056281","hierarchy_type":"1"}
        
        
          let param:[String : AnyObject] = ["userId":objLoginUserDetail.userId! as AnyObject,"hierarchy_type": "1" as AnyObject]
          
          //Progress Bar Loding...
          let size = CGSize(width: 30, height: 30)
          startAnimating(size, message: "Loading...", type: NVActivityIndicatorType(rawValue: 29))
          
          webService.doRequestPost(GET_ADD_TEAM_MEMBER_LIST, params: param, key: "user", delegate: self)
      }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension UpgradeViewController : UITableViewDataSource, UITableViewDelegate{

    func numberOfSections(in tableView: UITableView) -> Int {
        return arrsections.count
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrTitles[section].count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return arrsections[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellUpgradeData", for: indexPath) as! cellUpgradeData

//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        
        cell.lblTitleObj?.text = arrTitles[indexPath.section][indexPath.row]
        
        if arrTitles[indexPath.section][indexPath.row].contains("http"){
            
            let wordToRemove = "https://myleadssite.com/terms.php"
            var mainsentence = arrTitles[indexPath.section][indexPath.row]
            if let range = mainsentence.range(of: wordToRemove) {
               mainsentence.removeSubrange(range)
            }
            cell.lblTitleObj?.text = mainsentence
            cell.heightConstraintOfLinkButton.constant = 25
            cell.btnLink.isHidden = false
            cell.btnLink.addTarget(self, action: #selector(clickedOnLink), for: .touchUpInside)
        }else{
            cell.heightConstraintOfLinkButton.constant = 0
            cell.btnLink.isHidden = true
        }
        cell.contentView.layoutIfNeeded()
       
        
//        if (indexPath.section == 2) && (indexPath.row == 6){
//            let attributedString = NSMutableAttributedString(string:"For more information please review terms of use and privacy policy on below link \nhttps://myleadssite.com/terms.php")
//            let linkWasSet = attributedString.setAsLink(textToFind: "https://myleadssite.com/terms.php", linkURL: "https://myleadssite.com/terms.php")
//            cell.textLabel?.attributedText = attributedString
//            if linkWasSet {
//                // adjust more attributedString properties
//            }
//        }
        
        return cell
    }
    
    
    @objc func clickedOnLink(){
        guard let url = URL(string: "https://myleadssite.com/terms.php") else { return }
        UIApplication.shared.open(url)
    }
    
    
    
    
}


extension NSMutableAttributedString {

    public func setAsLink(textToFind:String, linkURL:String) -> Bool {

        let foundRange = self.mutableString.range(of: textToFind)
        if foundRange.location != NSNotFound {
            self.addAttribute(.link, value: linkURL, range: foundRange)
            return true
        }
        return false
    }
}


//MARK:- WEbservices REsponse MEthod...
extension UpgradeViewController: WebServiceDelegate{
   
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
                
                if arrTeamMamber.count > 0{
                    self.lblMemberName.text = arrTeamMamber[0]
                }
                
                print("API calling done...!!!")
                //arrTeamMamber.append("All")
                // arrTeamCreatedTiemStemp.append("100")
                //if arrTeamCreatedTiemStemp.contains(objLoginUserDetail.createTimeStamp!)
                //{
                //    selectedIndexForTeamMember = arrTeamCreatedTiemStemp.index(of: objLoginUserDetail.createTimeStamp!)!
                //}
//                lblTeamMember.text = arrTeamMamber[selectedIndexForTeamMember]
//                selectedUserID = arrTeamCreatedTiemStemp[selectedIndexForTeamMember]
                
            }
            
        }
        //        print("selectid \(selectedID) and typeid \(typeID)")
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
