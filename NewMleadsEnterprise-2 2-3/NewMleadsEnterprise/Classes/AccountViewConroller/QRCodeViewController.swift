//
//  QRCodeViewController.swift
//  NewMleadsEnterprise
//
//  Created by Triforce New Mac on 26/09/19.
//  Copyright © 2019 com.Tri-Force.MLeadsEnterprise. All rights reserved.
//

import UIKit
import MessageUI
import NVActivityIndicatorView

class QRCodeViewController: UIViewController,NVActivityIndicatorViewable {

    @IBOutlet var imgQRCode: UIImageView!
    var QRCodeString = String()
    var QR = String()
    
    var selectedObj : UserDetail = UserDetail()
    
    var appdelegate = AppDelegate()
    var webservice : WebService = WebService()
    var handleWebService : HandleWebService = HandleWebService()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "My QR Business Card"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image:#imageLiteral(resourceName: "mail-32") , style: .plain, target: self, action: #selector(Email))
        
        imgQRCode.image = {
         //   var qrCode = QRCode(QRCodeString)!
           
            var qrCode = QRCode(QRCodeProfileData())!
            qrCode.size = self.imgQRCode.bounds.size
            qrCode.errorCorrection = .High
            return qrCode.image
        }()
    }
    
    func QRCodeProfileData() -> String{
        
        //QRCodeString.append("MECARD:")
        
        //ADD First Name And Last Name..
        //if ((objUserProfile.firstName) == nil) && ((objUserProfile.lastName) == nil) {
           // QRCodeString.append("N\(objUserProfile.firstName),\(objUserProfile.lastName)")
        QRCodeString.append("MY CARD: \(objLoginUserDetail.firstName!),\(objLoginUserDetail.lastName!),\(objLoginUserDetail.email!),\(objLoginUserDetail.phone!),\(objLoginUserDetail.address!),\(objLoginUserDetail.city!),\(objLoginUserDetail.state!),\(objLoginUserDetail.country!),\(objLoginUserDetail.companyName!)")
        
        //}
        
        print(QRCodeString)
        return QRCodeString
    }
    
    
    @objc func Email()  {
         let param = ["template_code":"QR_CODE_MAIL","userId":objLoginUserDetail.createTimeStamp!,"":"video_id"]
            webservice.doRequestPost(Get_EmailTamplate_API, params: param as [String : AnyObject], key: "getEmailTemplate", delegate: self)
    }
    

    
//    //Email Body Text...
//    func MessageBody() -> String{
//        var message = String()
//
//        message.append(objLoginUserDetail.firstName!)
//
//        return message
//    }
    
}


//MARK:- WEBServices Delegate Method...
extension QRCodeViewController: WebServiceDelegate{
    
    func webServiceResponceSuccess(_ response: Data, apiKey: String) {
        stopAnimating()
     
         if apiKey == Get_EmailTamplate_API {
             let result = handleWebService.getEmailTemplate(response)
             stopAnimating()
             let mailComposeViewController = configuredMailComposeViewController(result: result)
             if MFMailComposeViewController.canSendMail() {
                 self.present(mailComposeViewController, animated: true, completion: nil)
             } else {
                 self.showSendMailErrorAlert()
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


//MARK:- Email Delegate MEthod...
extension QRCodeViewController: MFMailComposeViewControllerDelegate{
    //,MFMailComposeViewControllerDelegate
    
        func configuredMailComposeViewController(result : JSON) -> MFMailComposeViewController {
               let mailComposerVC = MFMailComposeViewController()
               mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
               let mailto = objLoginUserDetail.email
//               mailComposerVC.setToRecipients([mailto!])
               var subject = result["template_subject"].string
              // subject = subject?.replacingOccurrences(of: "###USER_NAME###", with: selectedObj.firstName!)
               mailComposerVC.setSubject(subject! as String)
               var messagebody = result["template_body"].string
            
                //messagebody = MessageBody()
                messagebody = messagebody?.replacingOccurrences(of: "&amp;", with: "&")
                messagebody = messagebody?.replacingOccurrences(of: "&lt;", with: "<")
                messagebody = messagebody?.replacingOccurrences(of: "&gt;", with: ">")
                messagebody = messagebody?.replacingOccurrences(of: "&apos;", with: "'")
                messagebody = messagebody?.replacingOccurrences(of: "&quot;", with: "\"")
                messagebody = messagebody?.replacingOccurrences(of: "###FIRST_NAME###", with: objLoginUserDetail.firstName!)
                messagebody = messagebody?.replacingOccurrences(of: "###FULL_NAME###", with:" \(objLoginUserDetail.firstName!),\(objLoginUserDetail.lastName!)")
                let address  = "\(objLoginUserDetail.address!),\(objLoginUserDetail.city!),\(objLoginUserDetail.state!),\(objLoginUserDetail.country!)"
                messagebody = messagebody?.replacingOccurrences(of: "###ADDRESS###", with:address)
                messagebody = messagebody?.replacingOccurrences(of: "###COMPANY###", with:objLoginUserDetail.companyName!)
              //  messagebody = messagebody?.replacingOccurrences(of: "###WEBSITE###", with:objLoginUserDetail.companyWebsite!)
                messagebody = messagebody?.replacingOccurrences(of: "###PHONE###", with:objLoginUserDetail.phone!)
                messagebody = messagebody?.replacingOccurrences(of: "###EMAIL###", with:objLoginUserDetail.email!)
                
                
              // messagebody = messagebody?.replacingOccurrences(of: "###FIRST_NAME###", with: MessageBody())
               
            
               // messagebody = messagebody?.replacingOccurrences(of: "###USER_NAME###", with: selectedObj.firstName!)
               
               print("topBody:\(messagebody!)")
             
               messagebody = messagebody?.replacingOccurrences(of: "\n", with: "<br />")
               messagebody = messagebody?.replacingOccurrences(of: "\r", with: "")
               messagebody = messagebody?.replacingOccurrences(of: "\t", with: "")
               
               mailComposerVC.setMessageBody(messagebody! , isHTML: true)
               
           
            
               if let image = imgQRCode.image  {
                let imageData: NSData = image.pngData()! as NSData
                mailComposerVC.addAttachmentData(imageData as Data, mimeType: "image/png", fileName: "QRCard.png")
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
