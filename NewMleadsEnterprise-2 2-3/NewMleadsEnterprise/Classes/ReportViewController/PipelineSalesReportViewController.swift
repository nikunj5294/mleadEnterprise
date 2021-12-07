//
//  PipelineSalesReportViewController.swift
//  NewMleadsEnterprise
//
//  Created by Triforce New Mac on 16/10/19.
//  Copyright © 2019 com.Tri-Force.MLeadsEnterprise. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class PipelineSalesReportViewController: UIViewController,NVActivityIndicatorViewable {

    @IBOutlet var btnTeamMember: UIButton!
    @IBOutlet var lblTeamMember: UILabel!
    
    let webService : WebService = WebService()
    var handleWebService : HandleWebService = HandleWebService()
    var appdelegate = AppDelegate()
    
    var arrTeamMamber = [String]()
    var selectedIDForTeamMember = String()
    var selectedIndexForTeamMember = Int()
    var selectedUserID = String()
    var arrTeamCreatedTiemStemp = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Pipeline Sales Report"
        
        //MARK: WEB SERVICES CALL TEAM MEMBER LIST...
        let param:[String : AnyObject] = ["userId":objLoginUserDetail.createTimeStamp! as AnyObject, "hierarchy_type":"1" as AnyObject]
        
        let size = CGSize(width: 30, height: 30)
        startAnimating(size, message: "Loading...", type: NVActivityIndicatorType(rawValue: 29))
        
        webService.doRequestPost(GET_ADD_TEAM_MEMBER_LIST, params: param, key: "user", delegate: self)
        
    }
    
    //MARK:- Button Actoion ..
    @IBAction func btnTeamMemberAction(_ sender: Any) {
        StringPickerPopOver.appearFrom(originView: sender as! UIView, baseView: btnTeamMember , baseViewController: self, title: "Select Member", choices: arrTeamMamber , initialRow:selectedIndexForTeamMember, doneAction: { selectedRow, selectedString in
            print("row \(selectedRow) : \(selectedString)")
            
            self.selectedIndexForTeamMember = selectedRow
            self.selectedUserID = self.arrTeamCreatedTiemStemp[self.selectedIndexForTeamMember]
            self.lblTeamMember.text = selectedString
            
            print("For Member = \(self.selectedIndexForTeamMember)")
            print("Select Member id = \(self.selectedIDForTeamMember)")
            
        },cancelAction: { print("cancel")})
    }
    
    @IBAction func btnGeneratReportAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CommonWebViewController") as! CommonWebViewController
        let request   = ReportURL + GET_PipeLine_Sales_Report + objLoginUserDetail.createTimeStamp!
        
        let urlRequest: String = "\(request)&height=\(self.view.frame.size.height)&width=\(self.view.frame.size.width)"
        vc.Url = urlRequest
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

//MARK:- Webservices Delegate Method...
extension PipelineSalesReportViewController:WebServiceDelegate{
    
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
