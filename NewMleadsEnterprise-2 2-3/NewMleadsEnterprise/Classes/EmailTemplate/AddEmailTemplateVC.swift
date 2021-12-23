//
//  AddEmailTemplateVC.swift
//  NewMleadsEnterprise
//
//  Created by Muzammil Pathan on 22/12/21.
//  Copyright © 2021 com.Tri-Force.MLeadsEnterprise. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class AddEmailTemplateVC: UIViewController,NVActivityIndicatorViewable {

    @IBOutlet weak var txtSubject: UITextField!
    @IBOutlet weak var lblSelectedEventGroup: UILabel!
    @IBOutlet weak var btnPreDefine: UIButton!
    @IBOutlet weak var txtMessage: UITextView!
    
    var isEdit = false
    var selectedMessage:MessageList?
    let webService : WebService = WebService()
    var handleWebService : HandleWebService = HandleWebService()
    var appdelegate = AppDelegate()
    var arrEvents = [EventDetail]()
    var arrEventName = [String]()
    var selectedIndexForEvent = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = (isEdit ? "Edit Email Template" : "Add Email Template")
        self.CallWebServiceGetEventList()
    }
    
    @IBAction func btnSelectEventClick(_ sender: Any) {
        print("Click On Button in TeamManagement")
        StringPickerPopOver.appearFrom(originView: sender as! UIView, baseView: self.lblSelectedEventGroup, baseViewController: self, title: "Select Event", choices: arrEventName , initialRow:selectedIndexForEvent, doneAction: { selectedRow, selectedString in
            print("row \(selectedRow) : \(selectedString)")
            
            self.selectedIndexForEvent = selectedRow
            self.lblSelectedEventGroup.text = selectedString
            //self.callWebService(TypeId: self.typeID, selectedId: self.selectedID)
        }, cancelAction:{print("cancel")})
    }
    
    @IBAction func btnPredefineClick(_ sender: Any) {
        btnPreDefine.isSelected = !btnPreDefine.isSelected
    }
    @IBAction func btnAttachmentsClick(_ sender: Any) {
    }
    @IBAction func btnContinueClick(_ sender: Any) {
        if self.arrEvents.count==0
        {
            let alert = UIAlertController(title: "", message: "No events available!",  preferredStyle: .alert)
            let attributedString = Utilities.alertAttribute(titleString: "Email Template")
            alert.setValue(attributedString, forKey: "attributedTitle")
            let OKAction = UIAlertAction(title: "OK", style: .default, handler: { UIAlertAction in
                
            })
            OKAction.setValue(alertbtnColor, forKey: "titleTextColor")
            
            alert.addAction(OKAction)
            present(alert,animated: true,completion: nil)
            return
        }
        else if self.txtSubject.text!.isEmpty
        {
            let alert = UIAlertController(title: "", message: "Please enter subject!",  preferredStyle: .alert)
            let attributedString = Utilities.alertAttribute(titleString: "Email Template")
            alert.setValue(attributedString, forKey: "attributedTitle")
            let OKAction = UIAlertAction(title: "OK", style: .default, handler: { UIAlertAction in
                
            })
            OKAction.setValue(alertbtnColor, forKey: "titleTextColor")
            
            alert.addAction(OKAction)
            present(alert,animated: true,completion: nil)
            return
        }
        else if self.txtMessage.text!.isEmpty
        {
            let alert = UIAlertController(title: "", message: "Please enter message!",  preferredStyle: .alert)
            let attributedString = Utilities.alertAttribute(titleString: "Email Template")
            alert.setValue(attributedString, forKey: "attributedTitle")
            let OKAction = UIAlertAction(title: "OK", style: .default, handler: { UIAlertAction in
                
            })
            OKAction.setValue(alertbtnColor, forKey: "titleTextColor")
            
            alert.addAction(OKAction)
            present(alert,animated: true,completion: nil)
            return
        }
        if isEdit
        {
            self.CallWebServiceUpdateMessageTemplate()
        }
        else
        {
            self.CallWebServiceAddMessageTemplate()
        }
    }
    func CallWebServiceAddMessageTemplate()
    {
        let param:[String : AnyObject] = ["userId":objLoginUserDetail.createTimeStamp! as AnyObject,
                                          "eventId":self.arrEvents[self.selectedIndexForEvent].eventid! as AnyObject,"subject":txtSubject.text! as AnyObject,"message":txtMessage.text! as AnyObject,"activeStatus":"YES" as AnyObject,"isPrivate":0 as AnyObject,"createdTimeStamp":String(Date.currentTimeStamp) as AnyObject,"updatedTimeStamp":"0" as AnyObject,"attachmentCount":0 as AnyObject,"email_prefix":(btnPreDefine.isSelected ? 1:0) as AnyObject]
        
        print(param)
        //Progress Bar Loding...
        let size = CGSize(width: 30, height: 30)
        startAnimating(size, message: "Loading...", type: NVActivityIndicatorType(rawValue: 29))
        
        webService.doRequestPost(GET_AddFollowUpMessagePost, params: param, key: "addFollowUpMessage", delegate: self)
        
    }
    func CallWebServiceGetEventList()
    {
        let param:[String : AnyObject] = ["userId":objLoginUserDetail.createTimeStamp! as AnyObject]
        
        print(param)
        //Progress Bar Loding...
        let size = CGSize(width: 30, height: 30)
        startAnimating(size, message: "Loading...", type: NVActivityIndicatorType(rawValue: 29))
        
        webService.doRequestPost(GET_EventListforFollowup, params: param, key: "eventList", delegate: self)
        
    }
    func CallWebServiceUpdateMessageTemplate()
    {
        let param:[String : AnyObject] = ["messageId":self.selectedMessage!.messageId! as AnyObject,
                                          "eventId":self.arrEvents[self.selectedIndexForEvent].eventid! as AnyObject,"subject":txtSubject.text! as AnyObject,"message":txtMessage.text! as AnyObject,"activeStatus":"YES" as AnyObject,"isPrivate":0 as AnyObject,"updatedTimeStamp":Date.currentTimeStamp as AnyObject,"attachmentCount":0 as AnyObject,"email_prefix":(btnPreDefine.isSelected ? 1:0) as AnyObject]
        
        print(param)
        //Progress Bar Loding...
        let size = CGSize(width: 30, height: 30)
        startAnimating(size, message: "Loading...", type: NVActivityIndicatorType(rawValue: 29))
        
        webService.doRequestPost(UPDATE_FollowUpMessagePost, params: param, key: "updateFollowUpMessage", delegate: self)
        
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
extension AddEmailTemplateVC: WebServiceDelegate{
   
    func webServiceResponceSuccess(_ response: Data, apiKey: String) {
        stopAnimating()
        
        if apiKey == GET_EventListforFollowup
        {
            print("Event list ...")
            let result = handleWebService.handleGetEventListForEmailTemplate(response)
            print(result.Status)
            arrEvents = [EventDetail]()
            if result.arrEventL.count == 0
            {
                let alert = UIAlertController(title: "", message: "No events available!",  preferredStyle: .alert)
                let attributedString = Utilities.alertAttribute(titleString: "Email Template")
                alert.setValue(attributedString, forKey: "attributedTitle")
                let OKAction = UIAlertAction(title: "OK", style: .default, handler: { UIAlertAction in
                    
                })
                OKAction.setValue(alertbtnColor, forKey: "titleTextColor")
                
                alert.addAction(OKAction)
                present(alert,animated: true,completion: nil)
            }
            else
            {
                arrEvents = result.arrEventL
                self.arrEventName = [String]()
                arrEvents.forEach { event in
                    self.arrEventName.append(event.eventName!)
                }
                selectedIndexForEvent = 0
                lblSelectedEventGroup.text = arrEventName[selectedIndexForEvent]
                if isEdit
                {
                    self.selectedIndexForEvent = self.arrEvents.firstIndex(where: {$0.eventid! == self.selectedMessage!.eventId!}) ?? 0
                    self.lblSelectedEventGroup.text = self.arrEvents[self.selectedIndexForEvent].eventName

                    self.txtSubject.text = self.selectedMessage?.subject
                    self.txtMessage.text = self.selectedMessage?.message
                }
            }
            print("Event List",result.arrEventL)
        }
        else if apiKey == GET_AddFollowUpMessagePost
        {
            let json = JSON(data: response)
            print(json)

            if json["addFollowUpMessage"]["status"].string == "YES"
            {
                let alert = UIAlertController(title: "", message: "Template added successfully.",  preferredStyle: .alert)
                let attributedString = Utilities.alertAttribute(titleString: "Email Template!")
                alert.setValue(attributedString, forKey: "attributedTitle")
                let OKAction = UIAlertAction(title: "OK", style: .default, handler: { UIAlertAction in
                    self.navigationController?.popViewController(animated: true)
                })
                OKAction.setValue(alertbtnColor, forKey: "titleTextColor")
                
                alert.addAction(OKAction)
                present(alert,animated: true,completion: nil)
                print("TRUE")
            }else{
                print("FALSE")
                let alert = UIAlertController(title: "", message:json["addFollowUpMessage"]["error"].string ?? "Something went wrong. please try again!",  preferredStyle: .alert)
                let attributedString = Utilities.alertAttribute(titleString: "Email Template!")
                alert.setValue(attributedString, forKey: "attributedTitle")
                let OKAction = UIAlertAction(title: "OK", style: .default, handler: { UIAlertAction in

                })
                OKAction.setValue(alertbtnColor, forKey: "titleTextColor")
                
                alert.addAction(OKAction)
                present(alert,animated: true,completion: nil)
            }
            
        }
        else if apiKey == UPDATE_FollowUpMessagePost
        {
            let json = JSON(data: response)
            print(json)

            if json["updateFollowUpMessage"]["status"].string == "YES"
            {
                let alert = UIAlertController(title: "", message: "Template updated successfully.",  preferredStyle: .alert)
                let attributedString = Utilities.alertAttribute(titleString: "Email Template!")
                alert.setValue(attributedString, forKey: "attributedTitle")
                let OKAction = UIAlertAction(title: "OK", style: .default, handler: { UIAlertAction in
                    self.navigationController?.popViewController(animated: true)
                })
                OKAction.setValue(alertbtnColor, forKey: "titleTextColor")
                
                alert.addAction(OKAction)
                present(alert,animated: true,completion: nil)
                print("TRUE")
            }else{
                print("FALSE")
                let alert = UIAlertController(title: "", message:json["updateFollowUpMessage"]["error"].string ?? "Something went wrong. please try again!",  preferredStyle: .alert)
                let attributedString = Utilities.alertAttribute(titleString: "Email Template!")
                alert.setValue(attributedString, forKey: "attributedTitle")
                let OKAction = UIAlertAction(title: "OK", style: .default, handler: { UIAlertAction in

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
