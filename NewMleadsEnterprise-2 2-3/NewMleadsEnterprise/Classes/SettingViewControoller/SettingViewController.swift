//
//  SettingViewController.swift
//  NewMleadsEnterprise
//
//  Created by Triforce New Mac on 15/07/19.
//  Copyright © 2019 com.Tri-Force.MLeadsEnterprise. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {
    @IBOutlet var btnMoreOption: UIButton!

    @IBOutlet var btnSystemSetting: UIButton!
    @IBOutlet var viewOnline: UIView!
    @IBOutlet var viewOffline: UIView!
    @IBOutlet var viewMoreOnline: UIView!
    @IBOutlet var viewSystemOnline: UIView!
    @IBOutlet var viewMoreOffline: UIView!
    @IBOutlet var viewSystemOffline: UIView!


    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    @IBAction func btnSystemAction(_ sender: Any) {
        viewOnline.isHidden = false
        viewOffline.isHidden = true
        
        viewMoreOnline.isHidden = true
        viewSystemOnline.isHidden = false
        
        viewMoreOffline.isHidden = true
        viewSystemOffline.isHidden = true

        btnSystemSetting.setBackgroundImage(UIImage(named: "rightBtn_blue_setting_bg_N8_ipad.png"), for: .normal)
        btnMoreOption.setBackgroundImage(UIImage(named: "leftBtn_black_setting_bg_N8_ipad.png"), for: .normal)

        
    }
    @IBAction func btnMoreBtnAction(_ sender: Any) {
        viewOnline.isHidden = false
        viewOffline.isHidden = true
        
        viewMoreOnline.isHidden = false
        viewSystemOnline.isHidden = true
        
        viewMoreOffline.isHidden = true
        viewSystemOffline.isHidden = true

        btnMoreOption.setBackgroundImage(UIImage(named: "rightBtn_blue_setting_bg_N8_ipad.png"), for: .normal)
        btnSystemSetting.setBackgroundImage(UIImage(named: "leftBtn_black_setting_bg_N8_ipad.png"), for: .normal)

       }

    // System buttons
    @IBAction func btnSubscribeAction(_ sender: Any) {
        // SystemOptionScriptionPlan
        let storyboard = UIStoryboard(name: "Setting", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SystemOptionScriptionPlan") as! SystemOptionScriptionPlan
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnSyncAction(_ sender: Any) {
    }
    
    @IBAction func btnProductsAndServices(_ sender: Any) {
        // SystemOptionProductQualifier
        let storyboard = UIStoryboard(name: "Setting", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SystemOptionProductQualifier") as! SystemOptionProductQualifier
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnFollowupAction(_ sender: Any) {
        // SystemOptionFollow_UpAction
        let storyboard = UIStoryboard(name: "Setting", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SystemOptionFollow_UpAction") as! SystemOptionFollow_UpAction
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnCustomLeadStatusAction(_ sender: Any) {
        // SystemOptionLeadQualifiers
        let storyboard = UIStoryboard(name: "Setting", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SystemOptionLeadQualifiers") as! SystemOptionLeadQualifiers
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnCSVAlertAction(_ sender: Any) {
        // CSVFileData
        let storyboard = UIStoryboard(name: "Setting", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CSVFileData") as! CSVFileData
        self.present(vc, animated: true, completion: nil)
        
    }
    
    @IBAction func btnReferFriendAction(_ sender: Any) {
        // SystemsOptionReferralProgram
        let storyboard = UIStoryboard(name: "Setting", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SystemsOptionReferralProgram") as! SystemsOptionReferralProgram
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    // More Information
    
    @IBAction func About(_ sender: Any) {
        // MoreInfoAboutUs
        let storyboard = UIStoryboard(name: "Setting", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MoreInfoAboutUs") as! MoreInfoAboutUs
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func RateApp(_ sender: Any) {
        if let name = URL(string: "https://www.myleadssite.com/refereal_affialiate_programmer.php"), !name.absoluteString.isEmpty {
            let objectsToShare = [name]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)

            self.present(activityVC, animated: true, completion: nil)
        }else  {
            // show alert for not available
        }
    }
    
    @IBAction func Help(_ sender: Any) {
        // MoreInfoHelp
        let storyboard = UIStoryboard(name: "Setting", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MoreInfoHelp") as! MoreInfoHelp
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func FAQ(_ sender: Any) {
        // MoreInfoFAQ
        let storyboard = UIStoryboard(name: "Setting", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MoreInfoFAQ") as! MoreInfoFAQ
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func GetStartedTutorial(_ sender: Any) {
    }
    
    @IBAction func ReferMobile(_ sender: Any) {
        
        let refCon1 = "You will get 10% discount off the subscription price."
        let refCon3 = "Download Link: "
        let temp = "https://www.myleadssite.com/refer_middle_page.php?refer_key="
        let refCon4 = objLoginUserDetail.userId! as AnyObject
        let refCon5 = "I want to refer MLeads"
        
        if let name = URL(string: "\(refCon5)\(refCon3)\(temp)\(refCon4)\(refCon1)"), !name.absoluteString.isEmpty {
            let objectsToShare = [name] 
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)

            self.present(activityVC, animated: true, completion: nil)
        }else  {
            // show alert for not available
        }
    }
    
    @IBAction func TermsOfUse(_ sender: Any) {
        // MoreInfoTermsOfUse
        let storyboard = UIStoryboard(name: "Setting", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MoreInfoTermsOfUse") as! MoreInfoTermsOfUse
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func PrivacyPolicy(_ sender: Any) {
        // MoreInfoPrivacyPolicy
        let storyboard = UIStoryboard(name: "Setting", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MoreInfoPrivacyPolicy") as! MoreInfoPrivacyPolicy
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func Pricing(_ sender: Any) {
        // MoreInfoPricing
        let storyboard = UIStoryboard(name: "Setting", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MoreInfoPricing") as! MoreInfoPricing
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func ChangeLanguage(_ sender: Any) {
    }
    
    @IBAction func SendFeedback(_ sender: Any) {
        // MoreInfoSendFeedback
        let storyboard = UIStoryboard(name: "Setting", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MoreInfoSendFeedback") as! MoreInfoSendFeedback
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
