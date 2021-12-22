//
//  EmailTemplateListVC.swift
//  NewMleadsEnterprise
//
//  Created by Muzammil Pathan on 22/12/21.
//  Copyright © 2021 com.Tri-Force.MLeadsEnterprise. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

struct UserWiseMessageList {
    var member:TeamMember?
    var event:EventDetail?
    var messageList:[MessageList]?
}

class EmailTemplateListVC: UIViewController,NVActivityIndicatorViewable {
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var manageView: UIView!
    let webService : WebService = WebService()
    var handleWebService : HandleWebService = HandleWebService()
    var appdelegate = AppDelegate()
    
    var arrUserWiseMessageList = [UserWiseMessageList]()
    var selectedIndex:IndexPath?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblView.register(EmailTemplateHeaderView.nib, forHeaderFooterViewReuseIdentifier: EmailTemplateHeaderView.reuseIdentifier)

        self.navigationItem.title = "Email Template"
        
        let filter = UIBarButtonItem(image:#imageLiteral(resourceName: "filter"), style: .plain, target: self, action: #selector(self.btnFilter(_:)))//#selector(addTapped)
               
        self.navigationItem.rightBarButtonItems = [filter]
        CallWebServiceToGetFollowUpMessageTemplates_Enterprise()
    }
    @IBAction func btnAddClick(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddEmailTemplateVC") as! AddEmailTemplateVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnFilter(_ sender: Any) {
//        self.FilterView.isHidden = false
    }
    @IBAction func btnDelete(_ sender: Any) {
        self.CallWebServiceToDeleteUpMessageTemplate()
    }
    @IBAction func btnEdit(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddEmailTemplateVC") as! AddEmailTemplateVC
        vc.isEdit = true
        vc.selectedMessage = self.arrUserWiseMessageList[selectedIndex!.section].messageList![selectedIndex!.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func CallWebServiceToGetFollowUpMessageTemplates_Enterprise()
    {
        let param:[String : AnyObject] = ["userId":objLoginUserDetail.createTimeStamp! as AnyObject,
                                          "reportsTo":"1" as AnyObject]
        
        
        print(param)
        //Progress Bar Loding...
        let size = CGSize(width: 30, height: 30)
        startAnimating(size, message: "Loading...", type: NVActivityIndicatorType(rawValue: 29))
        
        webService.doRequestPost(GET_FollowUpMessageTemplates, params: param, key: "leadList", delegate: self)
        
    }
    func CallWebServiceToDeleteUpMessageTemplate()
    {
        let param:[String : AnyObject] = ["messageId":self.arrUserWiseMessageList[selectedIndex!.section].messageList![selectedIndex!.row].messageId! as AnyObject]
        
        print(param)
        //Progress Bar Loding...
        let size = CGSize(width: 30, height: 30)
        startAnimating(size, message: "Loading...", type: NVActivityIndicatorType(rawValue: 29))
        
        webService.doRequestPost(GET_DeleteFollowUpMessage, params: param, key: "deleteFollowUpMessage", delegate: self)
        
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
extension EmailTemplateListVC:UITableViewDataSource,UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.arrUserWiseMessageList.count
    }
        
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: EmailTemplateHeaderView.reuseIdentifier) as? EmailTemplateHeaderView else{ return nil}
        headerView.lblName.text = self.arrUserWiseMessageList[section].member!.first_name! + " " + self.arrUserWiseMessageList[section].member!.last_name!
        headerView.lblEventName.text = self.arrUserWiseMessageList[section].event!.eventName
    
        return headerView
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrUserWiseMessageList[section].messageList!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EmailTemplateCell", for: indexPath) as? EmailTemplateCell else {
                return UITableViewCell()
        }
        cell.selectionStyle = .none
        cell.lblSubject.text = self.arrUserWiseMessageList[indexPath.section].messageList![indexPath.row].subject
        if indexPath == selectedIndex
        {
            cell.contentView.backgroundColor = .lightGray
        }
        else
        {
            cell.contentView.backgroundColor = .white
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndex = indexPath
        self.manageView.isHidden = false
        self.tblView.reloadData()
    }
    
    @objc func tapOnHeaderView(recongnizer:UITapGestureRecognizer)
    {
        let section = recongnizer.view!.tag - 566
        
    }
    
}
extension EmailTemplateListVC: WebServiceDelegate{
   
    func webServiceResponceSuccess(_ response: Data, apiKey: String) {
        stopAnimating()
        
        
        if apiKey == GET_FollowUpMessageTemplates
        {
            print("LeadList New...")
            let result = handleWebService.handleGetMessageList(response)
            print(result.Status)
            arrUserWiseMessageList = [UserWiseMessageList]()
            if result.arrUserWiseMessageList.count == 0
            {
//                self.lblNoData.text = "No message have been sent"
            }
            else
            {
                self.arrUserWiseMessageList = result.arrUserWiseMessageList
            }
            tblView.reloadData()
            print("EVENT DIST",result.arrUserWiseMessageList)
        }
        else if apiKey == GET_DeleteFollowUpMessage
        {
            let json = JSON(data: response)
            print(json)

            if json["getDeleteFollowUpMessage"]["status"].string == "YES"
            {
                let alert = UIAlertController(title: "", message: "Message deleted successfully.",  preferredStyle: .alert)
                let attributedString = Utilities.alertAttribute(titleString: "Delete Message!")
                alert.setValue(attributedString, forKey: "attributedTitle")
                let OKAction = UIAlertAction(title: "OK", style: .default, handler: { UIAlertAction in
                    self.CallWebServiceToGetFollowUpMessageTemplates_Enterprise()
                })
                OKAction.setValue(alertbtnColor, forKey: "titleTextColor")
                
                alert.addAction(OKAction)
                present(alert,animated: true,completion: nil)
                print("TRUE")
            }else{
                print("FALSE")
                let alert = UIAlertController(title: "", message:json["getDeleteFollowUpMessage"]["error"].string ?? "Something went wrong. please try again!",  preferredStyle: .alert)
                let attributedString = Utilities.alertAttribute(titleString: "Delete Message!")
                alert.setValue(attributedString, forKey: "attributedTitle")
                let OKAction = UIAlertAction(title: "OK", style: .default, handler: { UIAlertAction in
                    self.CallWebServiceToGetFollowUpMessageTemplates_Enterprise()
                })
                OKAction.setValue(alertbtnColor, forKey: "titleTextColor")
                
                alert.addAction(OKAction)
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
