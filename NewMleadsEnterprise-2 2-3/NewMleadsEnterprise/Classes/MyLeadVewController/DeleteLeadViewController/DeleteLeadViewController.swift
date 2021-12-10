//
//  DeleteLeadViewController.swift
//  NewMleadsEnterprise
//
//  Created by Muzammil Pathan on 09/12/21.
//  Copyright © 2021 com.Tri-Force.MLeadsEnterprise. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import MessageUI

class DeleteLeadViewController: UIViewController,NVActivityIndicatorViewable {
    @IBOutlet var tblLeadView: UITableView!
    
    let webService : WebService = WebService()
    var handleWebService : HandleWebService = HandleWebService()
    var appdelegate = AppDelegate()
    var selectedEventObj: EventDetail =  EventDetail()
    var arrEventLeadList = NSMutableArray()
    var isMessaging = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = (isMessaging ? "Select Lead" : "Select Specific Leads")
        
        let delete = UIBarButtonItem(title:(isMessaging ? "OK" : "Delete"), style: .plain, target: self, action: (isMessaging ? #selector(self.btnSendMessageClick(_:)) : #selector(self.btnDeleteClick(_:))))//#selector(addTapped)
        self.navigationItem.rightBarButtonItems = [delete]
        self.tblLeadView.register(UINib(nibName: "LeadEventTblCell", bundle: nil), forCellReuseIdentifier: "LeadEventTblCell")
        self.CallWebServiceMyLead()
        // Do any additional setup after loading the view.
    }
    @IBAction func btnSendMessageClick(_ sender: UIButton) {
        var arrLeadPhone = [String]()
        for i in 0..<self.arrEventLeadList.count
        {
            let lead = self.arrEventLeadList[i] as! LeadList
            if lead.isSelected != nil && lead.isSelected == true
            {
                arrLeadPhone.append(lead.phone!)
            }
        }
        if arrLeadPhone.count == 0
        {
            let alert = UIAlertController(title: "", message: "Select any lead to send message!",  preferredStyle: .alert)
            let attributedString = Utilities.alertAttribute(titleString: "Messaging")
            alert.setValue(attributedString, forKey: "attributedTitle")
            let OKAction = UIAlertAction(title: "OK", style: .default, handler: { UIAlertAction in
            })
            OKAction.setValue(alertbtnColor, forKey: "titleTextColor")
            
            alert.addAction(OKAction)
            present(alert,animated: true,completion: nil)
            return
        }
        if (MFMessageComposeViewController.canSendText())
                {
                    let controller = MFMessageComposeViewController()
                    controller.body = ""
                    controller.recipients = arrLeadPhone
                    controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
                }
                else
                {
                    print("Error")
                }
    }
    @IBAction func btnDeleteClick(_ sender: UIButton) {
        var arrLeadIds = [String]()
        for i in 0..<self.arrEventLeadList.count
        {
            let lead = self.arrEventLeadList[i] as! LeadList
            if lead.isSelected != nil && lead.isSelected == true
            {
                arrLeadIds.append(lead.leadId!)
            }
        }
        if arrLeadIds.count == 0
        {
            let alert = UIAlertController(title: "", message: "Select one or more lead to delete!",  preferredStyle: .alert)
            let attributedString = Utilities.alertAttribute(titleString: "Messaging")
            alert.setValue(attributedString, forKey: "attributedTitle")
            let OKAction = UIAlertAction(title: "OK", style: .default, handler: { UIAlertAction in
            })
            OKAction.setValue(alertbtnColor, forKey: "titleTextColor")
            
            alert.addAction(OKAction)
            present(alert,animated: true,completion: nil)
            return
        }
        let alertController = UIAlertController(title: "MLeads", message: "All follow-ups in this lead will be deleted along with tasks and meetings; Are you sure you want to delete the lead?", preferredStyle: .alert)
        
        let alertaction1 = UIAlertAction(title: "Yes", style: .default) { (action) in
            
            let strIDS = arrLeadIds.joined(separator: ",")
            
            let param:[String : AnyObject] = ["userId":objLoginUserDetail.createTimeStamp! as AnyObject, "leadId": (arrLeadIds.count == self.arrEventLeadList.count ? "" : strIDS) as AnyObject, "eventId" : self.selectedEventObj.eventid! as AnyObject, "isDeleteAll" : (arrLeadIds.count == self.arrEventLeadList.count ? 1: 0) as AnyObject]
//            self.objLeadList.createTimeStamp
            //Progress Bar Loding...
            let size = CGSize(width: 30, height: 30)
            self.startAnimating(size, message: "Loading...", type: NVActivityIndicatorType(rawValue: 29))
            
            self.webService.doRequestPost(DELETE_LEAD_API_URL, params: param, key: "deleteLead", delegate: self)
        }
        
        let alertaction2 = UIAlertAction(title: "No", style: .cancel) { (action) in
        }
        
        alertController.addAction(alertaction1)
        alertController.addAction(alertaction2)
        self.present(alertController, animated: true, completion: nil)
    }
    
    //MARK:- Webservices Custom Function Call Method...
    //
    func CallWebServiceMyLead()
    {
        let param:[String : AnyObject] = ["userid":objLoginUserDetail.createTimeStamp! as AnyObject,
                                          "event_id":selectedEventObj.eventid! as AnyObject]
        
        
        print(param)
        //Progress Bar Loding...
        let size = CGSize(width: 30, height: 30)
        startAnimating(size, message: "Loading...", type: NVActivityIndicatorType(rawValue: 29))
        
        webService.doRequestPost(GET_LEADLIST_EVENTWISE, params: param, key: "eventList", delegate: self)
        
    }
}
extension DeleteLeadViewController:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrEventLeadList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let objevnt:event
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeadEventTblCell", for: indexPath) as! LeadEventTblCell
        cell.btnCheckmark.isHidden = false
        cell.selectionStyle = .none
        
        let objevent = arrEventLeadList[indexPath.row] as! LeadList
        if objevent.isSelected != nil && objevent.isSelected == true
        {
            cell.btnCheckmark.isSelected = true
        }
        else
        {
            cell.btnCheckmark.isSelected = false
        }
        if objevent.addedLeadType == "7"{
            cell.lblUserName.text = "Quick Record Lead"
            cell.imgEvent.image = UIImage(named: "play")
            cell.lblCompanyName.text = ""
        }else{
            cell.lblUserName.text = objevent.firstName! + " " + objevent.lastName!
            cell.lblCompanyName.text = objevent.company
            if let url = URL(string: objevent.leadStatusURL!) {
                cell.imgEvent.sd_setImage(with: url, placeholderImage: UIImage(named: "ic_img_user"), options: .continueInBackground)
//                cell.imgEvent.kf.setImage(with: url)
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (arrEventLeadList[indexPath.row] as! LeadList).isSelected == nil || (arrEventLeadList[indexPath.row] as! LeadList).isSelected == false
        {
            (arrEventLeadList[indexPath.row] as! LeadList).isSelected = true
        }
        else
        {
            (arrEventLeadList[indexPath.row] as! LeadList).isSelected = false
        }
        self.tblLeadView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
extension DeleteLeadViewController: WebServiceDelegate{
   
    func webServiceResponceSuccess(_ response: Data, apiKey: String) {
        stopAnimating()
        
        
        if  apiKey == GET_LEADLIST_EVENTWISE
        {
            print("LeadList New...")
            let result = handleWebService.handleGetEventWiseLeadList(response, isMessaging: self.isMessaging)
            print(result.Status)
            arrEventLeadList = NSMutableArray()
            if result.arrLeadList.count == 0
            {
                let alert = UIAlertController(title: "", message: (isMessaging ? "No lead available with phone number!" : "No lead available!"),  preferredStyle: .alert)
                let attributedString = Utilities.alertAttribute(titleString: "Messaging")
                alert.setValue(attributedString, forKey: "attributedTitle")
                let OKAction = UIAlertAction(title: "OK", style: .default, handler: { UIAlertAction in
                    
                })
                OKAction.setValue(alertbtnColor, forKey: "titleTextColor")
                
                alert.addAction(OKAction)
                present(alert,animated: true,completion: nil)
            }
            else
            {
                arrEventLeadList = result.arrLeadList
            }
            tblLeadView.reloadData()
            print("EVENT DIST",result.arrLeadList)
        }
        else if apiKey == DELETE_LEAD_API_URL
        {
            
            let json = JSON(data: response)
            print(json)

            if json["getDeleteLead"]["status"].string == "YES"
            {
                let alert = UIAlertController(title: "", message: "Leads deleted successfully.",  preferredStyle: .alert)
                let attributedString = Utilities.alertAttribute(titleString: "Delete Leads!")
                alert.setValue(attributedString, forKey: "attributedTitle")
                let OKAction = UIAlertAction(title: "OK", style: .default, handler: { UIAlertAction in
                    self.CallWebServiceMyLead()
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
extension DeleteLeadViewController: MFMessageComposeViewControllerDelegate
{
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult)
        {
            controller.dismiss(animated: true) {
                let alert = UIAlertController(title: "", message: "Message sent successfully!",  preferredStyle: .alert)
                let attributedString = Utilities.alertAttribute(titleString: "Messaging")
                alert.setValue(attributedString, forKey: "attributedTitle")
                let OKAction = UIAlertAction(title: "OK", style: .default, handler: { UIAlertAction in
                })
                OKAction.setValue(alertbtnColor, forKey: "titleTextColor")
                
                alert.addAction(OKAction)
                self.present(alert,animated: true,completion: nil)
            }
        }
}
