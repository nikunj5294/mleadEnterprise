//
//  CommonWebViewController.swift
//  NewMleadsEnterprise
//
//  Created by Triforce New Mac on 02/12/19.
//  Copyright © 2019 com.Tri-Force.MLeadsEnterprise. All rights reserved.
//

import UIKit
import WebKit
import NVActivityIndicatorView
import MessageUI


class CommonWebViewController: UIViewController,WKNavigationDelegate,NVActivityIndicatorViewable {
    
    var Url = String()
    var webservice : WebService = WebService()
    var handleWebService : HandleWebService = HandleWebService()
    var alertbtnColor = Utilities.alertButtonColor()
    var objSelectedUser : UserDetail = UserDetail()
    
    var objSelectedEvent: EventDetail = EventDetail()
    var isSales = Bool()
    var isLeadByLeadReport = Bool()
    var isGroup: Bool = Bool()
    var eventsName = String()
    @IBOutlet var WebView: WKWebView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.findHamburguerViewController()?.gestureEnabled = false
        
        //Progress Bar Loding...
//        let size = CGSize(width: 30, height: 30)
//        startAnimating(size, message: "Loading...", type: NVActivityIndicatorType(rawValue: 29))
        
        let url = Url
        let webURL = url.replacingOccurrences(of: "", with: "%20", options: [], range: nil)
        
        print(webURL)
        
        print("URL = \(webURL)")
        //if (webURL.contains("pipeline"))
        
        if(webURL.contains("pipeline"))
        {
            self.navigationItem.title = "PipeLine Sales Report"
        }
        else if(webURL.contains("sales"))
        {
            self.navigationItem.title = "Sales Report"
        }
        
        if let url = URL(string: webURL)
        {
            let request = URLRequest(url: url)
            
            WebView.load(request)
        }
        if isSales{
            if (!(webURL.contains("sales"))){
                navigationItem.rightBarButtonItem = UIBarButtonItem(title: "EmailReport" , style: .plain, target: self, action: #selector(emailReport))
            //navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "left-arrow"), style: .plain, target: self, action: #selector(BackButtonAction))
            }
            else{
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "EmailReport" , style: .plain, target: self, action: #selector(emailReport))
            }
        }
        else if (isLeadByLeadReport)
        {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "EmailReport" , style: .plain, target: self, action: #selector(email_Report))
        }
        else
        {
            //navigationItem.rightBarButtonItem = UIBarButtonItem(title: "EmailReport" , style: .plain, target: self, action: #selector(email_report))
        }
    }
    
    //MARK:- Email Report Function Call Sales Report And Pipline Sales Report...
    @objc func emailReport()
    {
        let param = ["template_code":"SALES_REPORT_MOBILE","userId":objLoginUserDetail.createTimeStamp!,"":"video_id"]
        //comment in 8/1/2020
        webservice.doRequestPost(Get_EmailTamplate_API, params: param as [String : AnyObject], key: "getEmailTemplate", delegate: self)
    }
    
    //MARK:- Email Report For # And % Lead By Lead Qualifier....
    @objc func email_Report()
    {
        var msgKey = String()
        if objSelectedEvent != nil{
            if (objSelectedEvent.isGroup == nil){
                msgKey = "%_LEADS_BY_GROUP"
            }
            else
            {
                msgKey = "%_LEADS_BY_EVENT"
            }
        }else{msgKey = "%_OF_LEADS_BY_ALL"}
        
        let param = ["template_code":msgKey,"userId":objLoginUserDetail.createTimeStamp!,"":"video_id"]
        //comment in 8/1/2020
        webservice.doRequestPost(Get_EmailTamplate_API, params: param as [String : AnyObject], key: "getEmailTemplate", delegate: self)
    }

    //MARK:- Email Report For Product Interst Percentage...
    @objc func email_report()
    {
        let param = ["template_code":"PRODUCT_INEREST_BY_PERCENTAGE_MOBILE","userId":objLoginUserDetail.createTimeStamp!,"":"video_id"]
       // webservice.doRequestPost(Get_EmailTamplate_API, params: param as [String : AnyObject], key: "getEmailTemplate", delegate: self)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        stopAnimating()
        
        WebView.frame.size.height = view.frame.size.height
        WebView.frame.size.width = view.frame.size.width
//        webView.frame.size = webView.scrollView.contentSize
    }
   
   
}

//MARK:- WEbservices Method Call
extension CommonWebViewController: WebServiceDelegate{
    
       func webServiceResponceSuccess(_ response: Data, apiKey: String)
       {
           stopAnimating()
            if isSales
            {
                if apiKey == Get_EmailTamplate_API
                {
                    let result = handleWebService.getEmailTemplate(response)
                    stopAnimating()
                    let mailComposeViewController = configuredMailComposeViewController(result: result)
                    if MFMailComposeViewController.canSendMail()
                    {
                        self.present(mailComposeViewController, animated: true, completion: nil)
                    }
                    else
                    {
                        self.showSendMailErrorAlert()
                    }
                }
            }
            else if isLeadByLeadReport
            {
                if apiKey == Get_EmailTamplate_API
                {
                    print("Lead By Lead Email Call...")
                    if apiKey == Get_EmailTamplate_API
                    {
                        let result = handleWebService.getEmailTemplate(response)
                        stopAnimating()
                        let mailComposeViewController = configuredMailComposeViewController(result: result)
                        if MFMailComposeViewController.canSendMail()
                        {
                            self.present(mailComposeViewController, animated: true, completion: nil)
                        }
                        else
                        {
                            self.showSendMailErrorAlert()
                        }
                    }
                }
            }
            else
            {
                if apiKey == Get_EmailTamplate_API
                {
                    print("Product Interest Percentage Email Call...")
                    if apiKey == Get_EmailTamplate_API
                    {
                        let result = handleWebService.getEmailTemplate(response)
                        stopAnimating()
                        let mailComposeViewController = configuredMailComposeViewController(result: result)
                        if MFMailComposeViewController.canSendMail()
                        {
                            self.present(mailComposeViewController, animated: true, completion: nil)
                        }
                        else
                        {
                            self.showSendMailErrorAlert()
                        }
                    }
                }
            }
        }
       
       func webServiceResponceFailure(_ errorMessage: String) {
           stopAnimating()
           
           let alert = UIAlertController(title: "", message: errorMessage,  preferredStyle: .alert)
           let attributedString = Utilities.alertAttribute(titleString: "")
           alert.setValue(attributedString, forKey: "attributedTitle")
           let OKAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
           OKAction.setValue(alertbtnColor, forKey: "titleTextColor")
           
           alert.addAction(OKAction)
           present(alert,animated: true,completion: nil)
           
       }
}

//MARK:- MAIL Delegate MEthod...
extension CommonWebViewController: MFMailComposeViewControllerDelegate{
    
    func configuredMailComposeViewController(result : JSON) -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        
        if isSales{
              mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
              let mailto = objLoginUserDetail.email
//              mailComposerVC.setToRecipients([mailto!])
            var subject = result["template_subject"].string
              //subject = subject?.replacingOccurrences(of: "###USER_NAME###", with: selectedObj.firstName!)
            mailComposerVC.setSubject(subject! as String)
              var messagebody = result["template_body"].string
              messagebody = messagebody?.replacingOccurrences(of: "&amp;", with: "&")
              messagebody = messagebody?.replacingOccurrences(of: "&lt;", with: "<")
              messagebody = messagebody?.replacingOccurrences(of: "&gt;", with: ">")
              messagebody = messagebody?.replacingOccurrences(of: "&apos;", with: "'")
              messagebody = messagebody?.replacingOccurrences(of: "&quot;", with: "\"")
              messagebody = messagebody?.replacingOccurrences(of: "###FIRST_NAME###", with: objLoginUserDetail.firstName!)
              
              messagebody = messagebody?.replacingOccurrences(of: "###USER_NAME###", with: objSelectedUser.firstName!)
              
              print("topBody:\(messagebody)")
            
              messagebody = messagebody?.replacingOccurrences(of: "\n", with: "<br />")
              messagebody = messagebody?.replacingOccurrences(of: "\r", with: "")
              messagebody = messagebody?.replacingOccurrences(of: "\t", with: "")
              
              mailComposerVC.setMessageBody(messagebody! , isHTML: true)
              
              let imageData: Data? = self.getImageForReport()
              if imageData != nil {
                  mailComposerVC.addAttachmentData(imageData!, mimeType: "image/jpg", fileName: ".jpg")
            }
        }
        else if isLeadByLeadReport{
            print("% And # Lead by Lead Qualifire....")
            
            mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
            let mailto = objLoginUserDetail.email
//            mailComposerVC.setToRecipients([mailto!])
            var subject = result["template_subject"].string
            //subject = subject?.replacingOccurrences(of: "###USER_NAME###", with: selectedObj.firstName!)
            
            isGroup = false
            if(objSelectedEvent != nil)
            {
                isGroup = objSelectedEvent.isGroup!
                eventsName = objSelectedEvent.eventName!
            }
            else
            {
                isGroup = false
                eventsName = "ALL"
            }
                 
            if(subject != nil){
                if(isGroup){
                    subject = subject?.replacingOccurrences(of: "###GROUP_NAME###", with: eventsName)
                }else{
                    subject = subject?.replacingOccurrences(of: "###EVENT_NAME###", with: eventsName)
                }
            }
            mailComposerVC.setSubject(subject! as String)
            
            var messagebody = result["template_body"].string
            messagebody = messagebody?.replacingOccurrences(of: "&amp;", with: "&")
            messagebody = messagebody?.replacingOccurrences(of: "&lt;", with: "<")
            messagebody = messagebody?.replacingOccurrences(of: "&gt;", with: ">")
            messagebody = messagebody?.replacingOccurrences(of: "&apos;", with: "'")
            messagebody = messagebody?.replacingOccurrences(of: "&quot;", with: "\"")
            
            //DAte Formate in All Event And Group...
            var dtFormatter1: DateFormatter?
            var sentDate: Date?
            var dtFormatter2: DateFormatter?
            
            if (objSelectedEvent.eventName == "All")
            {
                dtFormatter1 = DateFormatter()
                dtFormatter1?.dateFormat = ""
                sentDate = dtFormatter1?.date(from: "")
                dtFormatter2 = DateFormatter()
                dtFormatter2?.dateFormat = ""
            }
            else
            {
                dtFormatter1 = DateFormatter()
                dtFormatter1?.dateFormat = "yyyy-MM-dd"
                sentDate = dtFormatter1?.date(from: objSelectedEvent.eventDate!)
                dtFormatter2 = DateFormatter()
                dtFormatter2?.dateFormat = "MM/dd/yyyy"
            }
            //IS Group Data And Event ...
            if objSelectedEvent != nil{
                if isGroup
                {
                    if (objSelectedEvent.eventName == "All")
                    {
                        messagebody = messagebody?.replacingOccurrences(of: "###GROUP_DATE###", with: (dtFormatter2?.string(from: sentDate!))!)
                    }
                    else
                    {
                        messagebody = messagebody?.replacingOccurrences(of: "###FIRST_NAME###", with: objLoginUserDetail.firstName!)
                        messagebody = messagebody?.replacingOccurrences(of: "###GROUP_NAME###", with: eventsName)
                        messagebody = messagebody?.replacingOccurrences(of: "###GROUP_DATE###", with: (dtFormatter2?.string(from: sentDate!))!)
                        messagebody = messagebody?.replacingOccurrences(of: "###LEAD_SOURCE###", with: objSelectedEvent.location!)
                    }
                    messagebody = messagebody?.replacingOccurrences(of: "###TEAM_MEMBER_NAME###", with: "\(objSelectedUser.firstName!),\(objSelectedUser.lastName)" )
                }
                else
                {
                    messagebody = messagebody?.replacingOccurrences(of: "###FIRST_NAME###", with: objLoginUserDetail.firstName!)
                    messagebody = messagebody?.replacingOccurrences(of: "###EVENT_NAME###", with: eventsName)
                
                    if (objSelectedEvent.eventName == "All")
                    {
                        messagebody = messagebody?.replacingOccurrences(of: "###EVENT_DATE###", with: "-")
                        messagebody = messagebody?.replacingOccurrences(of: "###EVENT_LOCATION###", with: "-")
                    }
                    else
                    {
                        messagebody = messagebody?.replacingOccurrences(of: "###EVENT_DATE###", with: (dtFormatter2?.string(from: sentDate!))!)
                        messagebody = messagebody?.replacingOccurrences(of: "###EVENT_LOCATION###", with: objSelectedEvent.location!)
                    }
                    //messagebody = messagebody?.replacingOccurrences(of: "###TEAM_MEMBER_NAME###", with: "\(objSelectedUser.firstName!),\(objSelectedUser.lastName)" )
                }
            }
            else
            {
                messagebody = messagebody?.replacingOccurrences(of: "###FIRST_NAME###", with: objLoginUserDetail.firstName!)
            }
            
            print("topBody:\(messagebody)")
            
            messagebody = messagebody?.replacingOccurrences(of: "\n", with: "<br />")
            messagebody = messagebody?.replacingOccurrences(of: "\r", with: "")
            messagebody = messagebody?.replacingOccurrences(of: "\t", with: "")
              
            mailComposerVC.setMessageBody(messagebody! , isHTML: true)
            var imageName = String()
            if (objSelectedEvent != nil)
            {
                if isGroup
                {
                    imageName = " of leads by group and qualifiers\("%")"
                }
                else
                {
                    imageName = " of leads by event and qualifiers\("%")"
                }
            }
            else
            {
                imageName = " of leads by all events & groups and qualifiers\("%")"
            }
            let imageData: Data? = self.getImageForReport()
            if imageData != nil
            {
                mailComposerVC.addAttachmentData(imageData!, mimeType: "image/jpg", fileName: "\(imageName).jpg")
            }
        }
        //PRoduct Interest By Percentage..
        else
        {
            print("Product Interest By Percentage...")
            
            mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
            let mailto = objLoginUserDetail.email
//            mailComposerVC.setToRecipients([mailto!])
            var subject = result["template_subject"].string
            //mailComposerVC.setSubject(subject! as String)
            
            isGroup = false
            if(objSelectedEvent != nil)
            {
                isGroup = objSelectedEvent.isGroup!
                eventsName = objSelectedEvent.eventName!
            }
            else
            {
                isGroup = false
                eventsName = "ALL"
            }
                           
            if(subject != nil)
            {
                if(isGroup){
                    subject = subject?.replacingOccurrences(of: "###EVENT_NAME###", with:"Group Name: %\(eventsName)")
                }else{
                    subject = subject?.replacingOccurrences(of: "###EVENT_NAME###", with: "Event Name: %\(eventsName)")
                }
            }
            mailComposerVC.setSubject(subject! as String)
            
            var messagebody = result["template_body"].string
            messagebody = messagebody?.replacingOccurrences(of: "&amp;", with: "&")
            messagebody = messagebody?.replacingOccurrences(of: "&lt;", with: "<")
            messagebody = messagebody?.replacingOccurrences(of: "&gt;", with: ">")
            messagebody = messagebody?.replacingOccurrences(of: "&apos;", with: "'")
            messagebody = messagebody?.replacingOccurrences(of: "&quot;", with: "\"")
            
            let dtFormatter1 = DateFormatter()
            dtFormatter1.dateFormat = "yyyy-MM-dd"
            let sentDate: Date = dtFormatter1.date(from: objSelectedEvent.eventDate!)!
            let dtFormatter2 = DateFormatter()
            dtFormatter2.dateFormat = "MM/dd/yyyy"
            
            if objSelectedEvent != nil{
                if isGroup
                {
                    messagebody = messagebody?.replacingOccurrences(of: "###FIRST_NAME###", with: objLoginUserDetail.firstName!)
                    messagebody = messagebody?.replacingOccurrences(of: "###EVENT_NAME###", with: "Group Name: %\(eventsName)")
                    messagebody = messagebody?.replacingOccurrences(of: "###EVENT_DATE###", with: "Group Date: %\((dtFormatter2.string(from: sentDate)))")
                    messagebody = messagebody?.replacingOccurrences(of: "###EVENT_LOCATION###", with: "Lead Source: %\(objSelectedEvent.location!)")
                    
                    messagebody = messagebody?.replacingOccurrences(of: "###TEAM_MEMBER_NAME###", with: "Team Member Name:%\(objSelectedUser.firstName!),\(objSelectedUser.lastName)" )
                }
                else
                {
                    messagebody = messagebody?.replacingOccurrences(of: "###FIRST_NAME###", with: objLoginUserDetail.firstName!)
                    //messagebody = messagebody?.replacingOccurrences(of: "###EVENT_NAME###", with: eventsName)
                
                    if (objSelectedEvent.eventName == "-1")
                    {
                        messagebody = messagebody?.replacingOccurrences(of: "###EVENT_NAME###", with: "Name: %\(eventsName)")
                        messagebody = messagebody?.replacingOccurrences(of: "###EVENT_DATE###", with: "")
                        messagebody = messagebody?.replacingOccurrences(of: "###EVENT_LOCATION###", with: "")
                    }
                    else
                    {
                        messagebody = messagebody?.replacingOccurrences(of: "###EVENT_NAME###", with: "Event Name: %\(eventsName)")
                        messagebody = messagebody?.replacingOccurrences(of: "###EVENT_DATE###", with: "Event Date: %\(dtFormatter2.string(from: sentDate))")
                        messagebody = messagebody?.replacingOccurrences(of: "###EVENT_LOCATION###", with: "Event Location: %\(objSelectedEvent.location!)")
                    }
                    messagebody = messagebody?.replacingOccurrences(of: "###TEAM_MEMBER_NAME###", with: "Team Member Name: %\(objSelectedUser.firstName!),\(objSelectedUser.lastName)" )
                }
            }
            else
            {
                messagebody = messagebody?.replacingOccurrences(of: "###FIRST_NAME###", with: objLoginUserDetail.firstName!)
                messagebody = messagebody?.replacingOccurrences(of: "###EVENT_NAME###", with: "Name: %\(eventsName)")
                messagebody = messagebody?.replacingOccurrences(of: "###EVENT_DATE###", with: "")
                messagebody = messagebody?.replacingOccurrences(of: "###EVENT_LOCATION###", with: "")
            }
            print("topBody:\(messagebody)")
            
            messagebody = messagebody?.replacingOccurrences(of: "\n", with: "<br />")
            messagebody = messagebody?.replacingOccurrences(of: "\r", with: "")
            messagebody = messagebody?.replacingOccurrences(of: "\t", with: "")
            
            mailComposerVC.setMessageBody(messagebody! , isHTML: true)
            var imageName = "Product Interest by Percentage"
            
            let imageData: Data? = self.getImageForReport()
            if imageData != nil
            {
                mailComposerVC.addAttachmentData(imageData!, mimeType: "image/jpg", fileName: ".jpg\(imageName)")
            }
        }
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
            
        let alert = UIAlertController(title: "", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.",  preferredStyle: .alert)
        let attributedString = Utilities.alertAttribute(titleString: "Could Not Send Email")
        alert.setValue(attributedString, forKey: "attributedTitle")
        let OKAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        OKAction.setValue(alertbtnColor, forKey: "titleTextColor")
            
        alert.addAction(OKAction)
            present(alert,animated: true,completion: nil)
    }
    
    func getImageForReport() -> Data {
        let screenSize: CGSize = WebView.frame.size
        let colorSpaceRef: CGColorSpace? = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let ctx = CGContext(data: nil, width: Int(screenSize.width), height: Int(screenSize.height), bitsPerComponent: 8, bytesPerRow: 4 * Int(screenSize.width), space: colorSpaceRef!, bitmapInfo: bitmapInfo.rawValue)
        ctx?.translateBy(x: 0.0, y: screenSize.height)
        ctx?.scaleBy(x: 1.0, y: -1.0)
        WebView.layer.render(in: ctx!)
        let cgImage: CGImage = ctx!.makeImage()!
        let image = UIImage(cgImage: cgImage)
        return image.jpegData(compressionQuality: 1.0)!
    }
    
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
            
            let alert = UIAlertController(title: "", message: "Your device could not send e-mail. Please check e-mail configuration and try again.",  preferredStyle: .alert)
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
