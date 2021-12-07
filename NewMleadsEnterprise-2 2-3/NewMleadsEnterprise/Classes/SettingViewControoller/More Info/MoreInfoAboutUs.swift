//
//  MoreInfoAboutUs.swift
//  NewMleadsEnterprise
//
//  Created by Akshansh Modi on 28/11/20.
//  Copyright © 2020 com.Tri-Force.MLeadsEnterprise. All rights reserved.
//

import UIKit
import MessageUI

class MoreInfoAboutUs: UIViewController, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var lblAppVersion: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "-"
        self.lblAppVersion.text = "version \(appVersion)"
    }

    @IBAction func ClickWebsite(_ sender: Any) {
        UIApplication.shared.open(NSURL(string: "https://www.myleadssite.com")! as URL)
    }
    
    @IBAction func ClickEmail(_ sender: Any) {
        self.sendEmail()
    }
    
    
    @IBAction func ClickPhone(_ sender: Any) {
        //Create the AlertController and add Its action like button in Actionsheet
        let actionSheetControllerIOS8: UIAlertController = UIAlertController(title: "", message: "Select option for call", preferredStyle: .actionSheet)

        

        let PhoneActionButton = UIAlertAction(title: "Phone", style: .default)
            { _ in
               print("Phone")
                self.callNumber(phoneNumber: "+1 267-263-3178")
        }
        actionSheetControllerIOS8.addAction(PhoneActionButton)

        let FacetimeActionButton = UIAlertAction(title: "Facetime", style: .default)
            { _ in
                print("Facetime")
                self.facetime(phoneNumber: "+1 267-263-3178")
        }
        actionSheetControllerIOS8.addAction(FacetimeActionButton)
        
        let WhatsappActionButton = UIAlertAction(title: "Whatsapp", style: .default)
            { _ in
                print("Whatsapp") // whatsapp
                UIApplication.shared.openURL(URL(string:"https://api.whatsapp.com/send?phone=+1 267-263-3178")!)
        }
        actionSheetControllerIOS8.addAction(WhatsappActionButton)
        
        let SkypeActionButton = UIAlertAction(title: "Skype", style: .default)
            { _ in
                print("Skype")
                let skype: NSURL = NSURL(string: String(format: "skype:"))! //add object skype like this
                if UIApplication.shared.canOpenURL(skype as URL) {
                    UIApplication.shared.openURL(skype as URL)
                 }
                else {
                // skype not Installed in your Device
                    UIApplication.shared.open(URL(string: "http://itunes.com/apps/skype/skype")!)
                }
        }
        actionSheetControllerIOS8.addAction(SkypeActionButton)
        
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            print("Cancel")
        }
        actionSheetControllerIOS8.addAction(cancelActionButton)
        self.present(actionSheetControllerIOS8, animated: true, completion: nil)
    }
    
    
    // Send Mail
    
    func sendEmail() {
      if MFMailComposeViewController.canSendMail() {
        let mail = MFMailComposeViewController()
        mail.mailComposeDelegate = self
        mail.setToRecipients(["support@myleadssite.com"])
        mail.setMessageBody("<p></p>", isHTML: true)

        present(mail, animated: true)
      } else {
        // show failure alert
        print("Cannot send mail")
      }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
      controller.dismiss(animated: true)
    }
    
    
    // Phone Number
    
    private func callNumber(phoneNumber:String) {

      if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {

        let application:UIApplication = UIApplication.shared
        if (application.canOpenURL(phoneCallURL)) {
            application.open(phoneCallURL, options: [:], completionHandler: nil)
        }
      }
      else{
        print("Cannot Open")
        }
    }
    
    // Facetime
    
    private func facetime(phoneNumber:String) {
      if let facetimeURL:NSURL = NSURL(string: "facetime://\(phoneNumber)") {
        let application:UIApplication = UIApplication.shared
        if (application.canOpenURL(facetimeURL as URL)) {
            application.openURL(facetimeURL as URL);
        }
      }
    }

}
