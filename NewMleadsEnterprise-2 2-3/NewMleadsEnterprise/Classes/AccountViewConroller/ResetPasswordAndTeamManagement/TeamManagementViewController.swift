//
//  TeamManagementViewController.swift
//  NewMleadsEnterprise
//
//  Created by Triforce New Mac on 21/09/19.
//  Copyright © 2019 com.Tri-Force.MLeadsEnterprise. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class TeamManagementViewController: UIViewController,NVActivityIndicatorViewable {

    @IBOutlet var tblView: UITableView!
    
    let webService : WebService = WebService()
    var handleWebService : HandleWebService = HandleWebService()
    var appdelegate = AppDelegate()
    
    weak var actionToEnable : UIAlertAction?
    var alertViewController = UIAlertController()
    
    var arrManageTeamName = [String]()
    var arrManageTeamCreatedTiemStemp = [String]()
    var arrTeamCreatedTiemStemp = [String]()
    var isTeamMember = String()
    var arrTeamName = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = " ALL Team Member"
        self.findHamburguerViewController()?.gestureEnabled = false
        
        let size = CGSize(width: 30, height: 30)
        startAnimating(size, message: "Loading...", type: NVActivityIndicatorType(rawValue: 29))
        
        //MARK: WEB SERVICES CALL...
        let param:[String : AnyObject] = ["userId":objLoginUserDetail.userId! as AnyObject, "hierarchy_type":"0" as AnyObject]
        
        webService.doRequestPost(GET_ADD_TEAM_MEMBER_LIST, params: param, key: "user", delegate: self)
        
    }
    
    //MARK: TRANSFER LEAD ACTION...
    @IBAction func btnTransferAction(_ sender: AnyObject) {
        
        let buttonTag = sender.tag
        let userID = arrManageTeamCreatedTiemStemp[buttonTag!]
        print(userID)
        
        let alert = UIAlertController(title: "Transfer Team Member", message: "", preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: {(textfield) in
        
            textfield.placeholder = "Firstname*"
            textfield.addTarget(alert, action: #selector(alert.textDidChangeInLoginAlert), for: .editingChanged)
        })
        
        alert.addTextField(configurationHandler: { (textfield2) in
            
            textfield2.placeholder = "Lastname*"
            textfield2.addTarget(alert, action: #selector(alert.textDidChangeInLoginAlert), for: .editingChanged)
        })
        
        alert.addTextField(configurationHandler: { (textfield3) in
            textfield3.placeholder = "Email*"
            textfield3.addTarget(alert, action: #selector(alert.textDidChangeInLoginAlert), for: .editingChanged)
        })
        
        let saveAct = UIAlertAction(title: "Transfer", style: .default, handler: { [weak alert] (_) in
            let textfield = alert?.textFields![0]
            print("TextField Text \(textfield?.text)")
            let textfield2 = alert?.textFields![1]
            print("TextField Text2 \(textfield2?.text)")
            let textfield3 = alert?.textFields![2]
            print("TextField Text3 \(textfield3?.text)")
            
            print("SuccessFull Changed For Transfer...")
            
            let param:[String : AnyObject] = ["userId":objLoginUserDetail.userId as AnyObject,
                                              "memberId":userID as AnyObject,
                                              "first_name":textfield?.text as AnyObject,
                                              "last_name":textfield2?.text as AnyObject,
                                              "email":textfield3?.text as AnyObject]
            
            //Progress Bar Loading...
            let size = CGSize(width: 30, height: 30)
            self.startAnimating(size, message: "Loading...", type: NVActivityIndicatorType(rawValue: 29))
            
            self.webService.doRequestPost(TRANSFER_TEAM_MEMBER_API_URL, params: param, key: "transferMember", delegate: self)
            
            
        })
        saveAct.setValue(Utilities.alertButtonColor(), forKey: "titleTextColor")
        let cancelAct = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        cancelAct.setValue(Utilities.alertButtonColor(), forKey: "titleTextColor")
        alert.addAction(cancelAct)
        alert.addAction(saveAct)
        saveAct.isEnabled = false
        self.present(alert, animated: true, completion: nil)
        
    }
    //MARK: DELETE BUTTON ACTION...
    @IBAction func btnDeleteAction(_ sender: AnyObject) {
        
        let buttonTag = sender.tag
        let userID = self.arrManageTeamCreatedTiemStemp[buttonTag!]
        print(userID)
        
        let alertController = UIAlertController(title: "", message: "Are you sure you want to delete the member?", preferredStyle: .alert)
        let attributedString = Utilities.alertAttribute(titleString: "Delete Team Member")
        alertController.setValue(attributedString, forKey: "attributedTitle")
        let cancelAct = UIAlertAction(title: "Cancel", style: .cancel, handler:{(UIAlertAction) in
            print("Cancelled...!")
        })
        let DeleteAct = UIAlertAction(title: "Delete", style: .default, handler:{ (UIAlertAction) in
            print("Delete Team Member...!")
            
            let param:[String : AnyObject] = ["userId":userID as AnyObject]
            
            //Progress Bar Loading...
            let size = CGSize(width: 30, height: 30)
            self.startAnimating(size, message: "Loading...", type: NVActivityIndicatorType(rawValue: 29))
            
            self.webService.doRequestPost(DELETE_TEAM_MEMBER_API_URL, params: param, key: "deleteMember", delegate: self)
        })
        
        cancelAct.setValue(Utilities.alertButtonColor(), forKey: "titleTextColor")
        DeleteAct.setValue(Utilities.alertButtonColor(), forKey: "titleTextColor")
        alertController.addAction(cancelAct)
        alertController.addAction(DeleteAct)
        self.present(alertController, animated: true, completion: {
            //            print("completion block")
        })
    }
}

//MARK:- Table View DataSource Method Delegate Method...
extension TeamManagementViewController: UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrManageTeamName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TeamMember", for: indexPath)
        
        if arrManageTeamName.count > indexPath.row
        {
            let lblTeamMember : UILabel = cell.contentView.viewWithTag(1001) as! UILabel
            let btnTransfer : UIButton = cell.contentView.viewWithTag(1002) as! UIButton
            let btnDelete : UIButton = cell.contentView.viewWithTag(1003) as! UIButton
            
            
            lblTeamMember.text = arrManageTeamName[indexPath.row]
            btnTransfer.addTarget(self, action: #selector(self.btnTransferAction(_:)), for: .touchUpInside)
            btnDelete.addTarget(self, action: #selector(self.btnDeleteAction(_:)), for: .touchUpInside)
            btnTransfer.tag = indexPath.row
            btnDelete.tag = indexPath.row
            
            return cell
        }
        return cell
    }
}
//MARK:- WebServices Delegate Method...
extension TeamManagementViewController: WebServiceDelegate{
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
                    arrTeamName.append(result.teamMember[i].first_name!  + " " + result.teamMember[i].last_name!)
                    arrTempReportsTo.add(result.teamMember[i].reportsTo!)
                    arrTempExportAllowed.add(result.teamMember[i].export_allowed!)
                    arrTeamCreatedTiemStemp.append(result.teamMember[i].created_timestamp!)
                    //arrTempCreatedTimestamp.add(result.teamMember[i].created_timestamp!)

                    //isTeamMember = "0"
                }
                
                arrManageTeamName = arrTeamName as NSArray as! [String]
                arrManageTeamCreatedTiemStemp = arrTeamCreatedTiemStemp as NSArray as! [String]
                for i in arrManageTeamCreatedTiemStemp{
                    if objLoginUserDetail.userId == i {
                        let index = arrManageTeamCreatedTiemStemp.index(of: i)
                        arrManageTeamName.remove(at: index!)
                        arrManageTeamCreatedTiemStemp.remove(at: index!)
                    }
                }
            }
           
            print("New Arr Team Name = \(arrManageTeamName)")
            print("New Arr Team CreatedTiemStemp = \(arrManageTeamCreatedTiemStemp)")
            tblView.reloadData()
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
//MARK:- UIAlert Controller Method....
extension UIAlertController{
    
    func isValidText(_fname: String) -> Bool{
        return _fname.characters.count > 0
    }
    func isValidLastName(_lname: String) -> Bool
    {
        return _lname.characters.count > 0
    }
    func isValidEmail(_email: String) -> Bool {
        return _email.characters.count > 0
    }
    
    @objc func textDidChangeInLoginAlert()
    {
        if let fname = textFields?[0].text, let lname = textFields?[1].text, let email = textFields?[2].text, let action = actions.last {
            action.isEnabled = isValidLastName(_lname: lname) && isValidText(_fname: fname) && isValidEmail(_email: email)
        }
    }
}
