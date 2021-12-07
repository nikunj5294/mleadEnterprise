//
//  ConvertedLeadToCustomViewController.swift
//  NewMleadsEnterprise
//
//  Created by Triforce New Mac on 03/03/20.
//  Copyright © 2020 com.Tri-Force.MLeadsEnterprise. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import MessageUI

class ConvertedLeadToCustomDetailViewController: UIViewController,NVActivityIndicatorViewable {

    @IBOutlet var lblNumberOfLead: UILabel!
    @IBOutlet var lblLeadConverted: UILabel!
    @IBOutlet var lblAvgExpToConverted: UILabel!
    
    @IBOutlet var ContainerView: UIView!
    
    var objSelectedEvenId:EventDetail = EventDetail()
    
    let webService : WebService = WebService()
    var handleWebService : HandleWebService = HandleWebService()
    var appdelegate = AppDelegate()
    
    var isGroup: Bool = Bool()
    var eventsName = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "ConvertedLead To Custom"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "EmailReport" , style: .plain, target: self, action: #selector(emailReport))
        self.callWebService()
    }
    
    //MARK: Webservices Custom Function Call Method...
    func callWebService()
    {
        let param:[String : AnyObject] = ["userId":objLoginUserDetail.createTimeStamp! as AnyObject,"eventId": objSelectedEvenId.createdTimeStamp as AnyObject,"type": "2" as AnyObject]
        
        //Progress Bar Loding...
        let size = CGSize(width: 30, height: 30)
        startAnimating(size, message: "Loading...", type: NVActivityIndicatorType(rawValue: 29))
        
        webService.doRequestPost(Sales_Cycle_Report_API_URL, params: param, key: "lead", delegate: self)
    }
    
    //MARK: Email WebCall Function...
    @objc func emailReport()  {
        
        let param = ["template_code":"CONVERT_LEAD_TO_CUSTOMER_REPORT_MOBILE","userId":objLoginUserDetail.createTimeStamp!,"":"video_id"]
        //MARK: Progress Bar ....
        let size = CGSize(width: 30, height: 30)
        startAnimating(size, message: "Loading...", type: NVActivityIndicatorType(rawValue: 29))
        webService.doRequestPost(Get_EmailTamplate_API, params: param as [String : AnyObject], key: "getEmailTemplate", delegate: self)
    }
}

//MARK:- Webservices Delegate Method...
extension ConvertedLeadToCustomDetailViewController:WebServiceDelegate{
    
    func webServiceResponceSuccess(_ response: Data, apiKey: String) {
        stopAnimating()
        
        if apiKey == Sales_Cycle_Report_API_URL
        {
            let json = JSON(data: response)
            let result : NSDictionary = json.dictionaryObject! as NSDictionary
//            let data = result.value(forKeyPath: "totalLeads")
//            print(data)
            
            lblNumberOfLead.text = result["totalLeads"] as? String
            lblLeadConverted.text = result["convertedLeads"] as? String
           // lblAvgExpConvert.text = (result["avgDats"] as? String)
            lblAvgExpToConverted.text = String(format: "$%.2f", (result.value(forKeyPath: "avgDats") as? NSNumber)?.floatValue ?? 0.0)
            print(result)
        }
        else if apiKey == Get_EmailTamplate_API
        {
            let result  = handleWebService.getEmailTemplate(response)
            stopAnimating()
            
            // let mailComposeViewController = configuredMailComposeViewController(result: result)
            if MFMailComposeViewController.canSendMail() {
                let mailComposeViewController = configuredMailComposeViewController(result: result)
                self.present(mailComposeViewController, animated: true, completion: nil)
            } else {
                self.showSendMailErrorAlert()
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

//MARK:- Email Delegate MEthod...
extension ConvertedLeadToCustomDetailViewController: MFMailComposeViewControllerDelegate{
    
    func configuredMailComposeViewController(result : JSON) -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        let mailto = objLoginUserDetail.email
//        mailComposerVC.setToRecipients([mailto!])
        
        //MASSAGE SUBJECT...
        var subject = result["template_subject"].string
         //subject = subject?.replacingOccurrences(of: "###USER_NAME###", with: selectedObj.firstName!)
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
    
        //MARK:-Show Send Mail...
        func showSendMailErrorAlert() {
                
            let alert = UIAlertController(title: "", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.",  preferredStyle: .alert)
            let attributedString = Utilities.alertAttribute(titleString: "Could Not Send Email")
            alert.setValue(attributedString, forKey: "attributedTitle")
            let OKAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            OKAction.setValue(alertbtnColor, forKey: "titleTextColor")
                
            alert.addAction(OKAction)
            present(alert,animated: true,completion: nil)
        }
    
    //MARK:- Image Get...
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
    
    //MARK:-
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
}
