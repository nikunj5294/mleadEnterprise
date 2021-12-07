//
//  ManageExportAbilityViewController.swift
//  NewMleadsEnterprise
//
//  Created by Triforce New Mac on 23/09/19.
//  Copyright © 2019 com.Tri-Force.MLeadsEnterprise. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class ManageExportAbilityViewController: UIViewController,NVActivityIndicatorViewable {

    @IBOutlet var tableView: UITableView!
    let webService : WebService = WebService()
    var handleWebService : HandleWebService = HandleWebService()
    var appdelegate = AppDelegate()
    
    weak var actionToEnable : UIAlertAction?
    var alertViewController = UIAlertController()
    
    var arrManageTeamName = [String]()
    var arrTeamName = [String]()
    var arrTeamCreatedTiemStemp = [String]()
     var arrManageTeamCreatedTiemStemp = [String]()
    
    let arrTempReportsTo = NSMutableArray()
    let reportString = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Manage Export Ability"
        self.findHamburguerViewController()?.gestureEnabled = false
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Update", style: .plain, target: self, action: #selector(btnUpadatTapped))
        
        let size = CGSize(width: 30, height: 30)
        startAnimating(size, message: "Loading...", type: NVActivityIndicatorType(rawValue: 29))
               
        //MARK: WEB SERVICES CALL...
        let param:[String : AnyObject] = ["userId":objLoginUserDetail.createTimeStamp! as AnyObject, "hierarchy_type":"0" as AnyObject]
               
        webService.doRequestPost(GET_ADD_TEAM_MEMBER_LIST, params: param, key: "user", delegate: self)
    }
    //MARK:-Update Button Action...
    @objc func btnUpadatTapped()  {
        print("Button Upadate..")
        //Progress Indication..
        let size = CGSize(width: 30, height: 30)
        startAnimating(size, message: "Loading...", type: NVActivityIndicatorType(rawValue: 29))
        //MARK: WEB SERVICES CALL...
        let param:[String : AnyObject] = ["user_id":objLoginUserDetail.createTimeStamp! as AnyObject,
                                          "allowed_export": objLoginUserDetail.export_allowed as AnyObject]
               
       // webService.doRequestPost(GET_ExportAbility_API_URL, params: param, key: "updateExportAbility", delegate: self)
    }
}
//MARK:- UITebeleView DataSource And Delegate Method...
extension ManageExportAbilityViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return arrManageTeamName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ManageCell", for: indexPath)
               
        if arrManageTeamName.count > indexPath.row
        {
            let lblTeamMember : UILabel = cell.contentView.viewWithTag(101) as! UILabel
            lblTeamMember.text = arrManageTeamName[indexPath.row]
                 //  btnTransfer.addTarget(self, action: #selector(self.btnTransferAction(_:)), for: .touchUpInside)
                  // btnDelete.addTarget(self, action: #selector(self.btnDeleteAction(_:)), for: .touchUpInside)
        }
        
        /*if objLoginUserDetail.export_allowed = "-1"
        {
            print("exportAlloewed")
        }
        else
        {
            cell.selectionStyle = .none
            lblteamMember
            
        }*/
        
     /*   if objLoginUserDetail.export_allowed == "1"
        {
            cell.accessoryType = .checkmark
            cell.tintColor = cell.tintColor.withAlphaComponent(1)
        }
        else{
            cell.accessoryType = .checkmark
            cell.tintColor = cell.tintColor.withAlphaComponent(0)
        }*/
        return cell
    }
    
   /* func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let objUser = arrManageTeamName[indexPath.row] as? UserDetail
        //if arrTempReportsTo{
            
        //}
        if objLoginUserDetail.export_allowed == "-1"
        {
            if objLoginUserDetail.export_allowed == "1"
            {
                (arrManageTeamName[indexPath.row] as? UserDetail)?.export_allowed = "0"
            }else{
                (arrManageTeamName[indexPath.row] as? UserDetail)?.export_allowed = "1"
            }
        }
    }*/
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

//MARK:- WebServices Delegate Method...
extension ManageExportAbilityViewController:WebServiceDelegate{
    func webServiceResponceSuccess(_ response: Data, apiKey: String) {
        stopAnimating()
               
        if apiKey == GET_ADD_TEAM_MEMBER_LIST
        {
            let result = handleWebService.handleGetAddTeamMember(response)
                   
            if result.Status
            {
                       
                let arrTempTeamName = NSMutableArray()
                let arrTempCreatedTimestamp = NSMutableArray()
                
                let arrTempExportAllowed = NSMutableArray()
                       
                for i in 0...result.teamMember.count-1
                {
                    arrTeamName.append(result.teamMember[i].first_name!  + " " + result.teamMember[i].last_name!)
                    arrTempReportsTo.add(result.teamMember[i].reportsTo!)
                    arrTempExportAllowed.add(result.teamMember[i].export_allowed!)
                    arrTeamCreatedTiemStemp.append(result.teamMember[i].created_timestamp!)
                    //arrTempCreatedTimestamp.add(result.teamMember[i].created_timestamp!)

                    //isTeamMember = "0"
                }
                arrManageTeamName = arrTeamName as NSArray as! [String]
                arrManageTeamCreatedTiemStemp = arrTeamCreatedTiemStemp as NSArray as! [String]
                for i in arrManageTeamCreatedTiemStemp
                {
                    if objLoginUserDetail.userId == i
                    {
                        let index = arrManageTeamCreatedTiemStemp.index(of: i)
                        arrManageTeamName.remove(at: index!)
                        arrManageTeamCreatedTiemStemp.remove(at: index!)
                    }
                }
            }
            print("New Arr Team Name = \(arrManageTeamName)")
            print("New Arr Team CreatedTiemStemp = \(arrManageTeamCreatedTiemStemp)")
            tableView.reloadData()
        }
        else if apiKey == GET_ExportAbility_API_URL
        {
            let json = JSON(data: response)
            if json["updateExportAbility"]["status"].string == "YES"
            {
                let alert = UIAlertController(title: "", message: " Completed Successfully.",  preferredStyle: .alert)
                let attributedString = Utilities.alertAttribute(titleString: "Update !")
                alert.setValue(attributedString, forKey: "attributedTitle")
                let okAct = UIAlertAction(title: "OK", style: .default, handler: {UIAlertAction in _ = self.navigationController?.popViewController(animated: true)
                })
                okAct.setValue(alertbtnColor, forKey: "titleTextColor")
                alert.addAction(okAct)
                present(alert,animated: true,completion: nil)
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

